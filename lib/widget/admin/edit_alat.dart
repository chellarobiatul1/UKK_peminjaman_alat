import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import '../../service/alat_service.dart';
import 'pemberitahuan_sukses.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AlatMode { tambah, edit, hapus }

class EditAlat extends StatefulWidget {
  final AlatMode mode;
  final Map<String, dynamic>? alatData;
  final VoidCallback? onSuccess;

  const EditAlat({
    super.key,
    required this.mode,
    this.alatData,
    this.onSuccess,
  });

  @override
  State<EditAlat> createState() => _EditAlatState();
}

class _EditAlatState extends State<EditAlat> {
  Uint8List? selectedImageBytes;
  String? selectedFileName;
  String? existingImagePath;

  late TextEditingController namaController;
  late TextEditingController jumlahController;
  late TextEditingController kondisiController;
  
  // Variabel untuk dropdown kategori
  List<Map<String, dynamic>> kategoriList = [];
  int? selectedKategoriId;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.alatData?['title'] ?? '');
    jumlahController = TextEditingController(text: widget.alatData?['stock']?.toString() ?? '');
    kondisiController = TextEditingController(text: widget.alatData?['status'] ?? '');

    // Set kategori dari data alat (jika edit)
    if (widget.mode == AlatMode.edit) {
      existingImagePath = widget.alatData?['image_path'];
      
      // Pastikan ini adalah integer
      final dynamic categoryData = widget.alatData?['category'];
      if (categoryData != null) {
        if (categoryData is int) {
          selectedKategoriId = categoryData;
        } else if (categoryData is String) {
          selectedKategoriId = int.tryParse(categoryData);
        } else if (categoryData is double) {
          selectedKategoriId = categoryData.toInt();
        }
      }
    }

    // Load kategori dari database
    loadKategori();
  }

  Future<void> loadKategori() async {
    try {
      final kategori = await KategoriService.getKategori();
      setState(() {
        kategoriList = kategori;
      });
    } catch (e) {
      debugPrint('Error loading kategori: $e');
      // Tampilkan error ke user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat kategori: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final bytes = await image.readAsBytes();

      setState(() {
        selectedImageBytes = bytes;
        selectedFileName = image.name;
      });
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> submit() async {
    try {
      final jumlah = int.tryParse(jumlahController.text) ?? 0;
      
      // Validasi kategori dipilih
      if (selectedKategoriId == null && widget.mode != AlatMode.hapus) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pilih kategori terlebih dahulu'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (widget.mode == AlatMode.tambah) {
        await CrudAlatService.create(
          nama: namaController.text,
          jumlah: jumlah,
          kondisi: kondisiController.text,
          kategori: selectedKategoriId!, // Gunakan ID kategori yang dipilih
          imageBytes: selectedImageBytes,
          fileName: selectedFileName,
        );
      } else if (widget.mode == AlatMode.edit) {
        await CrudAlatService.update(
          id: widget.alatData!['id'],
          nama: namaController.text,
          jumlah: jumlah,
          kondisi: kondisiController.text,
          kategori: selectedKategoriId!, // Gunakan ID kategori yang dipilih
          imageBytes: selectedImageBytes,
          fileName: selectedFileName,
          oldImagePath: existingImagePath,
        );
      } else if (widget.mode == AlatMode.hapus) {
        await CrudAlatService.delete(
          widget.alatData!['id'],
          imagePath: existingImagePath,
        );
      }

      widget.onSuccess?.call();

      if (!mounted) return;
      Navigator.pop(context);

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => GestureDetector(
          onTap: () => Navigator.pop(context),
          child: PemberitahuanSukses(
            message: widget.mode == AlatMode.tambah
                ? "Berhasil menambahkan alat"
                : widget.mode == AlatMode.edit
                    ? "Berhasil menyimpan perubahan"
                    : "Berhasil menghapus alat",
          ),
        ),
      );
    } catch (e) {
      debugPrint('Submit error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE9B9A4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: selectedImageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.memory(
                          selectedImageBytes!,
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                        ),
                      )
                    : (widget.mode == AlatMode.edit && existingImagePath != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              Supabase.instance.client.storage.from('alat').getPublicUrl(existingImagePath!),
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                            ),
                          )
                        : const Icon(Icons.image, color: Colors.white, size: 70),
              ),
              const SizedBox(height: 12),
              inputField("Nama Alat", controller: namaController),
              const SizedBox(height: 8),
              
              // Dropdown Kategori - VERSI DIPERBAIKI
              Container(
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: selectedKategoriId,
                    hint: Text(
                      "Pilih Kategori",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    items: kategoriList.map((kategori) {
                      return DropdownMenuItem<int>(
                        value: kategori['id'] as int?,
                        child: Text(
                          kategori['nama_kategori']?.toString() ?? 'Unknown',
                          style: const TextStyle(fontSize: 11),
                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedKategoriId = newValue;
                      });
                    },
                    underline: Container(), // Hilangkan garis bawah default
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down, size: 20),
                    style: const TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              inputField("Jumlah", controller: jumlahController),
              const SizedBox(height: 8),
              inputField("Kondisi", controller: kondisiController),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                      child: const Text("Batal", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.mode == AlatMode.hapus ? Colors.red : Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                      child: Text(
                        widget.mode == AlatMode.tambah
                            ? "Tambah"
                            : widget.mode == AlatMode.edit
                                ? "Simpan"
                                : "Hapus",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget inputField(
    String hint, {
    required TextEditingController controller,
  }) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 11),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    jumlahController.dispose();
    kondisiController.dispose();
    super.dispose();
  }
}

// Service untuk mendapatkan kategori
class KategoriService {
  static final _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getKategori() async {
    try {
      final response = await _supabase
          .from('kategori')
          .select('id, nama_kategori')
          .order('nama_kategori');

      // Konversi ke List<Map<String, dynamic>>
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error in KategoriService: $e');
      rethrow;
    }
  }
}