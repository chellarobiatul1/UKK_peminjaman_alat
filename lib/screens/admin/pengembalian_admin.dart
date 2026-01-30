import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/drawer/drawer_admin.dart';
import 'peminjaman_admin.dart';
import 'package:peminjaman_alat/widget/admin/crud_pengembalian.dart';

class PengembalianAdmin extends StatefulWidget {
  const PengembalianAdmin({super.key});

  @override
  State<PengembalianAdmin> createState() => _PengembalianAdmin();
}

class _PengembalianAdmin extends State<PengembalianAdmin> {
  final List<Map<String, String>> _data = [
    {
      'nama': 'CHELLA ROBIATUL A',
      'alat': 'Power Meter, Test Pen, Volt Meter',
      'tgl_peminjaman': '03 - Januari - 2026',
      'tgl_kembali': '13 - Januari - 2026',
      'tgl_pengembalian': '14 - Januari - 2026',
      'kondisi': 'Rusak',
      'denda': 'Rp 10.000',
      'status': 'terlambat',
    },
    {
      'nama': 'CHELLA ROBIATUL A',
      'alat': 'Power Meter, Test Pen, Volt Meter',
      'tgl_peminjaman': '03 - Januari - 2026',
      'tgl_kembali': '13 - Januari - 2026',
      'tgl_pengembalian': '14 - Januari - 2026',
      'kondisi': 'Rusak',
      'denda': 'Rp 10.000',
      'status': 'terlambat',
    },
  ];

  List<Map<String, String>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(_data);
  }

  void _filterData(String query) {
    final filtered = _data.where((item) {
      final lowerQuery = query.toLowerCase();
      return item['nama']!.toLowerCase().contains(lowerQuery) ||
          item['alat']!.toLowerCase().contains(lowerQuery) ||
          item['tgl_peminjaman']!.toLowerCase().contains(lowerQuery) ||
          item['tgl_kembali']!.toLowerCase().contains(lowerQuery) ||
          item['tgl_pengembalian']!.toLowerCase().contains(lowerQuery) ||
          item['kondisi']!.toLowerCase().contains(lowerQuery) ||
          item['denda']!.toLowerCase().contains(lowerQuery) ||
          item['status']!.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      _filteredData = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            color: const Color(0xFFE9B9A5),
            child: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'peminjaman\n& pengembalian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _filterData,
              decoration: InputDecoration(
                hintText: 'search...',
                suffixIcon: const Icon(Icons.search),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // TAB
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PeminjamanAdmin(),
                      ),
                    );
                  },
                  child: const Text(
                    'Peminjaman',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1872D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Pengembalian',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // LIST
          Expanded(
            child: _filteredData.isEmpty
                ? const Center(child: Text('Data tidak ditemukan'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final item = _filteredData[index];
                      return _itemPengembalian(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _itemPengembalian(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // STRIP WARNA
          Container(
            width: 12,
            height: 180,
            decoration: const BoxDecoration(
              color: Color(0xFFF6A55F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),

          // CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAMA + STATUS + ICON EDIT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['nama'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item['status'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // ICON EDIT
                          GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const CrudPengembalian(),
    );
  },
  child: const Icon(
    Icons.edit,
    color: Colors.black54,
  ),
),

                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Alat : ${item['alat'] ?? ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Tanggal peminjaman : ${item['tgl_peminjaman'] ?? ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Tanggal kembali : ${item['tgl_kembali'] ?? ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Tanggal Pengembalian : ${item['tgl_pengembalian'] ?? ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'kondisi pengembalian : ${item['kondisi'] ?? ''}',
                    style: const TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Denda : ${item['denda'] ?? ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
