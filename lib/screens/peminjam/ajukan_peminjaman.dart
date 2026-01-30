import 'package:flutter/material.dart';

class AjukanPeminjaman extends StatelessWidget {
  final List<Map<String, dynamic>> alatList;

  const AjukanPeminjaman({super.key, required this.alatList});

  @override
  Widget build(BuildContext context) {
    const Color orangeColor = Color(0xFFF4A261);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: orangeColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              width: double.infinity,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  const Text('Detail Peminjaman', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: const Text('Verifikasi Peminjaman', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            ),
            const SizedBox(height: 10),

            // Data Diri
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: const [
                      Text('Data Diri', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      SizedBox(height: 10),
                      TextField(decoration: InputDecoration(hintText: 'Nama', prefixIcon: Icon(Icons.person))),
                      SizedBox(height: 10),
                      TextField(decoration: InputDecoration(hintText: 'User', prefixIcon: Icon(Icons.person))),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Alat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Alat', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      const SizedBox(height: 8),
                      ...alatList.map((alat) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(alat['image'], fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(alat['title'], style: const TextStyle(fontWeight: FontWeight.w600))),
                            Text("${alat['count']} pcs", style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {}, // bisa ditambahkan hapus
                              child: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Button Ajukan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('ajukan', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
