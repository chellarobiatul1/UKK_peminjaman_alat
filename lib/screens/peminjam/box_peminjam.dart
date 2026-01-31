import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/peminjam/detail_peminjaman.dart';
import 'package:peminjaman_alat/screens/drawer/bottomnav_peminjam.dart';

class BoxPeminjam extends StatelessWidget {
  const BoxPeminjam({super.key});

  @override
  Widget build(BuildContext context) {
    return const PeminjamanPage();
  }
}

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  final List<Map<String, dynamic>> alatList = [
    {
      "title": "Power Meter",
      "stock": 5,
      "count": 1,
      "image": "assets/images/power_meter.jpg",
    },
    {
      "title": "Test Pen",
      "stock": 2,
      "count": 1,
      "image": "assets/images/pen.jpg",
    },
    {
      "title": "Volt Meter",
      "stock": 4,
      "count": 1,
      "image": "assets/images/voltmtr.jpg",
    },
  ];

  void _incrementCount(int index) {
    setState(() {
      if (alatList[index]["count"] < alatList[index]["stock"]) {
        alatList[index]["count"]++;
      }
    });
  }

  void _decrementCount(int index) {
    setState(() {
      if (alatList[index]["count"] > 1) {
        alatList[index]["count"]--;
      }
    });
  }

  Future<void> _deleteItem(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text(
          "Apakah kamu yakin ingin menghapus ${alatList[index]['title']}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        alatList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int boxCount =
        alatList.fold(0, (sum, item) => sum + (item['count'] as int));

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
                        // IMAGE
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              alat['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // TITLE
                        Expanded(
                          child: Text(
                            alat['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // ACTION
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _decrementCount(index),
                            ),
                            Text(
                              "${alat['count']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _incrementCount(index),
                            ),

                            // 🗑 DELETE ICON
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
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

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AjukanPeminjaman(
                        alatList:
                            List<Map<String, dynamic>>.from(alatList),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF6C3E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Ajukan Peminjaman',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
