import 'package:flutter/material.dart';
import 'package:peminjaman_alat/widget/admin/edit_peminjaman.dart';
import '../drawer/drawer_admin.dart';
import 'pengembalian_admin.dart';

class PeminjamanAdmin extends StatefulWidget {
  const PeminjamanAdmin({super.key});

  @override
  State<PeminjamanAdmin> createState() => _PeminjamanAdminState();
}

class _PeminjamanAdminState extends State<PeminjamanAdmin> {
  final TextEditingController searchController = TextEditingController();

  late ValueNotifier<List<Map<String, String>>> filtered;
  List<Map<String, String>> data = [
  {
    "nama": "Budi",
    "alat": "Laptop",
    "tanggal peminjaman": "01/02/2026",
    "tanggal kembali": "05/02/2026",
    "status": "approve", // langsung approve
  },
  {
    "nama": "Siti",
    "alat": "Proyektor",
    "tanggal peminjaman": "02/02/2026",
    "tanggal kembali": "06/02/2026",
    "status": "pending",
  },
];


  @override
  void initState() {
    super.initState();
    filtered = ValueNotifier(data);

    searchController.addListener(() {
      final q = searchController.text.toLowerCase();
      filtered.value = data.where((e) {
        return (e["nama"] ?? "").toLowerCase().contains(q) ||
            (e["alat"] ?? "").toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerAdmin(),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            color: const Color(0xFFE9B9A5),
            child: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'peminjaman\n& pengembalian',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'search...',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // TAB
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1872D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Peminjaman',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PengembalianAdmin(),
                      ),
                    );
                  },
                  child: const Text(
                    'Pengembalian',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // LIST
          Expanded(
            child: ValueListenableBuilder<List<Map<String, String>>>(
              valueListenable: filtered,
              builder: (context, list, _) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final item = list[i];
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha((0.15 * 255).toInt()), // deprecated fixed
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 160,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF6A55F),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["nama"] ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Alat : ${item["alat"] ?? ""}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Tanggal Peminjaman : ${item["tanggal peminjaman"] ?? ""}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Tanggal Kembali : ${item["tanggal kembali"] ?? ""}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4CAF50),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          item["status"] ?? "",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ICON EDIT
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => EditPeminjamanDialog(
                                  item: item,
                                  onSave: (updatedItem) {
                                    setState(() {
                                      item["nama"] =
                                          updatedItem["nama"] ?? "";
                                      item["alat"] = updatedItem["alat"] ?? "";
                                      item["tanggal peminjaman"] =
                                          updatedItem["tanggal peminjaman"] ?? "";
                                      item["tanggal kembali"] =
                                          updatedItem["tanggal kembali"] ?? "";
                                    });
                                  },
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
