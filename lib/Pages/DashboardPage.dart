// lib/dashboard_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Tokens from your HTML
  static const Color bgColor = Color(0xFFF8F9FC);
  static const Color textColor = Color(0xFF0D131C);
  static const Color primary900 = Color(0xFF094EBE);
  static const Color primary800 = Color(0xFF0771F6);
  static const Color cardBg = Colors.white;
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const double cardRadius = 16;

  // state
  String? _selectedDriveName;
  String? _selectedDriveImageUrl;
  String _selectedPasses = '3 Passes (Recommended)';
  final List<String> _passesOptions = [
    '1 Pass',
    '2 Passes',
    '3 Passes (Recommended)',
    '4 Passes',
    '5 Passes',
    '6 Passes',
    '7 Passes',
  ];

  // sample images (from your HTML). We'll map a few drive names to those URLs:
  final Map<String, String> _sampleDrives = {
    'Internal SSD — 512GB': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBecMcdVakUiolM-Xj_ggQ3cWm-Q5gIJ1BqY6Y0_oMR4WClvkny8MPgkJZLJ9Bz6rxiOj_7WzcZ30bj2B8U97qEppDXrvC_lg1c8xG-4CYdfn7kzcrhjJCdoSzvOZ9QLahYl_ofuXlRg2jf2ZAHpL0DR-NzG8JIe-kLRNIl115vp8keldnLHKlzK-fKDiQqeUKDu8nsQYUijYlKoJficFi5k0zJOum3tulKGFzNBHgamaXGx9updqcDlZhJALCmSgHL6pJeZAfX1hI',
    'External HDD — 2TB': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDp3jrqiE_sENFRM1UmzlD_IJxnCf7SRWlTdlWOdU28KP71QD2ZeBTrabXQBJXTFwqJmm7KJkvHRnXR_7DjP1WxgJhyhoTlLhoTTk2AVjvtn7vt6cyGsosvKNQwPyfWXcDEfrxtcnPKPymWMpYUTyWzrxkew3IX5w1GyBz3brgyDKDJ8S7kKneXX00shJet0b7YO4ksHwb7uY-WupPTQqE_knsw3ADCoqfvjNnxqdykdVwRTsgnGoeV4eO2bctMTMu2o2JNaNZZW_s',
    'USB Drive — 64GB': 'https://via.placeholder.com/150?text=USB+64GB',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  // back icon (removed const because textColor is non-const)
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Secure Data Wipe',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                  // placeholder for right side to match HTML (empty box)
                  Container(width: 40, height: 40),
                ],
              ),
            ),

            // Content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 6),
                    // Drive Selection Card
                    Card(
                      color: cardBg,
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(cardRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // left: text + button
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Drive Selection',
                                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700,color: Colors.black),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Select the drive you want to securely wipe.',
                                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: _onBrowseDrives,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: slate100,
                                      foregroundColor: Colors.grey[850],
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Browse Drives'),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.chevron_right, size: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // right: thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 96,
                                height: 96,
                                color: Colors.grey[200],
                                child: _selectedDriveImageUrl != null
                                    ? Image.network(
                                  _selectedDriveImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _drivePlaceholder(),
                                )
                                    : _drivePlaceholder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Wipe Settings Card
                    Card(
                      color: cardBg,
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // left text + select
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Wipe Settings', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700,color: Colors.black)),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Configure the number of overwrite passes for secure data deletion.',
                                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 12),
                                  // Dropdown
                                  Container(
                                    decoration: BoxDecoration(
                                      color: slate100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedPasses,
                                        isExpanded: true,
                                        items: _passesOptions.map((p) {
                                          return DropdownMenuItem(value: p, child: Text(p, style: GoogleFonts.inter(fontWeight: FontWeight.w600,color: Colors.black)));
                                        }).toList(),
                                        onChanged: (v) {
                                          if (v == null) return;
                                          setState(() => _selectedPasses = v);
                                        },
                                        icon: const Icon(Icons.expand_more, color: Colors.black54),
                                        dropdownColor: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // right thumbnail (another image)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 96,
                                height: 96,
                                color: Colors.grey[200],
                                child: Image.network(
                                  // use the second sample or placeholder
                                  _sampleDrives.values.elementAt(1),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _drivePlaceholder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Security level strip
                    Container(
                      decoration: BoxDecoration(
                        color: slate100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: primary900.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.shield, color: primary900),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Security level: ',
                                style: GoogleFonts.inter(fontSize: 14,color: Colors.black),
                                children: [
                                  TextSpan(text: 'High', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Footer with Start Wipe button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardBg,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _selectedDriveName != null ? _onStartWipe : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedDriveName != null ? primary900 : primary900.withOpacity(0.45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    child: const Text('Start Wipe'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drivePlaceholder() {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey[200],
      child: Icon(Icons.storage, color: Colors.grey[500], size: 36), // changed to Icons.storage
    );
  }

  // simulate browse drives (dialog)
  void _onBrowseDrives() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DrivelistBottomSheet(drives: _sampleDrives);
      },
    );

    if (selected != null && mounted) {
      // selected holds the key drive name
      setState(() {
        _selectedDriveName = selected;
        _selectedDriveImageUrl = _sampleDrives[selected];
      });
    }
  }

  // start wipe -> push a progress page (simulated)
  void _onStartWipe() {
    if (_selectedDriveName == null) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => WipeProgressPage(
      driveName: _selectedDriveName!,
      passes: _selectedPasses,
    )));
  }
}

/// Bottom sheet showing drive choices (simple simulated list)
class DrivelistBottomSheet extends StatelessWidget {
  final Map<String, String> drives;
  const DrivelistBottomSheet({super.key, required this.drives});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 4, width: 36, margin: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 6),
            Text('Select Drive', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: drives.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, idx) {
                  final name = drives.keys.elementAt(idx);
                  final url = drives.values.elementAt(idx);
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.storage), // changed to Icons.storage
                        ),
                      ),
                    ),
                    title: Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    subtitle: Text(idx == 0 ? 'Internal' : idx == 1 ? 'External' : 'Removable', style: GoogleFonts.inter(fontSize: 12)),
                    onTap: () => Navigator.of(context).pop(name),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/// Simple simulated wipe progress page (offline)
