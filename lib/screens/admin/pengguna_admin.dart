import 'package:flutter/material.dart';
import '../drawer/drawer_admin.dart';
import 'package:peminjaman_alat/widget/admin/edit_pengguna.dart';

class PenggunaAdmin extends StatefulWidget {
  const PenggunaAdmin({super.key});

  @override
  State<PenggunaAdmin> createState() => _PenggunaAdminState();
}

class _PenggunaAdminState extends State<PenggunaAdmin> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> users = [
    {
      "name": "Clarissa Kurnia Putri",
      "email": "clarissa@gmail.com",
      "id": "14062007",
      "role": "peminjam",
      "color": Colors.green,
    },
    {
      "name": "Melati Tiara Permata D",
      "email": "melati@gmail.com",
      "id": "18012008",
      "role": "admin",
      "color": Colors.red,
    },
    {
      "name": "Nur Zahra Fritiana Y",
      "email": "nur@gmail.com",
      "id": "27082006",
      "role": "petugas",
      "color": Colors.blueGrey,
    },
    {
      "name": "Chella Robiatul A",
      "email": "clarissa@gmail.com",
      "id": "18032008",
      "role": "peminjam",
      "color": Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((user) {
      final q = searchController.text.toLowerCase();
      return user["name"].toLowerCase().contains(q) ||
          user["role"].toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      drawer: const DrawerAdmin(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Pengguna",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔍 SEARCH (DI TENGAH & REALTIME)
            Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: "Cari pengguna...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// 📋 LIST USER (UI ASLI BALIK)
            Expanded(
              child: ListView(
                children: filteredUsers.map((u) {
                  return userCard(
                    context: context,
                    name: u["name"],
                    email: u["email"],
                    id: u["id"],
                    role: u["role"],
                    color: u["color"],
                  );
                }).toList(),
              ),
            ),

            /// ➕ TAMBAH
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4C7A1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const CrudPengguna(
                      mode: PenggunaMode.tambah,
                    ),
                  );
                },
                child: const Text(
                  "+ pengguna baru",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 👉 USER CARD (PERSIS UI KAMU)
  Widget userCard({
    required BuildContext context,
    required String name,
    required String email,
    required String id,
    required String role,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color,
            child: Text(
              name[0],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(email,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade700)),
                Text(id,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade700)),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  role,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CrudPengguna(
                          mode: PenggunaMode.edit,
                        ),
                      );
                    },
                    child: const Icon(Icons.edit, size: 18),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CrudPengguna(
                          mode: PenggunaMode.hapus,
                        ),
                      );
                    },
                    child:
                        const Icon(Icons.delete, size: 18, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
