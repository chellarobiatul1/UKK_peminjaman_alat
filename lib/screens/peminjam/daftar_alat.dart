import 'package:flutter/material.dart';
import 'package:peminjaman_alat/widget/admin/crud_alat.dart';
import 'package:peminjaman_alat/screens/admin/kategori_alat.dart';

class AlatAdmin extends StatefulWidget {
  const AlatAdmin({super.key});

  @override
  State<AlatAdmin> createState() => _AlatAdminState();
}

class _AlatAdminState extends State<AlatAdmin> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = "";

  final List<Map<String, String>> allTools = [
    {
      "title": "Multi Meter",
      "stock": "10 pcs",
      "image": "assets/images/multimeter.jpg",
      "status": "baik",
      "category": "Ukur",
    },
    {
      "title": "Volt Meter",
      "stock": "10 pcs",
      "image": "assets/images/voltmtr.jpg",
      "status": "dipinjam",
      "category": "Ukur",
    },
    {
      "title": "Ampere Meter",
      "stock": "10 pcs",
      "image": "assets/images/amperemtr.jpg",
      "status": "diperbaiki",
      "category": "Ukur",
    },
    {
      "title": "Power Meter",
      "stock": "10 pcs",
      "image": "assets/images/power_meter.jpg",
      "status": "baik",
      "category": "Ukur",
    },
    {
      "title": "Oscilloscope",
      "stock": "10 pcs",
      "image": "assets/images/Oscilloscope.jpg",
      "status": "baik",
      "category": "Komponen",
    },
    {
      "title": "Test Pen",
      "stock": "10 pcs",
      "image": "assets/images/pen.jpg",
      "status": "baik",
      "category": "Perkakas",
    },
  ];

  List<Map<String, String>> filteredTools = [];

  @override
  void initState() {
    super.initState();
    filteredTools = allTools;
  }

  void _applyFilter() {
    setState(() {
      filteredTools = allTools.where((tool) {
        final matchSearch = tool["title"]!.toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
        final matchCategory =
            selectedCategory.isEmpty || tool["category"] == selectedCategory;
        return matchSearch && matchCategory;
      }).toList();
    });
  }

  void _searchTool(String query) => _applyFilter();

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = selectedCategory == category ? "" : category;
    });
    _applyFilter();
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
                controller: _searchController,
                onChanged: _searchTool,
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
                    onTap: () => _selectCategory("Keselamatan"),
                  ),
                  KategoriAlat(
                    text: "Ukur",
                    isActive: selectedCategory == "Ukur",
                    onTap: () => _selectCategory("Ukur"),
                  ),
                  KategoriAlat(
                    text: "Komponen",
                    isActive: selectedCategory == "Komponen",
                    onTap: () => _selectCategory("Komponen"),
                  ),
                  KategoriAlat(
                    text: "Perkakas",
                    isActive: selectedCategory == "Perkakas",
                    onTap: () => _selectCategory("Perkakas"),
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
                  tool["title"]!,
                  tool["stock"]!,
                  tool["image"]!,
                  tool["status"]!,
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
                  builder: (context) => const CrudAlat(mode: AlatMode.tambah),
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

  /// ================= CARD ALAT (DENGAN EDIT + DELETE)
  static Widget toolCard(
    BuildContext context,
    String title,
    String stock,
    String imagePath,
    String status,
  ) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// ✏️ EDIT ICON
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const CrudAlat(mode: AlatMode.edit),
                      );
                    },
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
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
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  title,
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
                  stock,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        /// 🗑️ DELETE ICON
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const CrudAlat(mode: AlatMode.hapus),
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
