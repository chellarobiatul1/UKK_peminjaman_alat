import 'package:flutter/material.dart';
import 'pemberitahuan_sukses.dart';

enum AlatMode { tambah, edit, hapus }

class CrudAlat extends StatelessWidget {
  final AlatMode mode;
  const CrudAlat({super.key, required this.mode});

  bool get isTambah => mode == AlatMode.tambah;
  bool get isEdit => mode == AlatMode.edit;
  bool get isHapus => mode == AlatMode.hapus;

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
            /// 🔹 JUDUL
            Text(
              isTambah
                  ? "Tambah Alat Baru"
                  : isEdit
                      ? "Edit Alat"
                      : "Hapus Alat",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),

            /// 🔹 HAPUS
            if (isHapus)
              const Text(
                "Apakah kamu yakin ingin menghapus alat ini?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),

            /// 🔹 TAMBAH & EDIT
            if (!isHapus) ...[
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(height: 12),
              _inputField("Nama Alat"),
              const SizedBox(height: 8),
              _inputField("Kategori"),
              const SizedBox(height: 8),
              _inputField("Jumlah"),
              const SizedBox(height: 8),
              _inputField("Kondisi"),
            ],

            const SizedBox(height: 14),

            /// 🔹 TOMBOL
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
                    onPressed: () {
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isHapus ? Colors.red : Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: Text(
                      isTambah
                          ? "Tambah"
                          : isEdit
                              ? "Simpan"
                              : "Hapus",
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

  static Widget _inputField(String hint) {
    return SizedBox(
      height: 32,
      child: TextField(
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
}
