// lib/login_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Make sure you have a DashboardPage in lib/dashboard_page.dart
import 'DashboardPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;
  bool _remember = false;
  bool _isSigningIn = false;

  // Exact color tokens from your HTML
  static const Color _bg = Color(0xFFF8F9FC);
  static const Color _primary = Color(0xFF094EBE);
  static const Color _primaryHover = Color(0xFF0844A9);
  static const Color _muted = Color(0xFF49699C);
  static const Color _text = Color(0xFF0D131C);
  static const Color _border = Color(0xFFCED8E8);

  // basic email regex for client-side validation
  final RegExp _emailRegExp = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");

  // Embedded SVGs from your HTML
  final String _googleSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><g><path d="M47.532 24.5528C47.532 22.9214 47.3998 21.29 47.1166 19.71H24.2344V28.7621H37.3214C36.7593 31.8443 35.0344 34.4532 32.5579 36.1421V41.5265H40.043C44.9217 37.0218 47.532 31.3328 47.532 24.5528Z" fill="#4285F4"/><path d="M24.2344 48.0001C30.7337 48.0001 36.1438 45.8979 40.043 41.5265L32.5579 36.1421C30.2974 37.6621 27.502 38.6225 24.2344 38.6225C18.1759 38.6225 13.0655 34.6318 11.233 29.2156H3.54785V34.7439C7.40935 42.5458 15.2155 48.0001 24.2344 48.0001Z" fill="#34A853"/><path d="M11.233 29.2155C10.7687 27.8841 10.5 26.4679 10.5 24.9999C10.5 23.5318 10.7687 22.1156 11.233 20.7842V15.2559H3.54785C1.28738 19.7606 0 24.7932 0 30.7842C0 36.7753 1.28738 41.8079 3.54785 46.3125L11.2705 29.2155H11.233Z" fill="#FBBC05"/><path d="M24.2344 9.37732C28.0563 9.37732 31.0772 10.824 33.5163 13.1098L40.2319 6.64391C36.1251 2.92391 30.715 0 24.2344 0C15.2155 0 7.40935 5.45427 3.54785 13.2562L11.233 18.7845C13.0655 13.3682 18.1759 9.37732 24.2344 9.37732Z" fill="#EA4335"/></g></svg>''';

  final String _appleSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M17.252 12.022C17.252 11.238 17.844 10.534 18.736 10.522C19.624 10.51 20.352 11.122 20.364 12.01C20.376 13.438 19.9 14.83 19.016 15.946C18.256 16.906 17.168 17.65 15.932 17.902C14.752 18.142 13.516 17.926 12.448 17.302C11.968 17.038 11.536 16.714 11.164 16.326C10.748 15.902 10.428 15.402 10.228 14.842C9.568 13.018 10.06 10.93 11.492 9.538C12.188 8.866 13.084 8.446 14.048 8.35C14.24 8.326 14.44 8.35 14.624 8.422C14.664 8.438 14.692 8.474 14.696 8.518L14.864 10.21C14.872 10.282 14.82 10.346 14.748 10.366C14.096 10.512 13.484 10.836 13.012 11.314C12.184 12.214 12.044 13.51 12.628 14.578C12.872 15.014 13.236 15.368 13.684 15.614C14.712 16.162 15.98 16.03 16.824 15.262C17.124 14.998 17.328 14.662 17.428 14.29C17.48 14.11 17.396 13.918 17.232 13.842L15.936 13.23C15.82 13.174 15.688 13.214 15.616 13.314C15.524 13.446 15.488 13.614 15.52 13.774C15.62 14.218 15.424 14.686 15.016 14.914C14.544 15.178 13.968 15.114 13.584 14.754C13.536 14.71 13.492 14.658 13.46 14.602C13.46 14.598 13.46 14.598 13.456 14.594C13.268 14.322 13.204 13.986 13.284 13.666C13.312 13.562 13.356 13.462 13.416 13.37C13.668 12.986 14.124 12.758 14.6 12.79C15.064 12.822 15.468 13.106 15.648 13.518C15.672 13.582 15.736 13.622 15.804 13.61L17.252 13.298V12.022Z" fill="black"/><path d="M12.0625 6.03516C12.9238 5.01691 14.0722 4.25413 15.3785 3.8207C15.811 3.66795 16.2573 3.56316 16.7125 3.50916C16.9265 3.48316 17.1325 3.57116 17.2225 3.75316L17.3785 4.04716C17.4725 4.22916 17.3825 4.45316 17.1985 4.54916C16.0365 5.15116 15.0345 6.00716 14.3185 7.04316C13.9205 7.61116 13.6265 8.24316 13.4545 8.91116C13.3825 9.17716 13.1185 9.33316 12.8525 9.26116L12.7065 9.21916C12.4405 9.14716 12.2845 8.88316 12.3565 8.61716C12.5565 7.84516 12.9065 7.12716 13.3825 6.49716C13.0225 6.31516 12.6305 6.16516 12.2145 6.04916C12.1865 6.04116 12.1625 6.03716 12.1425 6.03516H12.0625Z" fill="black"/></svg>''';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateFields);
    _passwordController.removeListener(_validateFields);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    return email.isNotEmpty && _emailRegExp.hasMatch(email) && password.isNotEmpty;
  }

  // triggers a rebuild to update button state
  void _validateFields() => setState(() {});

  @override
  Widget build(BuildContext context) {
    // width constraint similar to tailwind max-w-sm (~360)
    final double cardMaxWidth = 360;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: cardMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // logo
                  SizedBox(
                    height: 72,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.watch_later_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Heading
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: _text,
                      height: 1.05,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to access your secure dashboard',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: _muted,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Inputs
                  Column(
                    children: [
                      _buildInputWithLeadingIcon(
                        icon: Icons.mail_outlined,
                        hint: 'Email Address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                      ),
                      const SizedBox(height: 12),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          _buildInputWithLeadingIcon(
                            icon: Icons.lock_outline,
                            hint: 'Password',
                            controller: _passwordController,
                            obscureText: _obscure,
                          ),
                          Positioned(
                            right: 12,
                            child: IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32),
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: _muted),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Remember + forgot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => setState(() => _remember = !_remember),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: _border),
                                color: _remember ? _primary : Colors.white,
                                boxShadow: [
                                  if (_remember)
                                    BoxShadow(color: _primary.withOpacity(0.12), blurRadius: 6, offset: const Offset(0, 2))
                                ],
                              ),
                              child: _remember ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                            ),
                            const SizedBox(width: 8),
                            Text('Remember me', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: _text)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(60, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: Text('Forgot password?', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _primary)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Sign in button (disabled until form valid)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isFormValid && !_isSigningIn ? _onSignInPressed : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid ? _primary : _primary.withOpacity(0.5),
                        foregroundColor: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        shadowColor: _primary.withOpacity(0.3),
                        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      child: _isSigningIn
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Sign In'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Divider with text
                  Row(children: [
                    Expanded(child: Container(height: 1, color: _border)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0), child: Text('or continue with', style: GoogleFonts.inter(color: _muted, fontSize: 13))),
                    Expanded(child: Container(height: 1, color: _border)),
                  ]),

                  const SizedBox(height: 20),

                  // Social buttons
                  Row(children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Colors.white,
                          foregroundColor: _text,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: _border)),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          SvgPicture.string(_googleSvg, width: 20, height: 20),
                          const SizedBox(width: 8),
                          Text('Google', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Colors.white,
                          foregroundColor: _text,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: _border)),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          SvgPicture.string(_appleSvg, width: 18, height: 18),
                          const SizedBox(width: 8),
                          Text('Apple', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 28),

                  // Footer signup text
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(color: _muted, fontSize: 13),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Sign up',
                          style: GoogleFonts.inter(color: _primary, fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // helper input builder
  Widget _buildInputWithLeadingIcon({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(icon, color: _muted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: GoogleFonts.inter(color: _text, fontSize: 15),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(color: _muted),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  // On sign in: simulate delay then navigate to DashboardPage (offline)
  Future<void> _onSignInPressed() async {
    if (!_isFormValid || _isSigningIn) return;
    setState(() => _isSigningIn = true);

    // small UX delay
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isSigningIn = false);

    // Navigate offline to DashboardPage (replace current)
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardPage()));
  }
}
