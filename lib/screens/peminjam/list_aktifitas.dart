import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/drawer/bottomnav_peminjam.dart';
import 'package:peminjaman_alat/service/aktifitas_service.dart';

class ListAktifitas extends StatelessWidget {
  const ListAktifitas({super.key});

  @override
  Widget build(BuildContext context) {
    final aktifitas = AktifitasService.getAktifitas();

    final int boxCount = aktifitas.fold<int>(
      0,
      (sum, data) =>
          sum +
          (data['alatList'] as List)
              .fold<int>(0, (s, a) => s + (a['count'] as int)),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4A261),
        title: const Text(
          "List Aktifitas",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: aktifitas.length,
        itemBuilder: (context, index) {
          final data = aktifitas[index];
          final List alatList = data['alatList'];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAMA PEMINJAM
                Text(
                  data['nama'],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// USER
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      data['user'],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// TANGGAL
                Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      "Pinjam: ${data['tanggalPinjam']}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.event_available,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      "Kembali: ${data['tanggalKembali']}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),

                const Divider(height: 28),

                /// ALAT
                const Text(
                  "Alat Dipinjam",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Column(
                  children: alatList.map<Widget>((alat) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              size: 14, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(alat['title']),
                          ),
                          Text(
                            "${alat['count']} pcs",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNav(currentIndex: 2, boxCount: boxCount),
    );
  }
}
