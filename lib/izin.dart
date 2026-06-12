import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'list_matakuliah.dart';
import 'scan_qr.dart';
import 'profil.dart';
import 'services/fixed_fab.dart';
import 'services/session_manager.dart';

class IzinScreen extends StatefulWidget {
  const IzinScreen({super.key});

  @override
  State<IzinScreen> createState() => _IzinScreenState();
}

class _IzinScreenState extends State<IzinScreen> {
  final int _currentIndex = 2;
  final _session = SessionManager.instance;

  final Color _maroon = const Color(0xFF800020);
  final Color _maroonDark = const Color(0xFF5A0016);
  final Color _maroonLight = const Color(0xFFC0003A);
  final Color _bgGray = const Color(0xFFF4F6F9);

  String _activeFilter = 'Semua';

  List<Map<String, dynamic>> _izinData = [
    {
      'id': 1,
      'mk': 'Algoritma & Pemrograman',
      'jenis': 'Sakit',
      'tgl': '10 Apr 2026',
      'ket': 'Demam tinggi, tidak bisa hadir.',
      'status': 'Disetujui',
      'catatan': 'Semoga lekas sembuh.',
      'diajukan': '09 Apr 2026',
    },
    {
      'id': 2,
      'mk': 'Basis Data',
      'jenis': 'Izin Keluarga',
      'tgl': '08 Apr 2026',
      'ket': 'Ada acara keluarga mendadak.',
      'status': 'Disetujui',
      'catatan': 'Baik, izin diterima.',
      'diajukan': '07 Apr 2026',
    },
    {
      'id': 3,
      'mk': 'Rekayasa Perangkat Lunak',
      'jenis': 'Kegiatan Kampus',
      'tgl': '14 Apr 2026',
      'ket': 'Mewakili kampus dalam lomba coding.',
      'status': 'Menunggu',
      'catatan': '',
      'diajukan': '13 Apr 2026',
    },
    {
      'id': 4,
      'mk': 'Sistem Operasi',
      'jenis': 'Sakit',
      'tgl': '20 Mar 2026',
      'ket': 'Sakit perut, ada surat dokter.',
      'status': 'Ditolak',
      'catatan': 'Surat dokter tidak valid.',
      'diajukan': '19 Mar 2026',
    },
    {
      'id': 5,
      'mk': 'Jaringan Komputer',
      'jenis': 'Lainnya',
      'tgl': '15 Mar 2026',
      'ket': 'Urusan administrasi kampus.',
      'status': 'Disetujui',
      'catatan': '',
      'diajukan': '14 Mar 2026',
    },
  ];

  int _nextId = 6;

  List<Map<String, dynamic>> get _filteredData {
    if (_activeFilter == 'Semua') return _izinData;
    return _izinData.where((i) => i['status'] == _activeFilter).toList();
  }

