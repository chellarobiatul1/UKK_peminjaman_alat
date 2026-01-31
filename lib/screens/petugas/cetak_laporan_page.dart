import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/drawer/drawer_petugas.dart';

class CetakLaporanPage extends StatelessWidget {
  const CetakLaporanPage({super.key});

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
                    'Cetak Laporan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ================= PERIODE =================
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Periode Laporan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Jan 2026',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ================= RINGKASAN =================
              Row(
                children: [
                  _summaryBox(
                    title: 'Total Peminjaman',
                    value: '24',
                    color: const Color(0xFFE3F0FF),
                    icon: Icons.assignment,
                  ),
                  const SizedBox(width: 12),
                  _summaryBox(
                    title: 'Dikembalikan',
                    value: '18',
                    color: const Color(0xFFDFF5EA),
                    icon: Icons.check_circle,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _summaryBox(
                    title: 'Masih Dipinjam',
                    value: '4',
                    color: const Color(0xFFFFF3D9),
                    icon: Icons.timelapse,
                  ),
                  const SizedBox(width: 12),
                  _summaryBox(
                    title: 'Terlambat',
                    value: '2',
                    color: const Color(0xFFFFE3E3),
                    icon: Icons.warning,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ================= JUDUL LIST =================
              const Text(
                'Detail Laporan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // ================= LIST LAPORAN =================
              Expanded(
                child: ListView(
                  children: [
                    laporanItem(
                      nama: 'Rafya Ziapika P',
                      alat: 'Power Meter',
                      tanggal: '20 Jan - 27 Jan',
                      status: 'Returned',
                    ),
                    laporanItem(
                      nama: 'Siti Imrotilah',
                      alat: 'AVO Meter',
                      tanggal: '21 Jan - 25 Jan',
                      status: 'Returned',
                    ),
                    laporanItem(
                      nama: 'Egi Dwi S',
                      alat: 'Clamp Meter',
                      tanggal: '22 Jan - 26 Jan',
                      status: 'Late',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ================= BUTTON CETAK =================
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // nanti bisa isi logic pdf / print
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB067),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.print, color: Colors.black),
                  label: const Text(
                    'Cetak Laporan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ================= SUMMARY BOX =================
  Widget _summaryBox({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ITEM LAPORAN =================
  Widget laporanItem({
    required String nama,
    required String alat,
    required String tanggal,
    required String status,
  }) {
    Color statusColor = status == 'Returned'
        ? Colors.green
        : status == 'Late'
            ? Colors.red
            : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  alat,
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
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
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
        ],
      ),
    );
  }
}
