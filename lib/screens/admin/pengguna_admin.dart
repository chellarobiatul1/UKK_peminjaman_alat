import 'package:flutter/material.dart';
import '../drawer/drawer_admin.dart';
import 'package:peminjaman_alat/widget/admin/edit_pengguna.dart';
import 'package:peminjaman_alat/service/pengguna_service.dart';

class PenggunaAdmin extends StatefulWidget {
  const PenggunaAdmin({super.key});

  @override
  State<PenggunaAdmin> createState() => _PenggunaAdminState();
}

class _PenggunaAdminState extends State<PenggunaAdmin> {
  final TextEditingController searchController = TextEditingController();
  final PenggunaService _service = PenggunaService();

  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final data = await _service.getUsers();
    setState(() {
      users = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((user) {
  final q = searchController.text.toLowerCase();

  final nama = (user["nama"] ?? "").toString().toLowerCase();
  final level = (user["level"] ?? "").toString().toLowerCase();

  return nama.contains(q) || level.contains(q);
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
            // 🔍 SEARCH BAR
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

            // 📋 LIST USER
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView(
                      children: filteredUsers.map((u) {
                        return userCard(
                          userData: u,
                         name: (u["nama"] ?? "").toString(),
                          id: u["id"].toString(),
                          level: u["level"],
                          color: u["level"] == "admin"
                              ? Colors.red
                              : u["level"] == "petugas"
                                  ? Colors.blueGrey
                                  : Colors.green,
                        );
                      }).toList(),
                    ),
                  ),

            // ➕ TAMBAH PENGGUNA
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
                    builder: (context) => EditPengguna(
                      mode: PenggunaMode.tambah,
                      onSuccess: () {
                        fetchUsers();
                      },
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

  // 👉 USER CARD FUNCTION
  Widget userCard({
    required Map<String, dynamic> userData,
    required String name,
    required String id,
    required String level,
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
  name.isNotEmpty ? name[0].toUpperCase() : "?",
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
      Text(
        name.isNotEmpty ? name : '-',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      Text(
        id.isNotEmpty ? id : '-',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade700,
        ),
      ),
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
                  level,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context
                                            : context,
                        builder: (context) => EditPengguna(
                          mode: PenggunaMode.edit,
                          penggunaData: userData,
                          onSuccess: () {
                            fetchUsers();
                          },
                        ),
                      );
                    },
                    child: const Icon(Icons.edit, size: 18, color: Colors.blue),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      // Konfirmasi sebelum menghapus
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Hapus Pengguna"),
                          content: Text(
                              "Apakah Anda yakin ingin menghapus pengguna $name?"),
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

                      if (confirm ?? false) {
                       await _service.hapusPengguna(int.parse(id));
                        fetchUsers();
                      }
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