class WipeProgressPage extends StatefulWidget {
  final String driveName;
  final String passes;
  const WipeProgressPage({super.key, required this.driveName, required this.passes});

  @override
  State<WipeProgressPage> createState() => _WipeProgressPageState();
}

class _WipeProgressPageState extends State<WipeProgressPage> {
  double _progress = 0;
  late Timer _timer;
  int _currentPass = 0;
  final int _totalPasses = 3; // we'll derive later from widget.passes if desired

  @override
  void initState() {
    super.initState();
    // derive passes number from string like "3 Passes (Recommended)"
    final match = RegExp(r'(\d+)').firstMatch(widget.passes);
    final passes = match != null ? int.tryParse(match.group(1)!) ?? 3 : 3;
    _currentPass = 0;
    _startSimulation(passes);
  }

  void _startSimulation(int passes) {
    final totalMs = 5000; // total simulated duration
    final tickMs = 150;
    final numTicks = totalMs ~/ tickMs;
    int tickCount = 0;
    _timer = Timer.periodic(Duration(milliseconds: tickMs), (t) {
      tickCount++;
      setState(() => _progress = (tickCount / numTicks).clamp(0.0, 1.0));
      // update passes roughly evenly
      final passNow = ((tickCount / numTicks) * passes).floor();
      if (passNow > _currentPass && passNow <= passes) {
        setState(() => _currentPass = passNow);
      }
      if (tickCount >= numTicks) {
        t.cancel();
        // finished
        if (mounted) {
          // show completion dialog and pop back to dashboard
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Wipe Complete'),
              content: Text('Drive ${widget.driveName} wiped successfully (${widget.passes}).'),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), child: const Text('Done')),
              ],
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wipe Progress', style: GoogleFonts.inter(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(height: 6),
            LinearProgressIndicator(value: _progress, minHeight: 8),
            const SizedBox(height: 16),
            Text('${(_progress * 100).toStringAsFixed(0)}%', style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Status: In secure wipe operation', style: GoogleFonts.inter(color: Colors.grey[700])),
            const SizedBox(height: 18),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Method', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      Text('DoD 5220.22-M', style: GoogleFonts.inter(color: Colors.grey[700])),
                    ]),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Passes completed', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      Text('$_currentPass', style: GoogleFonts.inter(color: Colors.grey[700])),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _currentPass + 1,
                itemBuilder: (ctx, idx) {
                  final passed = idx < _currentPass;
                  return ListTile(
                    leading: Icon(passed ? Icons.check_circle : Icons.timelapse, color: passed ? Colors.green : Colors.orange),
                    title: Text('Pass ${idx + 1} ${passed ? 'complete' : 'in progress'}', style: GoogleFonts.inter()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
