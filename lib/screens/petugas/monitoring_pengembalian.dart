import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/drawer/drawer_petugas.dart';

class MonitoringPengembalian extends StatelessWidget {
  const MonitoringPengembalian({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerPetugas(),
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4A261),
        elevation: 0,
        title: const Text(
          'Monitoring Pengembalian',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      // ================= BODY =================
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6, // dummy data
        itemBuilder: (context, index) {
          final bool isReturned = index % 2 == 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== HEADER CARD =====
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isReturned
                            ? Colors.green.withOpacity(0.15)
                            : Colors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.build,
                        color: isReturned ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Multimeter Digital',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isReturned
                            ? Colors.green.withOpacity(0.15)
                            : Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isReturned ? 'Dikembalikan' : 'Dipinjam',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              isReturned ? Colors.green : Colors.orange[800],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ===== DETAIL =====
                const Text(
                  'Peminjam : Andi Wijaya',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tanggal Pinjam : 10 Januari 2026',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  isReturned
                      ? 'Tanggal Kembali : 12 Januari 2026'
                      : 'Batas Kembali : 12 Januari 2026',
                  style: const TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 12),

                // ===== ACTION =====
                if (!isReturned)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text(
                        'Konfirmasi Pengembalian',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        // nanti isi logic update status
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
