import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/drawer/drawer_petugas.dart';

class PersetujuanPage extends StatelessWidget {
  const PersetujuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      // ✅ DRAWER PETUGAS
      drawer: const DrawerPetugas(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Persetujuan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ================= TAB STATUS =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB067),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'pending',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text('approved',
                      style: TextStyle(color: Colors.grey)),
                  const Text('returned',
                      style: TextStyle(color: Colors.grey)),
                  const Text('rejected',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 16),

              // ================= SEARCH =================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'search...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= LIST =================
              Expanded(
                child: ListView(
                  children: [
                    buildCard(
                      'Rafya Ziapika P',
                      '20 Jan - 27 Jan',
                      'Power Meter, Test Pen, Volt Meter',
                    ),
                    buildCard(
                      'Siti Imrotilah',
                      '20 Jan - 27 Jan',
                      'Power Meter, Test Pen, Volt Meter',
                    ),
                    buildCard(
                      'Egi Dwi S',
                      '20 Jan - 27 Jan',
                      'Power Meter, Test Pen, Volt Meter',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= CARD BUILDER =================
  Widget buildCard(String nama, String tanggal, String alat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // AKSEN KIRI
          Container(
            width: 6,
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFFF7A2F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        tanggal,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alat,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // STATUS
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB067),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'pending',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
