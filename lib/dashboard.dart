import 'package:flutter/material.dart';

import 'list_matakuliah.dart';
import 'profil.dart';
import 'scan_qr.dart';
import 'services/session_manager.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final _session = SessionManager.instance;

  final Color _maroon = const Color(0xFF800020);
  final Color _maroonDark = const Color(0xFF5A0016);
  final Color _maroonLight = const Color(0xFFC0003A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90), // Spacing for bottom nav
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTopHeader(),
                _buildSummaryStrip(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildQuickActions(),
                      const SizedBox(height: 20),
                      _buildKehadiranPerMK(),
                      const SizedBox(height: 20),
                      _buildStatusIzin(),
                      const SizedBox(height: 20),
                      _buildRiwayatPresensi(),
                    ],
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
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanQrScreen()));
          },
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          colors: [_maroonDark, _maroon, _maroonLight],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _session.user?.initials ?? 'M',
                            style: TextStyle(
                              color: _maroonDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang,',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _session.user?.nama ?? 'Mahasiswa',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            _session.user?.displaySubtitle ?? 'NIM: -',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: (_session.user?.kehadiranPersen ?? 0) / 100,
                          strokeWidth: 8,
                          backgroundColor: Colors.white.withOpacity(0.15),
                          color: const Color(0xFFFFD700),
                          strokeCap: StrokeCap.round,
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${(_session.user?.kehadiranPersen ?? 0).round()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Hadir',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kehadiran Semester Ini',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(_session.user?.kehadiranPersen ?? 0).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '26 / 30 pertemuan hadir',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStrip() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSummaryPill('5', 'Mata Kuliah', _maroon),
            _buildSummaryPill('26', 'Hadir', const Color(0xFF198754)),
            _buildSummaryPill('2', 'Izin', const Color(0xFFFD7E14)),
            _buildSummaryPill('2', 'Alpha', const Color(0xFFDC3545)),
            _buildSummaryPill('14', 'SKS Total', const Color(0xFF0D6EFD)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryPill(String value, String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickBtn(Icons.qr_code_scanner, 'Scan QR', () {}),
            _buildQuickBtn(Icons.description, 'Ajukan Izin', _showIzinModal),
            _buildQuickBtn(Icons.book, 'Mata Kuliah', () {}),
            _buildQuickBtn(Icons.show_chart, 'Rekap', () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickBtn(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(icon, color: _maroon, size: 24),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKehadiranPerMK() {
    final mkList = [
      {'nama': 'Algoritma & Pemrograman', 'hadir': 14, 'total': 16, 'color': _maroon},
      {'nama': 'Basis Data', 'hadir': 13, 'total': 16, 'color': const Color(0xFF0D6EFD)},
      {'nama': 'Rekayasa PL', 'hadir': 12, 'total': 16, 'color': const Color(0xFF198754)},
      {'nama': 'Jaringan Komputer', 'hadir': 15, 'total': 16, 'color': const Color(0xFFFD7E14)},
      {'nama': 'Sistem Operasi', 'hadir': 10, 'total': 16, 'color': const Color(0xFF6F42C1)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: _maroon, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Kehadiran per Mata Kuliah',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E), fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...mkList.map((mk) {
            int hadir = mk['hadir'] as int;
            int total = mk['total'] as int;
            Color color = mk['color'] as Color;
            double pct = hadir / total;
            int pctInt = (pct * 100).round();

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mk['nama'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF333333)),
                      ),
                      Text(
                        '$hadir/$total ($pctInt%)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: pct,
                    backgroundColor: Colors.grey.shade200,
                    color: color,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatusIzin() {
    final izinData = [
      {'mk': 'Algoritma & Pemrograman', 'tgl': '10 Apr 2026', 'jenis': 'Sakit', 'status': 'Disetujui', 'color': const Color(0xFF198754)},
      {'mk': 'Basis Data', 'tgl': '08 Apr 2026', 'jenis': 'Izin Keluarga', 'status': 'Disetujui', 'color': const Color(0xFF198754)},
      {'mk': 'Rekayasa PL', 'tgl': '14 Apr 2026', 'jenis': 'Kegiatan Kampus', 'status': 'Menunggu', 'color': const Color(0xFFFD7E14)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.fact_check, color: _maroon, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Status Pengajuan Izin',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E), fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...izinData.map((iz) {
            Color color = iz['color'] as Color;
            bool disetujui = iz['status'] == 'Disetujui';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: disetujui ? const Color(0xFF198754).withOpacity(0.06) : const Color(0xFFFD7E14).withOpacity(0.06),
                border: Border.all(color: color.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.description, color: color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          iz['mk'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A1A2E)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${iz['jenis']} · ${iz['tgl']}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      iz['status'] as String,
                      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRiwayatPresensi() {
    final riwayat = [
      {'mk': 'Algoritma & Pemrograman', 'tgl': '15 Apr 2026', 'waktu': '07:35', 'status': 'Hadir', 'color': const Color(0xFF198754)},
      {'mk': 'Basis Data', 'tgl': '15 Apr 2026', 'waktu': '09:40', 'status': 'Hadir', 'color': const Color(0xFF198754)},
      {'mk': 'Rekayasa PL', 'tgl': '14 Apr 2026', 'waktu': '-', 'status': 'Izin', 'color': const Color(0xFFFD7E14)},
      {'mk': 'Jaringan Komputer', 'tgl': '14 Apr 2026', 'waktu': '15:05', 'status': 'Hadir', 'color': const Color(0xFF198754)},
      {'mk': 'Sistem Operasi', 'tgl': '12 Apr 2026', 'waktu': '-', 'status': 'Alpha', 'color': const Color(0xFFDC3545)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: _maroon, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Riwayat Presensi Terbaru',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E), fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...riwayat.asMap().entries.map((entry) {
            int idx = entry.key;
            var r = entry.value;
            Color color = r['color'] as Color;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: idx < riwayat.length - 1
                    ? Border(bottom: BorderSide(color: Colors.grey.shade100))
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['mk'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A1A2E)),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(r['tgl'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(width: 12),
                            const Icon(Icons.access_time, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(r['waktu'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      r['status'] as String,
                      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }),
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
    bool isActive = _currentIndex == index;
    return InkWell(
      onTap: () {
        if (_currentIndex == index) return;
        Widget? targetPage;
        if (index == 0) targetPage = const DashboardScreen();
        if (index == 1) targetPage = const ListMatakuliahScreen();
        if (index == 3) targetPage = const ProfilScreen();
        
        if (targetPage != null) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => targetPage!,
              transitionDuration: Duration.zero,
            ),
          );
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? _maroon : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? _maroon : Colors.grey,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? _maroon : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showIzinModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_maroonDark, _maroon],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.post_add, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Ajukan Izin / Sakit',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Jenis Izin', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF444444))),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                      value: 'Sakit',
                      items: ['Sakit', 'Izin Keluarga', 'Kegiatan Kampus', 'Lainnya'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) {},
                    ),
                    const SizedBox(height: 20),
                    const Text('Mata Kuliah', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF444444))),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                      value: 'Algoritma & Pemrograman',
                      items: [
                        'Algoritma & Pemrograman',
                        'Basis Data',
                        'Rekayasa Perangkat Lunak',
                        'Jaringan Komputer',
                        'Sistem Operasi'
                      ].map((e) {
                        return DropdownMenuItem(value: e, child: Expanded(child: Text(e, overflow: TextOverflow.ellipsis)));
                      }).toList(),
                      isExpanded: true,
                      onChanged: (val) {},
                    ),
                    const SizedBox(height: 20),
                    const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF444444))),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        hintText: 'Pilih Tanggal',
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Keterangan', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF444444))),
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'Jelaskan alasan izin Anda...',
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send, color: Colors.white),
                        label: const Text('Kirim Pengajuan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _maroon,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pengajuan izin berhasil dikirim! Menunggu persetujuan dosen.'), backgroundColor: Colors.green),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}