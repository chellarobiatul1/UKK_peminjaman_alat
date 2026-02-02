import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../service/alat_service.dart'; // sesuaikan path
import 'pemberitahuan_sukses.dart';
import 'package:image_picker/image_picker.dart';          // untuk pick gambar
import 'dart:typed_data';                                 // untuk Uint8List
import 'package:flutter/foundation.dart' show kIsWeb;    // untuk cek platform web
import 'package:flutter/foundation.dart' show debugPrint; // optional, kalau mau debug
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
  String? existingImagePath; // untuk edit (path lama di storage)

  late TextEditingController namaController;
  late TextEditingController kategoriController;
  late TextEditingController jumlahController;
  late TextEditingController kondisiController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.alatData?['title'] ?? '');
    kategoriController = TextEditingController(text: widget.alatData?['category'] ?? '');
    jumlahController = TextEditingController(text: widget.alatData?['stock']?.toString() ?? '');
    kondisiController = TextEditingController(text: widget.alatData?['status'] ?? '');

    if (widget.mode == AlatMode.edit) {
      existingImagePath = widget.alatData?['image_path'];
      // kalau mau tampilkan preview gambar lama, bisa pakai NetworkImage
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
      final kategori = int.tryParse(kategoriController.text) ?? 0;

      if (widget.mode == AlatMode.tambah) {
        await CrudAlatService.create(
  nama: namaController.text,
  jumlah: jumlah,
  kondisi: kondisiController.text,
  kategori: kategori,
  imageBytes: selectedImageBytes,     // <-- Uint8List?
  fileName: selectedFileName,          // <-- String?
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
  oldImagePath: existingImagePath,     // path lama dari storage
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
      // Optional: tampilkan error ke user
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
    kategoriController.dispose();
    jumlahController.dispose();
    kondisiController.dispose();
    super.dispose();
  }
}