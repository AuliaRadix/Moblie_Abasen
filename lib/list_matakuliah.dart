import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'profil.dart';
import 'scan_qr.dart';
import 'services/mahasiswa_service.dart';
import 'services/session_manager.dart';

class ListMatakuliahScreen extends StatefulWidget {
  const ListMatakuliahScreen({super.key});

  @override
  State<ListMatakuliahScreen> createState() => _ListMatakuliahScreenState();
}

class _ListMatakuliahScreenState extends State<ListMatakuliahScreen> {
  int _currentIndex = 1; // 1 for Mata Kuliah
  bool _isLoading = true;
  String? _errorMessage;
  final _session = SessionManager.instance;

  final Color _maroon = const Color(0xFF800020);
  final Color _maroonDark = const Color(0xFF5A0016);
  final Color _maroonLight = const Color(0xFFC0003A);

  List<Map<String, dynamic>> get mkData => _session.matakuliahList
      .map((mk) => mk.toUiMap())
      .toList();

  static const List<Map<String, dynamic>> _fallbackMkData = [
    {
      'kode': 'MK001',
      'nama': 'Algoritma & Pemrograman',
      'kelas': 'TI-A',
      'sks': 3,
      'dosen': 'Dr. Rahmad S.',
      'hari': 'Senin',
      'jam': '07:30 – 09:10',
      'ruang': 'Lab K.301',
      'color': const Color(0xFF800020),
      'icon': Icons.memory,
      'hadir': 14,
      'izin': 1,
      'alpha': 1,
      'total': 16,
      'sessions': [
        {'n': 1, 'tgl': '3 Feb 2026', 'topik': 'Pengantar Algoritma', 'status': 'hadir'},
        {'n': 2, 'tgl': '10 Feb 2026', 'topik': 'Variabel & Tipe Data', 'status': 'hadir'},
        {'n': 3, 'tgl': '17 Feb 2026', 'topik': 'Percabangan', 'status': 'hadir'},
        {'n': 4, 'tgl': '24 Feb 2026', 'topik': 'Perulangan', 'status': 'izin'},
        {'n': 5, 'tgl': '3 Mar 2026', 'topik': 'Fungsi & Prosedur', 'status': 'hadir'},
        {'n': 6, 'tgl': '10 Mar 2026', 'topik': 'Array', 'status': 'hadir'},
        {'n': 7, 'tgl': '17 Mar 2026', 'topik': 'Sorting', 'status': 'hadir'},
        {'n': 8, 'tgl': '24 Mar 2026', 'topik': 'UTS', 'status': 'hadir'},
        {'n': 9, 'tgl': '7 Apr 2026', 'topik': 'Rekursi', 'status': 'hadir'},
        {'n': 10, 'tgl': '14 Apr 2026', 'topik': 'Pointer', 'status': 'alpha'},
        {'n': 11, 'tgl': '15 Apr 2026', 'topik': 'Linked List', 'status': 'hadir'},
      ]
    },
    {
      'kode': 'MK002',
      'nama': 'Basis Data',
      'kelas': 'TI-B',
      'sks': 3,
      'dosen': 'Dr. Dian M.Kom',
      'hari': 'Selasa',
      'jam': '09:30 – 11:10',
      'ruang': 'R. B.202',
      'color': const Color(0xFF0D6EFD),
      'icon': Icons.storage,
      'hadir': 13,
      'izin': 2,
      'alpha': 1,
      'total': 16,
      'sessions': [
        {'n': 1, 'tgl': '4 Feb 2026', 'topik': 'ER Diagram', 'status': 'hadir'},
        {'n': 2, 'tgl': '11 Feb 2026', 'topik': 'Normalisasi 1NF', 'status': 'hadir'},
        {'n': 3, 'tgl': '18 Feb 2026', 'topik': 'Normalisasi 2NF', 'status': 'izin'},
        {'n': 4, 'tgl': '25 Feb 2026', 'topik': 'SQL DDL', 'status': 'hadir'},
        {'n': 5, 'tgl': '4 Mar 2026', 'topik': 'SQL DML', 'status': 'hadir'},
        {'n': 6, 'tgl': '11 Mar 2026', 'topik': 'JOIN Tables', 'status': 'hadir'},
        {'n': 7, 'tgl': '18 Mar 2026', 'topik': 'Subquery', 'status': 'alpha'},
        {'n': 8, 'tgl': '25 Mar 2026', 'topik': 'UTS', 'status': 'hadir'},
        {'n': 9, 'tgl': '8 Apr 2026', 'topik': 'Index & View', 'status': 'hadir'},
        {'n': 10, 'tgl': '15 Apr 2026', 'topik': 'Stored Procedure', 'status': 'izin'},
      ]
    },
    {
      'kode': 'MK003',
      'nama': 'Rekayasa Perangkat Lunak',
      'kelas': 'TI-A',
      'sks': 3,
      'dosen': 'Ir. Budi W. M.T',
      'hari': 'Rabu',
      'jam': '13:00 – 14:40',
      'ruang': 'R. C.101',
      'color': const Color(0xFF198754),
      'icon': Icons.device_hub,
      'hadir': 12,
      'izin': 1,
      'alpha': 3,
      'total': 16,
      'sessions': [
        {'n': 1, 'tgl': '5 Feb 2026', 'topik': 'SDLC Overview', 'status': 'hadir'},
        {'n': 2, 'tgl': '12 Feb 2026', 'topik': 'Requirement Analysis', 'status': 'hadir'},
        {'n': 3, 'tgl': '19 Feb 2026', 'topik': 'UML Use Case', 'status': 'alpha'},
        {'n': 4, 'tgl': '26 Feb 2026', 'topik': 'UML Class Diagram', 'status': 'hadir'},
        {'n': 5, 'tgl': '5 Mar 2026', 'topik': 'Design Pattern', 'status': 'hadir'},
        {'n': 6, 'tgl': '12 Mar 2026', 'topik': 'Testing', 'status': 'alpha'},
        {'n': 7, 'tgl': '19 Mar 2026', 'topik': 'Deployment', 'status': 'hadir'},
        {'n': 8, 'tgl': '26 Mar 2026', 'topik': 'UTS', 'status': 'izin'},
        {'n': 9, 'tgl': '9 Apr 2026', 'topik': 'Agile Scrum', 'status': 'hadir'},
        {'n': 10, 'tgl': '14 Apr 2026', 'topik': 'Sprint Planning', 'status': 'alpha'},
      ]
    },
    {
      'kode': 'MK004',
      'nama': 'Jaringan Komputer',
      'kelas': 'TI-C',
      'sks': 3,
      'dosen': 'Dr. Hana S.T',
      'hari': 'Kamis',
      'jam': '15:00 – 16:40',
      'ruang': 'Lab N.202',
      'color': const Color(0xFFFD7E14),
      'icon': Icons.wifi,
      'hadir': 15,
      'izin': 0,
      'alpha': 1,
      'total': 16,
      'sessions': [
        {'n': 1, 'tgl': '6 Feb 2026', 'topik': 'OSI Model', 'status': 'hadir'},
        {'n': 2, 'tgl': '13 Feb 2026', 'topik': 'TCP/IP', 'status': 'hadir'},
        {'n': 3, 'tgl': '20 Feb 2026', 'topik': 'Subnetting', 'status': 'hadir'},
        {'n': 4, 'tgl': '27 Feb 2026', 'topik': 'Routing', 'status': 'hadir'},
        {'n': 5, 'tgl': '6 Mar 2026', 'topik': 'Switching', 'status': 'hadir'},
        {'n': 6, 'tgl': '13 Mar 2026', 'topik': 'Wireless LAN', 'status': 'alpha'},
        {'n': 7, 'tgl': '20 Mar 2026', 'topik': 'Firewall', 'status': 'hadir'},
        {'n': 8, 'tgl': '27 Mar 2026', 'topik': 'UTS', 'status': 'hadir'},
      ]
    },
    {
      'kode': 'MK005',
      'nama': 'Sistem Operasi',
      'kelas': 'TI-B',
      'sks': 2,
      'dosen': 'Dr. Eko P. M.Kom',
      'hari': 'Jumat',
      'jam': '08:00 – 09:40',
      'ruang': 'R. A.303',
      'color': const Color(0xFF6F42C1),
      'icon': Icons.dns,
      'hadir': 10,
      'izin': 2,
      'alpha': 4,
      'total': 16,
      'sessions': [
        {'n': 1, 'tgl': '7 Feb 2026', 'topik': 'Intro OS', 'status': 'hadir'},
        {'n': 2, 'tgl': '14 Feb 2026', 'topik': 'Process Management', 'status': 'hadir'},
        {'n': 3, 'tgl': '21 Feb 2026', 'topik': 'Threading', 'status': 'alpha'},
        {'n': 4, 'tgl': '28 Feb 2026', 'topik': 'Scheduling', 'status': 'hadir'},
        {'n': 5, 'tgl': '7 Mar 2026', 'topik': 'Memory Management', 'status': 'alpha'},
        {'n': 6, 'tgl': '14 Mar 2026', 'topik': 'Virtual Memory', 'status': 'izin'},
        {'n': 7, 'tgl': '21 Mar 2026', 'topik': 'File System', 'status': 'hadir'},
        {'n': 8, 'tgl': '28 Mar 2026', 'topik': 'UTS', 'status': 'izin'},
        {'n': 9, 'tgl': '11 Apr 2026', 'topik': 'I/O System', 'status': 'hadir'},
        {'n': 10, 'tgl': '14 Apr 2026', 'topik': 'Security OS', 'status': 'alpha'},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadMatakuliah();
  }

  Future<void> _loadMatakuliah() async {
    if (_session.matakuliahList.isNotEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      await MahasiswaService.instance.loadMatakuliah();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(color: Color(0xFF800020)),
                          ),
                        )
                      : Column(
                          children: (_errorMessage != null && mkData.isEmpty
                                  ? _fallbackMkData
                                  : mkData)
                              .asMap()
                              .entries
                              .map((entry) => _buildMkCard(entry.value, entry.key))
                              .toList(),
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
          colors: [_maroonDark, _maroon],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -60,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mata Kuliah Saya',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Semester Genap 2025/2026',
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '5 MK',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('5', 'Mata Kuliah'),
                    _buildStatItem('14', 'SKS Total'),
                    _buildStatItem('87%', 'Rata-rata Hadir'),
                    _buildStatItem('16', 'Pertemuan/MK'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String val, String lbl) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          lbl,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMkCard(Map<String, dynamic> mk, int index) {
    int hadir = mk['hadir'] as int;
    int total = mk['total'] as int;
    double pctDouble = hadir / total;
    int pct = (pctDouble * 100).round();
    
    Color barColor = pct >= 80 ? const Color(0xFF198754) : pct >= 60 ? const Color(0xFFFD7E14) : const Color(0xFFDC3545);
    Color mkColor = mk['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showDetailModal(mk, pct, barColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: mkColor, width: 4)),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: mkColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(mk['icon'] as IconData, color: mkColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mk['kode'] as String,
                            style: TextStyle(color: mkColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.8),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mk['nama'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1A2E)),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                mk['dosen'] as String,
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag(Icons.workspace_premium, '${mk['sks']} SKS'),
                    _buildTag(Icons.calendar_today, '${mk['hari']}, ${mk['jam']}'),
                    _buildTag(Icons.location_on, mk['ruang'] as String),
                    _buildTag(Icons.people, 'Kelas ${mk['kelas']}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade100)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Kehadiran', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              Text(
                                '$hadir/$total ($pct%)',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: barColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: pctDouble,
                            backgroundColor: Colors.grey.shade200,
                            color: barColor,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF555555)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF555555))),
        ],
      ),
    );
  }

  void _showDetailModal(Map<String, dynamic> mk, int pct, Color barColor) {
    Color mkColor = mk['color'] as Color;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Detail
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: mkColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(mk['icon'] as IconData, color: mkColor, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mk['kode'] as String,
                                  style: TextStyle(color: mkColor, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  mk['nama'] as String,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1A1A2E)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${mk['dosen']} · ${mk['hari']}, ${mk['jam']}',
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Stats Row
                      Row(
                        children: [
                          Expanded(child: _buildDetailStat('${mk['hadir']}', 'Hadir', const Color(0xFF198754))),
                          const SizedBox(width: 12),
                          Expanded(child: _buildDetailStat('${mk['izin']}', 'Izin', const Color(0xFFFD7E14))),
                          const SizedBox(width: 12),
                          Expanded(child: _buildDetailStat('${mk['alpha']}', 'Alpha', const Color(0xFFDC3545))),
                          const SizedBox(width: 12),
                          Expanded(child: _buildDetailStat('$pct%', 'Kehadiran', _maroon)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Riwayat Pertemuan',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1A2E)),
                      ),
                      const SizedBox(height: 12),
                      // Sessions
                      ...List.generate((mk['sessions'] as List).length, (index) {
                        var s = mk['sessions'][index];
                        String status = s['status'] as String;
                        Color statusColor = status == 'hadir' ? const Color(0xFF198754) : status == 'izin' ? const Color(0xFFFD7E14) : const Color(0xFFDC3545);
                        String statusLabel = status == 'hadir' ? 'Hadir' : status == 'izin' ? 'Izin' : 'Alpha';

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: index < (mk['sessions'] as List).length - 1
                                ? Border(bottom: BorderSide(color: Colors.grey.shade100))
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${s['n']}',
                                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s['topik'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF333333)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      s['tgl'] as String,
                                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  statusLabel,
                                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailStat(String val, String lbl, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(
            lbl,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
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
}