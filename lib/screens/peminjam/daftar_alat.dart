import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/admin/kategori_alat.dart';
import 'package:peminjaman_alat/screens/drawer/bottomnav_peminjam.dart';
import 'package:peminjaman_alat/screens/peminjam/box_peminjam.dart';

class DaftarAlat extends StatefulWidget {
  const DaftarAlat({super.key});

  @override
  State<DaftarAlat> createState() => _DaftarAlatState();
}

class _DaftarAlatState extends State<DaftarAlat> {
  String selectedCategory = "Ukur";
  int _selectedIndex = 0;

  TextEditingController searchController = TextEditingController();

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
  int totalAdded = 0; // total klik + untuk badge di bottom nav

  @override
  void initState() {
    super.initState();
    filteredTools =
        allTools.where((tool) => tool["category"] == selectedCategory).toList();
  }

  void _selectCategory(String category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = "";
      } else {
        selectedCategory = category;
      }
      _filterTools(searchController.text);
    });
  }

  void _filterTools(String query) {
    setState(() {
      filteredTools = allTools.where((tool) {
        final matchesCategory =
            selectedCategory.isEmpty || tool["category"] == selectedCategory;
        final matchesQuery = tool["title"]!
            .toLowerCase()
            .contains(query.toLowerCase());
        return matchesCategory && matchesQuery;
      }).toList();
    });
  }

  void _incrementCounter() {
    setState(() {
      totalAdded += 1; // setiap klik + tambah 1
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Listrik\nTool Loan",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  KategoriAlat(
                    text: "Ukur",
                    isActive: selectedCategory == "Ukur",
                    onTap: () => _selectCategory("Ukur"),
                  ),
                  KategoriAlat(
                    text: "Keselamatan",
                    isActive: selectedCategory == "Keselamatan",
                    onTap: () => _selectCategory("Keselamatan"),
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
          ),

          const SizedBox(height: 8),

          // Search di tengah
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: searchController,
                  onChanged: _filterTools,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // GRID ALAT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.72,
                children: filteredTools.map((tool) {
                  final title = tool["title"]!;
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tool["status"]!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              child: Image.asset(
                                tool["image"]!,
                                fit: BoxFit.contain,
                              ),
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
                                tool["stock"]!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: _incrementCounter,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.add,
                              size: 20,
                              color: Color(0xFFF26A2E),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNav(
  currentIndex: _selectedIndex,
  onTap: (index) {
    _onItemTapped(index);
    if (index == 1) { // kalau klik Box
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PeminjamanPage(),
        ),
      );
    }
  },
  boxCount: totalAdded,     // jumlah klik + di card
  parentContext: context,   // wajib dikirim agar navigasi ke PeminjamanPage
),

    );
  }
}
