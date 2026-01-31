import 'package:flutter/material.dart';
import 'package:peminjaman_alat/widget/admin/edit_alat.dart';
import 'package:peminjaman_alat/screens/drawer/drawer_admin.dart';
import 'kategori_alat.dart';
import '../../service/crud_alat_service.dart';
import 'dart:io'; // <--- tambahkan ini

class AlatAdmin extends StatefulWidget {
  const AlatAdmin({super.key});

  @override
  State<AlatAdmin> createState() => _AlatAdminState();
}

class _AlatAdminState extends State<AlatAdmin> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = "";

  List<Map<String, dynamic>> allTools = [];
  List<Map<String, dynamic>> filteredTools = [];

  @override
  void initState() {
    super.initState();
    fetchTools();
  }

  void fetchTools() async {
    final data = await CrudAlatService.getAll();
    setState(() {
      allTools = data;
      applyFilter();
    });
  }

  void applyFilter() {
    setState(() {
      filteredTools = allTools.where((tool) {
        final matchSearch = tool["title"]!
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
        final matchCategory = selectedCategory.isEmpty ||
            tool["category"] == selectedCategory;
        return matchSearch && matchCategory;
      }).toList();
    });
  }

  void searchTool(String query) => applyFilter();

  void selectCategory(String category) {
    setState(() {
      selectedCategory = selectedCategory == category ? "" : category;
    });
    applyFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE9B9A4),
        elevation: 0,
        title: const Text('Dashboard', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      // ✨ Tambahkan Drawer
      drawer: const DrawerAdmin(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔍 SEARCH
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                onChanged: searchTool,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Cari alat...",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// 🧩 KATEGORI
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  KategoriAlat(
                    text: "Keselamatan",
                    isActive: selectedCategory == "Keselamatan",
                    onTap: () => selectCategory("Keselamatan"),
                  ),
                  KategoriAlat(
                    text: "Ukur",
                    isActive: selectedCategory == "Ukur",
                    onTap: () => selectCategory("Ukur"),
                  ),
                  KategoriAlat(
                    text: "Komponen",
                    isActive: selectedCategory == "Komponen",
                    onTap: () => selectCategory("Komponen"),
                  ),
                  KategoriAlat(
                    text: "Perkakas",
                    isActive: selectedCategory == "Perkakas",
                    onTap: () => selectCategory("Perkakas"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// 🧱 GRID ALAT
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.72,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: filteredTools.map((tool) {
                return toolCard(
                  context,
                  tool,
                  onRefresh: fetchTools,
                );
              }).toList(),
            ),
          ],
        ),
      ),

      /// ➕ TAMBAH ALAT
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF26A2E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => EditAlat(
                    mode: AlatMode.tambah,
                    onSuccess: fetchTools,
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Tambah Alat",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget toolCard(
    BuildContext context,
    Map<String, dynamic> tool, {
    required Function onRefresh,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF26A2E),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // STATUS + EDIT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tool["status"],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => EditAlat(
                          mode: AlatMode.edit,
                          alatData: tool,
                          onSuccess: () => onRefresh(),
                        ),
                      );
                    },
                    child: const Icon(Icons.edit, size: 18, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: tool["image_path"] != null && tool["image_path"].isNotEmpty
                    ? Image.file(
                        File(tool["image_path"]),
                        fit: BoxFit.contain,
                      )
                    : const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  tool["title"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  "${tool["stock"]} pcs",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        // DELETE ICON
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => EditAlat(
                  mode: AlatMode.hapus,
                  alatData: tool,
                  onSuccess: () => onRefresh(),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete, color: Colors.red, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
