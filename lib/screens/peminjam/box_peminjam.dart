import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/peminjam/detail_peminjaman.dart';
import 'package:peminjaman_alat/screens/drawer/bottomnav_peminjam.dart';
import 'package:peminjaman_alat/service/keranjang_service.dart';

class BoxPeminjam extends StatefulWidget {
  const BoxPeminjam({super.key});

  @override
  State<BoxPeminjam> createState() => _BoxPeminjamState();
}

class _BoxPeminjamState extends State<BoxPeminjam> {
  List<Map<String, dynamic>> get alatList =>
      KeranjangService.getKeranjang();

  void _incrementCount(int index) {
    setState(() {
      KeranjangService.tambahJumlah(index);
    });
  }

  void _decrementCount(int index) {
    setState(() {
      KeranjangService.kurangJumlah(index);
    });
  }

  Future<void> _deleteItem(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text(
          "Hapus ${alatList[index]['title']} dari keranjang?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        KeranjangService.hapusAlat(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final boxCount = KeranjangService.totalAlat();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8B7A2),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Peminjaman',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: alatList.length,
                itemBuilder: (context, index) {
                  final alat = alatList[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4C7AE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          alat['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            alat['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _decrementCount(index),
                            ),
                            Text("${alat['count']}"),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _incrementCount(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteItem(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPeminjaman(
                      alatList: alatList,
                    ),
                  ),
                );
              },
              child: const Text("Ajukan Peminjaman"),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNav(
        currentIndex: 1,
        boxCount: boxCount,
      ),
    );
  }
}