  void _setFilter(String f) {
    setState(() {
      _activeFilter = f;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGray,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              _buildTopHeader(),
              _buildFilterTabs(),
              Expanded(child: _buildContent()),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: "ajukanIzin",
              onPressed: _showIzinModal,
              backgroundColor: _maroon,
              elevation: 4,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanQrScreen()),
            );
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
                ),
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
    int total = _izinData.length;
    int menunggu = _izinData.where((i) => i['status'] == 'Menunggu').length;
    int disetujui = _izinData.where((i) => i['status'] == 'Disetujui').length;
    int ditolak = _izinData.where((i) => i['status'] == 'Ditolak').length;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DashboardScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pengajuan Izin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '${_session.user?.nama ?? 'Andi Pratama'} · NIM ${_session.user?.nim ?? 'M001'}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                  ),

                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatItem('$total', 'Total', Colors.white),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        '$menunggu',
                        'Menunggu',
                        const Color(0xFFFFD700),
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        '$disetujui',
                        'Disetujui',
                        const Color(0xFF90EE90),
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        '$ditolak',
                        'Ditolak',
                        const Color(0xFFFF9999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String val, String lbl, Color valueColor) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          lbl,
          textAlign: TextAlign.center,
          maxLines: 3,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterTab('Semua'),
            _buildFilterTab('Menunggu'),
            _buildFilterTab('Disetujui'),
            _buildFilterTab('Ditolak'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label) {
    bool active = _activeFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => _setFilter(label),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: active ? _maroon : Colors.white,
            border: Border.all(
              color: active ? _maroon : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: _maroon.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Icon(
                            Icons.description,
                            color: _maroon,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Riwayat Pengajuan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${_filteredData.length} pengajuan',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _filteredData.isEmpty ? _buildEmptyState() : _buildIzinList(),
            ],
          ),
        ),
        const SizedBox(height: 80), // bottom padding for FAB
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada pengajuan izin',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildIzinList() {
    return Column(
      children: _filteredData.asMap().entries.map((entry) {
        int idx = entry.key;
        var iz = entry.value;
        bool isLast = idx == _filteredData.length - 1;

        Color statusColor;
        IconData statusIcon;
        if (iz['status'] == 'Disetujui') {
          statusColor = const Color(0xFF198754);
          statusIcon = Icons.check_circle;
        } else if (iz['status'] == 'Ditolak') {
          statusColor = const Color(0xFFDC3545);
          statusIcon = Icons.cancel;
        } else {
          statusColor = const Color(0xFFFD7E14);
          statusIcon = Icons.hourglass_bottom;
        }

        Color jenisColor;
        IconData jenisIcon;
        if (iz['jenis'] == 'Sakit') {
          jenisColor = const Color(0xFFDC3545);
          jenisIcon = Icons.thermostat;
        } else if (iz['jenis'] == 'Izin Keluarga') {
          jenisColor = const Color(0xFF6F42C1);
          jenisIcon = Icons.family_restroom;
        } else if (iz['jenis'] == 'Kegiatan Kampus') {
          jenisColor = const Color(0xFF0D6EFD);
          jenisIcon = Icons.emoji_events;
        } else {
          jenisColor = Colors.grey;
          jenisIcon = Icons.more_horiz;
        }

        return InkWell(
          onTap: () => _openDetail(iz),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: jenisColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(jenisIcon, color: jenisColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        iz['mk'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.sell,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            iz['jenis'],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '·',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            iz['tgl'],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 12),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          iz['status'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _openDetail(Map<String, dynamic> iz) {
    Color statusColor;
    IconData statusIcon;
    if (iz['status'] == 'Disetujui') {
      statusColor = const Color(0xFF198754);
      statusIcon = Icons.check_circle;
    } else if (iz['status'] == 'Ditolak') {
      statusColor = const Color(0xFFDC3545);
      statusIcon = Icons.cancel;
    } else {
      statusColor = const Color(0xFFFD7E14);
      statusIcon = Icons.hourglass_bottom;
    }

    Color jenisColor;
    IconData jenisIcon;
    if (iz['jenis'] == 'Sakit') {
      jenisColor = const Color(0xFFDC3545);
      jenisIcon = Icons.thermostat;
    } else if (iz['jenis'] == 'Izin Keluarga') {
      jenisColor = const Color(0xFF6F42C1);
      jenisIcon = Icons.family_restroom;
    } else if (iz['jenis'] == 'Kegiatan Kampus') {
      jenisColor = const Color(0xFF0D6EFD);
      jenisIcon = Icons.emoji_events;
    } else {
      jenisColor = Colors.grey;
      jenisIcon = Icons.more_horiz;
    }

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: jenisColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(jenisIcon, color: jenisColor, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                iz['mk'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${iz['jenis']} · Diajukan ${iz['diajukan']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  iz['status'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                    fontSize: 14,
                                  ),
                                ),
                                if (iz['catatan'] != null &&
                                    iz['catatan'].toString().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      iz['catatan'],
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'DETAIL PENGAJUAN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _bgGray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${iz['jenis']} • ${iz['tgl']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _bgGray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              color: _maroon,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Keterangan:',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  iz['ket'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (iz['status'] == 'Menunggu')
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            label: const Text(
                              'Batalkan Pengajuan',
                              style: TextStyle(color: Colors.red),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              setState(() {
                                _izinData.removeWhere(
                                  (item) => item['id'] == iz['id'],
                                );
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Pengajuan berhasil dibatalkan.',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                          ),
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

  void _showIzinModal() {
    String selectedJenis = 'Sakit';
    String selectedMk = 'Algoritma & Pemrograman';
    DateTime selectedDate = DateTime.now();
    TextEditingController ketController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
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
                        const Text(
                          'Jenis Izin',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                          value: selectedJenis,
                          items:
                              [
                                'Sakit',
                                'Izin Keluarga',
                                'Kegiatan Kampus',
                                'Lainnya',
                              ].map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedJenis = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Mata Kuliah',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                          value: selectedMk,
                          items:
                              [
                                'Algoritma & Pemrograman',
                                'Basis Data',
                                'Rekayasa Perangkat Lunak',
                                'Jaringan Komputer',
                                'Sistem Operasi',
                              ].map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Expanded(
                                    child: Text(
                                      e,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                          isExpanded: true,
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedMk = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tanggal',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            hintText:
                                '${selectedDate.day} ${_getMonth(selectedDate.month)} ${selectedDate.year}',
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setModalState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Keterangan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: ketController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                            label: const Text(
                              'Kirim Pengajuan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _maroon,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {
                              if (ketController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Keterangan wajib diisi!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                _izinData.insert(0, {
                                  'id': _nextId++,
                                  'mk': selectedMk,
                                  'jenis': selectedJenis,
                                  'tgl':
                                      '${selectedDate.day} ${_getMonth(selectedDate.month)} ${selectedDate.year}',
                                  'ket': ketController.text,
                                  'status': 'Menunggu',
                                  'catatan': '',
                                  'diajukan':
                                      '${DateTime.now().day} ${_getMonth(DateTime.now().month)} ${DateTime.now().year}',
                                });
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Pengajuan izin berhasil dikirim!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
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
      },
    );
  }

  String _getMonth(int m) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    if (m >= 1 && m <= 12) return months[m - 1];
    return '';
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
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? _maroon : Colors.grey, size: 24),
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
