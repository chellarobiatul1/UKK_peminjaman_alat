import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/drawer/drawer_petugas.dart';

class DashboardPetugas extends StatelessWidget {
  const DashboardPetugas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      // 🔥 PANGGIL DRAWER TERPISAH
      drawer: const DrawerPetugas(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // BOX STATUS
              Row(
                children: [
                  Expanded(
                    child: statusBox(
                      title: 'Alat Tersedia',
                      count: '24',
                      color: const Color(0xFFDFF5EA),
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: statusBox(
                      title: 'Diperbaiki',
                      count: '3',
                      color: const Color(0xFFFFF3D9),
                      icon: Icons.build,
                      iconColor: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: statusBox(
                      title: 'Rusak',
                      count: '2',
                      color: const Color(0xFFFFE3E3),
                      icon: Icons.warning,
                      iconColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: statusBox(
                      title: 'Dipinjam',
                      count: '5',
                      color: const Color(0xFFE3F0FF),
                      icon: Icons.assignment,
                      iconColor: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Notifikasi Peminjaman',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // LIST NOTIFIKASI
              Expanded(
                child: ListView(
                  children: [
                    notifItem(
                      nama: 'Rafya Ziapika',
                      barang: 'Power Meter, Test Pen',
                      tanggal: '20 Jan - 27 Jan',
                      status: 'Pending',
                    ),
                    notifItem(
                      nama: 'Siti Muwitok',
                      barang: 'AVO Meter',
                      tanggal: '21 Jan - 25 Jan',
                      status: 'Pending',
                    ),
                    notifItem(
                      nama: 'Egi Dwi S',
                      barang: 'Clamp Meter',
                      tanggal: '22 Jan - 26 Jan',
                      status: 'Approved',
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

  // BOX STATUS
  Widget statusBox({
    required String title,
    required String count,
    required Color color,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const Spacer(),
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ITEM NOTIFIKASI
  Widget notifItem({
    required String nama,
    required String barang,
    required String tanggal,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // AKSEN WARNA
          Container(
            width: 6,
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFFFA14A),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    barang,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tanggal,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: status == 'Pending'
                    ? Colors.orange
                    : Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
