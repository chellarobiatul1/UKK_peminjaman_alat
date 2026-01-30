import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/peminjam/ajukan_peminjaman.dart';

void main() {
  runApp(const BoxPeminjam());
}

class BoxPeminjam extends StatelessWidget {
  const BoxPeminjam({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PeminjamanPage(),
    );
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
      "image": "assets/images/power_meter.png",
    },
    {
      "title": "Test Pen",
      "stock": 2,
      "count": 1,
      "image": "assets/images/test_pen.png",
    },
    {
      "title": "Volt Meter",
      "stock": 4,
      "count": 1,
      "image": "assets/images/volt_meter.png",
    },
  ];

  void _incrementCount(int index) {
    setState(() {
      if (alatList[index]["count"] < alatList[index]["stock"]) {
        alatList[index]["count"] += 1;
      }
    });
  }

  void _decrementCount(int index) {
    setState(() {
      if (alatList[index]["count"] > 0) {
        alatList[index]["count"] -= 1;
      }
    });
  }

  Future<bool?> _confirmDelete(int index) async {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Apakah kamu yakin ingin menghapus ${alatList[index]['title']}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8B7A2),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text('Peminjaman', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                  return Dismissible(
                    key: Key(alat['title']),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 16),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (_) async {
                      final result = await _confirmDelete(index);
                      if (result == true) {
                        setState(() {
                          alatList.removeAt(index);
                        });
                        return true;
                      }
                      return false;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4C7AE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          // Gambar alat
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
                          Expanded(child: Text(alat['title'], style: const TextStyle(fontWeight: FontWeight.bold))),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _decrementCount(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.remove, size: 16),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text("${alat['count']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _incrementCount(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.add, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                      builder: (_) => AjukanPeminjaman(alatList: List<Map<String, dynamic>>.from(alatList)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF6C3E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Ajukan Peminjaman', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
