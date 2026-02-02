import 'package:flutter/material.dart';
import 'package:peminjaman_alat/service/pengguna_service.dart';
import 'pemberitahuan_sukses.dart';
import 'dart:async';

enum PenggunaMode { tambah, edit, hapus }

class EditPengguna extends StatefulWidget {
  final PenggunaMode mode;
  final Map<String, dynamic>? penggunaData;
  final VoidCallback? onSuccess;

  const EditPengguna({
    super.key,
    required this.mode,
    this.penggunaData,
    this.onSuccess,
  });

  @override
  State<EditPengguna> createState() => _EditPenggunaDialogState();
}

class _EditPenggunaDialogState extends State<EditPengguna> {
  final _service = PenggunaService();

  late TextEditingController _namaController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _levelController;

  bool get isTambah => widget.mode == PenggunaMode.tambah;
  bool get isEdit => widget.mode == PenggunaMode.edit;
  bool get isHapus => widget.mode == PenggunaMode.hapus;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.penggunaData?['nama'] ?? '');
    _usernameController = TextEditingController(text: widget.penggunaData?['username'] ?? '');
    _passwordController = TextEditingController(text: widget.penggunaData?['password'] ?? '');
    _levelController = TextEditingController(text: widget.penggunaData?['level'] ?? '');
  }

  Future<void> submit() async {
    try {
      if (!isHapus) {
        // Validasi sederhana
        if (_namaController.text.isEmpty ||
            _usernameController.text.isEmpty ||
            _passwordController.text.isEmpty ||
            _levelController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Semua field harus diisi')),
          );
          return;
        }
      }

      if (isTambah) {
        await _service.tambahPengguna({
          'nama': _namaController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
          'level': _levelController.text,
        });
      } else if (isEdit) {
        await _service.updatePengguna(widget.penggunaData!['id'], {
          'nama': _namaController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
          'level': _levelController.text,
        });
      } else if (isHapus) {
      await _service.hapusPengguna(widget.penggunaData!['id']);
      }

      widget.onSuccess?.call();
      if (!mounted) return;
      Navigator.pop(context);

      // Notifikasi sukses
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
    } catch (e) {
      print('Error submit pengguna: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan, coba lagi')),
      );
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

            if (isHapus)
              const Text(
                "Apakah kamu yakin ingin menghapus pengguna ini?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),

            if (!isHapus) ...[
              _inputField("Nama", controller: _namaController),
              const SizedBox(height: 8),
              _inputField("Username", controller: _usernameController),
              const SizedBox(height: 8),
              _inputField("Password", controller: _passwordController, obscure: true),
              const SizedBox(height: 8),
              _inputField("level", controller: _levelController),
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

  static Widget _inputField(String hint,
      {required TextEditingController controller, bool obscure = false}) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: controller,
        obscureText: obscure,
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
    _namaController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _levelController.dispose();
    super.dispose();
  }
}
