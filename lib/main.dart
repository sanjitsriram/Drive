// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Pages/DashboardPage.dart';
import 'Pages/LoginPage.dart';

// Replace with your real pages


/// ----------
/// App Colors / Tokens
/// ----------
class AppColors {
  static const primary = Color(0xFF0B63FF);
  static const accent = Color(0xFFFF7A59);
  static const bg = Color(0xFFF9FAFB);
  static const card = Colors.white;
  static const text = Color(0xFF1E293B);
  static const muted = Color(0xFF64748B);
  static const success = Color(0xFF16A34A);
}

class AppSizes {
  static const borderRadius = 14.0;
  static const spacing = 12.0;
}

/// ----------
/// AuthState: handles local token only (offline mode)
/// ----------
class AuthState extends ChangeNotifier {
  String? _token;
  bool _isLoading = false;

  String? get token => _token;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  bool get isLoading => _isLoading;

  Future<void> loadFromStorage() async {
    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    await Future.delayed(const Duration(milliseconds: 250)); // smooth splash
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signIn(String token) async {
    _isLoading = true;
    notifyListeners();
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await Future.delayed(const Duration(milliseconds: 400));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await Future.delayed(const Duration(milliseconds: 250));
    _isLoading = false;
    notifyListeners();
  }
}

/// ----------
/// Entry point
/// ----------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock portrait mode (remove if you want landscape too)
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const AppEntry());
}

/// ----------
/// AppEntry: sets up providers and theme
/// ----------
class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
      ],
      child: const ThemeProviderWrapper(),
    );
  }
}

/// ----------
/// ThemeProviderWrapper: theme + MaterialApp
/// ----------
class ThemeProviderWrapper extends StatelessWidget {
  const ThemeProviderWrapper({super.key});

  ThemeData _buildLightTheme() {
    final base = ThemeData.light();
    return base.copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.light),
      scaffoldBackgroundColor: AppColors.bg,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark),
      scaffoldBackgroundColor: const Color(0xFF0B1220),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0F1724),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: _buildLightTheme(),
      child: Builder(
        builder: (themeContext) {
          return MaterialApp(
            title: 'Secure Wipe',
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: ThemeMode.system,
            home: const AppBootstrap(),
          );
        },
      ),
    );
  }
}

/// ----------
/// AppBootstrap: splash + initial route
/// ----------
class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  bool _bootComplete = false;

  @override
  void initState() {
    super.initState();
    _initBoot();
  }

  Future<void> _initBoot() async {
    final auth = Provider.of<AuthState>(context, listen: false);
    await auth.loadFromStorage();
    setState(() => _bootComplete = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_bootComplete) return const _SplashScreen();

    final auth = Provider.of<AuthState>(context, listen: false);
    return auth.isAuthenticated ? const AppShell() : const LoginPage();
  }
}

/// ----------
/// Splash Screen (offline, mythic design)
/// ----------
class _SplashScreen extends StatelessWidget {
  const _SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 18),
            Text('Secure Wipe', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Offline First. Rock Solid.', style: GoogleFonts.inter(color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}

/// ----------
/// AppShell for authenticated users
/// ----------
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthState>(context);
    return LoadingOverlay(
      isLoading: auth.isLoading,
      progressIndicator: const CircularProgressIndicator.adaptive(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async => await auth.signOut(),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: const DashboardPage(),
      ),
    );
  }
}
