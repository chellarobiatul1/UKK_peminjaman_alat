import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/drawer/bottomnav_peminjam.dart';
import 'package:peminjaman_alat/screens/peminjam/confirmation_page.dart';

class PengembalianPeminjamanPage extends StatefulWidget {
  final List<Map<String, dynamic>> alatList;

  const PengembalianPeminjamanPage({super.key, required this.alatList});

  @override
  State<PengembalianPeminjamanPage> createState() =>
      _PengembalianPeminjamanPageState();
}

class _PengembalianPeminjamanPageState
    extends State<PengembalianPeminjamanPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController tanggalPinjamController = TextEditingController();
  final TextEditingController tanggalKembaliController =
      TextEditingController();
  final TextEditingController tanggalPengembalianController =
      TextEditingController();

  Future<void> pilihTanggal(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color orangeColor = Color(0xFFF4A261);

    final int boxCount = widget.alatList.fold<int>(
      0,
      (sum, item) => sum + (item['count'] as int),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              child: Text('Menu', style: TextStyle(fontSize: 18)),
            ),
            ListTile(title: Text('Home')),
            ListTile(title: Text('Peminjaman')),
            ListTile(title: Text('Pengembalian')),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              color: orangeColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              width: double.infinity,
              child: Row(
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: const Icon(Icons.menu, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Pengembalian Peminjaman',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Verifikasi Peminjaman',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),

            // ===== DATA DIRI =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text(
                        'Data Diri',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: namaController,
                        decoration: const InputDecoration(
                          hintText: 'Nama',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: userController,
                        decoration: const InputDecoration(
                          hintText: 'User',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ===== TANGGAL =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text(
                        'Tanggal',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: tanggalPinjamController,
                        readOnly: true,
                        onTap: () => pilihTanggal(tanggalPinjamController),
                        decoration: const InputDecoration(
                          hintText: 'Tanggal Pinjam',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: tanggalKembaliController,
                        readOnly: true,
                        onTap: () => pilihTanggal(tanggalKembaliController),
                        decoration: const InputDecoration(
                          hintText: 'Tanggal Kembali',
                          prefixIcon: Icon(Icons.event_repeat),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: tanggalPengembalianController,
                        readOnly: true,
                        onTap: () =>
                            pilihTanggal(tanggalPengembalianController),
                        decoration: const InputDecoration(
                          hintText: 'Tanggal Pengembalian',
                          prefixIcon: Icon(Icons.assignment_returned),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ===== ALAT FLEXIBLE =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alat',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      ...widget.alatList.map(
                        (alat) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[100],
                          ),
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
                                  child: Image.asset(
                                    alat['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  alat['title'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                "${alat['count']} pcs",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.delete, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // ===== BUTTON AJUKAN =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfirmationPage(
  nama: namaController.text,
  user: userController.text,
  tanggalPinjam: tanggalPinjamController.text,
  tanggalKembali: tanggalKembaliController.text,
  alatList: widget.alatList,
),
),
                    );
                  },
                  child: const Text(
                    'ajukan',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 1, boxCount: boxCount),
    );
  }
}
