import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../service/crud_alat_service.dart';
import 'pemberitahuan_sukses.dart';

enum AlatMode { tambah, edit, hapus }

class EditAlat extends StatefulWidget {
  final AlatMode mode;
  final Map<String, dynamic>? alatData;
  final Function? onSuccess;

  const EditAlat({super.key, required this.mode, this.alatData, this.onSuccess});

  @override
  State<EditAlat> createState() => _EditAlatState();
}

class _EditAlatState extends State<EditAlat> {
  File? selectedFile;

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
  }

  bool get isTambah => widget.mode == AlatMode.tambah;
  bool get isEdit => widget.mode == AlatMode.edit;
  bool get isHapus => widget.mode == AlatMode.hapus;

  Future<void> submit() async {
    try {
      if (isTambah) {
        await CrudAlatService.create(
          nama: namaController.text,
          jumlah: int.parse(jumlahController.text),
          kondisi: kondisiController.text,
          kategori: int.parse(kategoriController.text),
          gambar: selectedFile?.path ?? '',
        );
      } else if (isEdit) {
        await CrudAlatService.update(
          id: widget.alatData!['id'],
          nama: namaController.text,
          jumlah: int.parse(jumlahController.text),
          kondisi: kondisiController.text,
          kategori: int.parse(kategoriController.text),
          gambar: selectedFile?.path ?? '',
        );
      } else if (isHapus) {
        await CrudAlatService.delete(widget.alatData!['id']);
      }

      if (widget.onSuccess != null) widget.onSuccess!();

      if (!mounted) return;
      Navigator.pop(context);

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => GestureDetector(
          onTap: () => Navigator.pop(context),
          child: PemberitahuanSukses(
            message: isTambah
                ? "Berhasil menambahkan alat"
                : isEdit
                    ? "Berhasil menyimpan perubahan"
                    : "Berhasil menghapus alat",
          ),
        ),
      );
    } catch (e) {
      print("Error: $e");
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
            Text(
              isTambah ? "Tambah Alat Baru" : isEdit ? "Edit Alat" : "Hapus Alat",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            if (isHapus)
              const Text(
                "Apakah kamu yakin ingin menghapus alat ini?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            if (!isHapus) ...[
              // Kotak abu clickable + preview gambar
              InkWell(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                    allowMultiple: false,
                  );

                  if (result != null && result.files.single.path != null) {
                    setState(() {
                      selectedFile = File(result.files.single.path!);
                    });
                    print("File dipilih: ${result.files.single.name}");
                    print("Path file: ${result.files.single.path}");
                  }
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black),
                  ),
                  child: selectedFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            selectedFile!,
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          ),
                        )
                      : const Icon(Icons.image, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              inputField("Nama Alat", controller: namaController),
              const SizedBox(height: 8),
              inputField("Kategori (ID)", controller: kategoriController),
              const SizedBox(height: 8),
              inputField("Jumlah", controller: jumlahController),
              const SizedBox(height: 8),
              inputField("Kondisi", controller: kondisiController),
            ],
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
                      backgroundColor: isHapus ? Colors.red : Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: Text(
                      isTambah ? "Tambah" : isEdit ? "Simpan" : "Hapus",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Widget inputField(String hint, {required TextEditingController controller}) {
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
