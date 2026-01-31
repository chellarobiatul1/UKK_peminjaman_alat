import 'package:flutter/material.dart';
import 'package:peminjaman_alat/widget/admin/pemberitahuan_sukses.dart';

enum PenggunaMode { tambah, edit, hapus }

class CrudPengguna extends StatelessWidget {
  final PenggunaMode mode;

  const CrudPengguna({
    super.key,
    required this.mode,
  });

  bool get isTambah => mode == PenggunaMode.tambah;
  bool get isEdit => mode == PenggunaMode.edit;
  bool get isHapus => mode == PenggunaMode.hapus;

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
                  ? "Tambah Pengguna Baru"
                  : isEdit
                      ? "Edit Pengguna"
                      : "Hapus Pengguna",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            /// 🔹 KHUSUS HAPUS
            if (isHapus)
              const Text(
                "Apakah kamu yakin ingin menghapus pengguna ini?",
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
              _inputField("Nama pengguna"),
              const SizedBox(height: 8),
              _inputField("User"),
              const SizedBox(height: 8),
              _inputField("Password"),
              const SizedBox(height: 8),
              _inputField("Role"),
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
                    child: const Text(
                      "Batal",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      /// Tutup dialog utama
                      Navigator.pop(context);

                      /// Dialog sukses (klik di mana aja = hilang)
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: PemberitahuanSukses(
                            message: isTambah
                                ? "Berhasil menambahkan pengguna"
                                : isEdit
                                    ? "Berhasil menyimpan perubahan"
                                    : "Berhasil menghapus pengguna",
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
            ),
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
