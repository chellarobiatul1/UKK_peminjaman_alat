import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/drawer/drawer_admin.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  final TextEditingController _searchController = TextEditingController();

  late List<Map<String, dynamic>> _filteredLogs;

  final List<Map<String, dynamic>> _allLogs = [
    {
      'color': const Color(0xFF6BA46B),
      'status': 'Menyetujui Ajuan',
      'nama': 'Chella Robiatul A',
      'tanggal': '20 Jan - 27 Jan',
      'badge': 'Pegawai',
    },
    {
      'color': const Color(0xFF8FA7C7),
      'status': 'Mengajukan Peminjaman',
      'nama': 'Chella Robiatul A',
      'tanggal': '20 Jan - 27 Jan',
      'badge': 'Peminjam',
    },
    {
      'color': const Color(0xFFF08A8A),
      'status': 'Menolak Ajuan',
      'nama': 'Chella Robiatul A',
      'tanggal': '20 Jan - 27 Jan',
      'badge': 'Pegawai',
    },
    {
      'color': const Color(0xFF6BA46B),
      'status': 'Menyetujui Ajuan',
      'nama': 'Chella Robiatul A',
      'tanggal': '20 Jan - 27 Jan',
      'badge': 'Pegawai',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredLogs = _allLogs;
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
  final query = _searchController.text.toLowerCase();

  setState(() {
    _filteredLogs = _allLogs.where((log) {
      return log.values.any(
        (value) => value
            .toString()
            .toLowerCase()
            .contains(query),
      );
    }).toList();
  });
}


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE9B9A4),
        elevation: 0,
        title: const Text('Dashboard', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CARD STATUS
            Row(
              children: [
                _statusCard(icon: Icons.access_time, title: 'Sedang\ndipinjam'),
                const SizedBox(width: 12),
                _statusCard(icon: Icons.inventory_2, title: 'Barang\ntersedia'),
              ],
            ),
            const SizedBox(height: 12),
            _statusCard(
              icon: Icons.assignment_turned_in,
              title: 'Sudah\ndikembalikan',
              fullWidth: true,
            ),

            const SizedBox(height: 20),

            /// SEARCH BAR
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Cari aktivitas...',
                  border: InputBorder.none,
                ),
              ),
            ),

            const Text(
              'Log Aktivitas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            /// LOG LIST
            if (_filteredLogs.isEmpty)
              const Center(child: Text('Data tidak ditemukan'))
            else
              ..._filteredLogs.map(
                (log) => _logCard(
                  color: log['color'],
                  status: log['status'],
                  nama: log['nama'],
                  tanggal: log['tanggal'],
                  badge: log['badge'],
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget _statusCard({
    required IconData icon,
    required String title,
    bool fullWidth = false,
  }) {
    return Expanded(
      flex: fullWidth ? 0 : 1,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  static Widget _logCard({
    required Color color,
    required String status,
    required String nama,
    required String tanggal,
    required String badge,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(nama),
                Text(tanggal, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badge, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
