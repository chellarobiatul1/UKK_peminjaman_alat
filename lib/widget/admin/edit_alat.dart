import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import '../../service/alat_service.dart';

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

  // 🔑 penting: URL untuk UI, PATH untuk storage
  String? existingImageUrl;
  String? existingImageStoragePath;

  late TextEditingController namaController;
  late TextEditingController kategoriController;
  late TextEditingController jumlahController;
  late TextEditingController kondisiController;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    namaController =
        TextEditingController(text: widget.alatData?['title'] ?? '');
    kategoriController =
        TextEditingController(text: widget.alatData?['category'] ?? '');
    jumlahController = TextEditingController(
        text: widget.alatData?['stock']?.toString() ?? '');
    kondisiController =
        TextEditingController(text: widget.alatData?['status'] ?? '');

    if (widget.mode == AlatMode.edit) {
      existingImageUrl = widget.alatData?['image_path'];
      existingImageStoragePath = widget.alatData?['image_storage'];
    }
  }

  Future<void> pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      selectedImageBytes = bytes;
      selectedFileName = image.name;
    });
  }

  Future<void> submit() async {
    try {
      final jumlah = int.tryParse(jumlahController.text) ?? 0;
      final kategori = int.tryParse(kategoriController.text) ?? 0;

      if (widget.mode == AlatMode.tambah) {
        await CrudAlatService.create(
          nama: namaController.text,
          jumlah: jumlah,
          kondisi: kondisiController.text,
          kategori: kategori,
          imageBytes: selectedImageBytes,
          fileName: selectedFileName,
        );
      } else if (widget.mode == AlatMode.edit) {
        await CrudAlatService.update(
          id: widget.alatData!['id'],
          nama: namaController.text,
          jumlah: jumlah,
          kondisi: kondisiController.text,
          kategori: kategori,
          imageBytes: selectedImageBytes,
          fileName: selectedFileName,
          oldImagePath: existingImageStoragePath,
        );
      } else if (widget.mode == AlatMode.hapus) {
        await CrudAlatService.delete(
          widget.alatData!['id'],
          imagePath: existingImageStoragePath,
        );
      }

      widget.onSuccess?.call();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Submit error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
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
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    )
                  : (widget.mode == AlatMode.edit &&
                          existingImageUrl != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            existingImageUrl!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          ),
                        )
                      : const Icon(Icons.image,
                          color: Colors.white, size: 70),
            ),
            const SizedBox(height: 12),
            inputField("Nama Alat", controller: namaController),
            const SizedBox(height: 8),
            inputField("Kategori (ID)", controller: kategoriController),
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
                    ),
                    child: const Text("Batal",
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.mode == AlatMode.hapus
                          ? Colors.red
                          : Colors.black,
                      foregroundColor: Colors.white,
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
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    kategoriController.dispose();
    jumlahController.dispose();
    kondisiController.dispose();
    super.dispose();
  }
}
