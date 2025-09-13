// lib/complete_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WipeCompletePage extends StatefulWidget {
  final String method;
  final String securityLevel;
  final int totalPasses;

  const WipeCompletePage({
    super.key,
    this.method = 'Overwrite',
    this.securityLevel = 'High',
    this.totalPasses = 3,
  });

  @override
  State<WipeCompletePage> createState() => _WipeCompletePageState();
}

class _WipeCompletePageState extends State<WipeCompletePage> with SingleTickerProviderStateMixin {
  // Theme tokens (from your HTML)
  static const Color _primary = Color(0xFF094EBE);
  static const Color _bg = Color(0xFFF8F9FC);
  static const Color _text = Color(0xFF111827);
  static const Color _muted = Color(0xFF6B7280);
  static const Color _green = Color(0xFF16A34A);

  late final AnimationController _pingController;
  late final Animation<double> _pingAnim;

  @override
  void initState() {
    super.initState();
    _pingController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _pingAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _pingController, curve: Curves.easeOut));
    _pingController.repeat();
  }

  @override
  void dispose() {
    _pingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double avatarSize = 120;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Material(
                    color: Colors.white,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(999),
                    child: InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: const Icon(Icons.arrow_back, color: Colors.grey),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Wipe Complete',
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: _text),
                  ),
                  const Spacer(flex: 1),
                  SizedBox(width: 40), // placeholder to match HTML right-side spacing
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Big center check with ping
                    SizedBox(
                      height: avatarSize + 40,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // ping animation
                            AnimatedBuilder(
                              animation: _pingAnim,
                              builder: (context, child) {
                                final value = _pingAnim.value;
                                return Container(
                                  width: avatarSize * (1.0 + value * 0.9),
                                  height: avatarSize * (1.0 + value * 0.9),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _green.withOpacity((1.0 - value) * 0.18),
                                  ),
                                );
                              },
                            ),

                            // solid circle with icon
                            Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: BoxDecoration(
                                color: _green,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: _green.withOpacity(0.22), blurRadius: 20, offset: const Offset(0, 8)),
                                ],
                              ),
                              child: const Center(
                                child: Icon(Icons.check, size: 64, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Secure Wipe Complete',
                      style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: _text),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your data has been successfully and securely erased.',
                      style: GoogleFonts.inter(fontSize: 14, color: _muted),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Wipe details card
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Wipe Details', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: _text)),
                            const SizedBox(height: 12),
                            _detailRow('Method Used', widget.method),
                            const SizedBox(height: 10),
                            _detailRowWithBadge('Security Level', widget.securityLevel),
                            const SizedBox(height: 10),
                            _detailRow('Total Passes', '${widget.totalPasses}'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Activity Log
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Activity Log', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: _text)),
                    ),
                    const SizedBox(height: 12),

                    Column(
                      children: List.generate(widget.totalPasses, (i) {
                        final passNum = i + 1;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              title: Text('Pass $passNum', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: _text)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, color: _green, size: 22),
                                  const SizedBox(width: 8),
                                  Text('Complete', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: _green)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),

            // Footer button (sticky)
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, -4))],
              ),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      // Return to dashboard — pop until first route (assumes main dashboard is initial)
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 12,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      shadowColor: _primary.withOpacity(0.22),
                      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    child: const Text('Return to Dashboard'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.inter(color: _muted)),
        Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: _text)),
      ],
    );
  }

  Widget _detailRowWithBadge(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.inter(color: _muted)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _green.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: _green)),
        ),
      ],
    );
  }
}
