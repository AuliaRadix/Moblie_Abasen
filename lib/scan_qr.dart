import 'package:flutter/material.dart';
import 'dart:async';
import 'dashboard.dart';
import 'list_matakuliah.dart';
import 'profil.dart';
import 'izin.dart';
import 'fixed_fab.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> with SingleTickerProviderStateMixin {
  int _step = 1; // 1: scan, 2: process, 3: result
  bool _isSuccess = false;
  
  late AnimationController _beamController;
  late Animation<double> _beamAnimation;
  Timer? _timer;

  final Color _maroon = const Color(0xFF800020);
  final Color _maroonDark = const Color(0xFF5A0016);
  final Color _maroonLight = const Color(0xFFC0003A);

  @override
  void initState() {
    super.initState();
    _beamController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _beamAnimation = Tween<double>(begin: 0, end: 230).animate(_beamController);
    _beamController.repeat();

    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _beamController.dispose();
    super.dispose();
  }

  String _getDateStr() {
    final now = DateTime.now();
    final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    final weekdays = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return "${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}";
  }

  String _getTimeStr() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  void _simulateScanSuccess() {
    setState(() {
      _step = 2;
      _beamController.duration = const Duration(milliseconds: 400);
      _beamController.repeat();
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _step = 3;
        _isSuccess = true;
        _beamController.stop();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Presensi berhasil dicatat!"),
          backgroundColor: Color(0xFF198754),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _simulateScanFail() {
    setState(() {
      _step = 2;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _step = 3;
        _isSuccess = false;
        _beamController.stop();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Scan gagal. QR tidak valid."),
          backgroundColor: Color(0xFFDC3545),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _resetScan() {
    setState(() {
      _step = 1;
      _isSuccess = false;
      _beamController.duration = const Duration(seconds: 2);
      _beamController.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTopHeader(),
                _buildStepIndicator(),
                _buildScanViewport(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: _step == 3 ? _buildResultCard() : _buildScanButtons(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 68,
        width: 68,
        margin: const EdgeInsets.only(top: 30),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_maroonDark, _maroonLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: _maroon.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ],
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: const Center(
              child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: const FixedCenterDockedFabLocation(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_maroonDark, _maroon],
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Scan QR Presensi',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Arahkan kamera ke QR code dosen',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepDot(1),
                _buildStepLine(2),
                _buildStepDot(2),
                _buildStepLine(3),
                _buildStepDot(3),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Text(
              _step == 1 ? "Langkah 1: Mulai scan kamera" : 
              (_step == 2 ? "Langkah 2: Memproses QR Code..." : "Langkah 3: Selesai"),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDot(int dotStep) {
    bool isDone = dotStep < _step;
    bool isActive = dotStep == _step;
    
    Color bgColor = isDone ? const Color(0xFF198754) : Colors.white;
    Color borderColor = isDone ? const Color(0xFF198754) : (isActive ? _maroon : Colors.grey.shade300);
    Color textColor = isDone ? Colors.white : (isActive ? _maroon : Colors.grey.shade400);

    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(
        child: isDone
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : Text("$dotStep", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }

  Widget _buildStepLine(int targetStep) {
    bool isDone = targetStep <= _step;
    return Expanded(
      child: Container(
        height: 2,
        color: isDone ? const Color(0xFF198754) : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildScanViewport() {
    return Container(
      height: 320,
      color: const Color(0xFF1A1A2E),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 230,
            height: 230,
            child: Stack(
              children: [
                // Corner TL
                Positioned(
                  top: 0, left: 0,
                  child: Container(
                    width: 30, height: 30,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFFFD700), width: 3),
                        left: BorderSide(color: Color(0xFFFFD700), width: 3),
                      ),
                    ),
                  ),
                ),
                // Corner TR
                Positioned(
                  top: 0, right: 0,
                  child: Container(
                    width: 30, height: 30,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFFFD700), width: 3),
                        right: BorderSide(color: Color(0xFFFFD700), width: 3),
                      ),
                    ),
                  ),
                ),
                // Corner BL
                Positioned(
                  bottom: 0, left: 0,
                  child: Container(
                    width: 30, height: 30,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFFFD700), width: 3),
                        left: BorderSide(color: Color(0xFFFFD700), width: 3),
                      ),
                    ),
                  ),
                ),
                // Corner BR
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 30, height: 30,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFFFD700), width: 3),
                        right: BorderSide(color: Color(0xFFFFD700), width: 3),
                      ),
                    ),
                  ),
                ),
                // QR Placeholder
                Center(
                  child: Container(
                    width: 230, height: 230,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.15), width: 1, style: BorderStyle.none),
                    ),
                    child: Center(
                      child: Icon(Icons.qr_code, size: 80, color: Colors.white.withOpacity(0.15)),
                    ),
                  ),
                ),
                // Dashed border inside
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    // Just a subtle indicator, avoiding full dashed border package dependency for simplicity.
                    child: Container(color: Colors.transparent),
                  ),
                ),
                // Beam
                if (_step < 3)
                  AnimatedBuilder(
                    animation: _beamAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: _beamAnimation.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Color(0xFFFFD700), Colors.transparent],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          // Status Badge
          Positioned(
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _step == 1 ? Colors.amber.shade700 : (_step == 2 ? Colors.lightBlue : (_isSuccess ? const Color(0xFF198754) : const Color(0xFFDC3545))),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _step == 1 ? Icons.videocam : (_step == 2 ? Icons.sync : (_isSuccess ? Icons.check : Icons.warning)), 
                    color: Colors.white, size: 14
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _step == 1 ? "Menunggu QR..." : (_step == 2 ? "Memproses..." : (_isSuccess ? "Terdeteksi!" : "Gagal...")), 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanButtons() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              _buildInfoRow(Icons.person, "Andi Pratama  M001"),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.calendar_today, _getDateStr()),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.access_time, _getTimeStr()),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: _simulateScanSuccess,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          label: const Text("Simulasi: Scan Berhasil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF198754),
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 4,
            shadowColor: const Color(0xFF198754).withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _simulateScanFail,
          icon: const Icon(Icons.cancel, color: Color(0xFFDC3545)),
          label: const Text("Simulasi: Scan Gagal", style: TextStyle(color: Color(0xFFDC3545), fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFFDC3545).withOpacity(0.05),
            side: const BorderSide(color: Color(0xFFDC3545), width: 2),
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 24),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 16, color: Colors.grey),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Pada implementasi nyata, kamera perangkat akan diaktifkan untuk membaca QR Code dari layar dosen.", 
                style: TextStyle(fontSize: 11, color: Colors.grey)
              )
            ),
          ]
        )
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(icon, color: _maroon, size: 18),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF555555), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(_isSuccess ? "✅" : "❌", style: const TextStyle(fontSize: 60)),
          const SizedBox(height: 12),
          Text(
            _isSuccess ? "Presensi Berhasil!" : "Scan Gagal!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _isSuccess ? const Color(0xFF198754) : const Color(0xFFDC3545),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSuccess ? "Kehadiran Anda telah tercatat oleh sistem." : "QR Code tidak valid atau sudah kadaluarsa. Hubungi dosen Anda.",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          if (_isSuccess)
            Column(
              children: [
                _buildResultRow(Icons.book, "Mata Kuliah", "Algoritma & Pemrograman"),
                const SizedBox(height: 8),
                _buildResultRow(Icons.calendar_today, "Tanggal", _getDateStr()),
                const SizedBox(height: 8),
                _buildResultRow(Icons.access_time, "Waktu", _getTimeStr()),
                const SizedBox(height: 8),
                _buildResultRow(Icons.person, "Status", "HADIR ✓", valColor: const Color(0xFF198754)),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDC3545).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Color(0xFFDC3545), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "QR Code telah expired atau di luar area yang diizinkan.", 
                      style: TextStyle(color: Color(0xFFDC3545), fontSize: 12)
                    )
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _resetScan,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text("Scan Lagi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _maroon,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(IconData icon, String label, String val, {Color? valColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: _maroon, size: 16),
          const SizedBox(width: 8),
          Text("$label:", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              val,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: valColor ?? Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Beranda', 0),
            _buildNavItem(Icons.menu_book, 'Mata Kuliah', 1),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(Icons.description, 'Izin', 2),
            _buildNavItem(Icons.person, 'Profil', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        Widget? targetPage;
        if (index == 0) targetPage = const DashboardScreen();
        if (index == 1) targetPage = const ListMatakuliahScreen();
        if (index == 2) targetPage = const IzinScreen();
        if (index == 3) targetPage = const ProfilScreen();
        
        if (targetPage != null) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => targetPage!,
              transitionDuration: Duration.zero,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}