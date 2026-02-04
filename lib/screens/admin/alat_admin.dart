import 'package:flutter/material.dart';
import 'package:peminjaman_alat/widget/admin/edit_alat.dart';
import 'package:peminjaman_alat/screens/drawer/drawer_admin.dart';
import '../../widget/admin/kategori_alat.dart';
import 'package:peminjaman_alat/service/alat_service.dart';

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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Dashboard Alat',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      drawer: const DrawerAdmin(),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            /// 🔍 SEARCH
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: searchTool,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Cari alat...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🧩 KATEGORI
            SizedBox(
              height: 45,
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
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: filteredTools.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final tool = filteredTools[index];
                  return toolCard(context, tool, onRefresh: fetchTools);
                },
              ),
            ),
          ],
        ),
      ),

      /// ➕ TAMBAH ALAT
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFF26A2E),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => EditAlat(
              mode: AlatMode.tambah,
              onSuccess: fetchTools,
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah Alat"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  static Widget toolCard(
    BuildContext context,
    Map<String, dynamic> tool, {
    required VoidCallback onRefresh,
  }) {
    final String imageUrlWithCacheBuster = tool["image_path"] != null &&
            tool["image_path"].toString().startsWith("http")
        ? '${tool["image_path"]}?v=${DateTime.now().millisecondsSinceEpoch}'
        : 'assets/images/default.jpg';

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// IMAGE
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Image.network(
                  imageUrlWithCacheBuster,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, color: Colors.red, size: 40),
                ),
              ),

              const SizedBox(height: 12),

              /// TITLE
              Text(
                tool["title"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 4),

              /// STOCK
              Text(
                "${tool["stock"]} pcs",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 8),

              /// STATUS + ACTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF26A2E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tool["status"],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFF26A2E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => EditAlat(
                              mode: AlatMode.edit,
                              alatData: tool,
                              onSuccess: onRefresh,
                            ),
                          );
                        },
                        child: const Icon(Icons.edit,
                            size: 18, color: Color(0xFFF26A2E)),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => EditAlat(
                              mode: AlatMode.hapus,
                              alatData: tool,
                              onSuccess: onRefresh,
                            ),
                          );
                        },
                        child: const Icon(Icons.delete, size: 18, color: Colors.red),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
