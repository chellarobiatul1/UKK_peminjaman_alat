import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/drawer/app_drawer.dart';
import 'peminjaman_admin.dart';

class PengembalianAdmin extends StatelessWidget {
  const PengembalianAdmin({super.key});

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
                    onPressed: () =>
                        Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'peminjaman\n& pengembalian',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'search...',
                suffixIcon: const Icon(Icons.search),
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
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1872D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Pengembalian',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
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
                      Container(
                        width: 12,
                        height: 170,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF6A55F),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'CHELLA ROBIATUL A',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Alat : Power Meter, Test Pen, Volt Meter',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Tanggal pengembalian : 14 - Januari - 2026',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Denda : Rp 10.000',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
