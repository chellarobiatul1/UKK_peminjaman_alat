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
          (value) => value.toString().toLowerCase().contains(query),
        );
      }).toList();
    });
  }

  Color applyOpacity(Color color, double opacity) {
    return Color.fromARGB((opacity * 255).round(), color.red, color.green, color.blue);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerAdmin(),
      backgroundColor: const Color(0xFFF5F5F5),
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
                _statusCard(
                  icon: Icons.access_time,
                  title: 'Sedang\ndipinjam',
                  gradient: const LinearGradient(
                      colors: [Color(0xFFf6d365), Color(0xFFfda085)]),
                ),
                const SizedBox(width: 12),
                _statusCard(
                  icon: Icons.inventory_2,
                  title: 'Barang\ntersedia',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF84fab0), Color(0xFF8fd3f4)]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _statusCard(
              icon: Icons.assignment_turned_in,
              title: 'Sudah\ndikembalikan',
              fullWidth: true,
              gradient: const LinearGradient(
                  colors: [Color(0xFFa1c4fd), Color(0xFFc2e9fb)]),
            ),

            const SizedBox(height: 20),

            /// SEARCH BAR
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Cari aktivitas...',
                  border: InputBorder.none,
                ),
              ),
            ),

            const Text(
              'Log Aktivitas',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),

            /// LOG LIST
            if (_filteredLogs.isEmpty)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Data tidak ditemukan'),
              ))
            else
              ..._filteredLogs.map(
                (log) => _logCard(
                  color: applyOpacity(log['color'], 0.85),
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
    LinearGradient? gradient,
  }) {
    return Expanded(
      flex: fullWidth ? 0 : 1,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient ??
              const LinearGradient(colors: [Colors.white, Colors.white]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
            ),
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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
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
                      fontSize: 14,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(nama, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 2),
                Text(tanggal,
                    style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badge,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
