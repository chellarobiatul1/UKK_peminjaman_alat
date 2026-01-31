import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/drawer/bottomnav_peminjam.dart';
import 'package:peminjaman_alat/screens/peminjam/detail_pengembalian.dart';

class ListAktifitas extends StatelessWidget {
  final List<Map<String, dynamic>> alatList;

  const ListAktifitas({super.key, required this.alatList});

  @override
  Widget build(BuildContext context) {
    final int boxCount = alatList.fold<int>(0, (sum, item) => sum + (item['count'] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF4A261),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop;
          },
        ),
        title: const Text(
          "List",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFF25C54),
              child: Text("C", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: alatList.map((alat) {
            return itemCard(context, alat);
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 2, boxCount: boxCount),
    );
  }

  Widget itemCard(BuildContext context, Map<String, dynamic> alat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 90,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFF4A261),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alat['title'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 14, color: Colors.black),
                      const SizedBox(width: 4),
                      Text("20 Jan - 27 Jan", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Spacer(),
                  const Text("Power Weld Test, Plant AI Welder", style: TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PengembalianPeminjamanPage(alatList: [alat])),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4A261).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "ajukan pengembalian",
                  style: TextStyle(color: Color(0xFFF4A261), fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
