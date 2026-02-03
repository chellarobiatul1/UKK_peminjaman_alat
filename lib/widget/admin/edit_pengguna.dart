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

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedLevel = 'user';

  bool get isTambah => widget.mode == PenggunaMode.tambah;
  bool get isEdit => widget.mode == PenggunaMode.edit;
  bool get isHapus => widget.mode == PenggunaMode.hapus;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    try {
      if (widget.penggunaData != null) {
        // Safely get values with null checks and toString()
        final nama = widget.penggunaData!['nama'];
        final username = widget.penggunaData!['username'];
        final level = widget.penggunaData!['level'];

        _namaController.text = nama != null ? nama.toString() : '';
        _usernameController.text = username != null ? username.toString() : '';
        _passwordController.text = ''; // Always empty for security

        if (level != null) {
          final levelStr = level.toString().toLowerCase();
          if (levelStr == 'admin' || levelStr == 'user' || levelStr == 'petugas') {
            _selectedLevel = levelStr;
          }
        }

        print('Data loaded: nama=$nama, username=$username, level=$level');
      }
    } catch (e) {
      print('Error initializing controllers: $e');
      // Keep default empty values
    }
  }

  Future<void> submit() async {
    try {
      print('Submit started - Mode: ${widget.mode}');

      if (!isHapus) {
        // Validation
        final nama = _namaController.text.trim();
        final username = _usernameController.text.trim();
        final password = _passwordController.text.trim();

        print('Validating - nama: $nama, username: $username, password length: ${password.length}');

        if (nama.isEmpty) {
          _showError('Nama tidak boleh kosong');
          return;
        }
        if (username.isEmpty) {
          _showError('Username tidak boleh kosong');
          return;
        }
        if (isTambah && password.isEmpty) {
          _showError('Password tidak boleh kosong');
          return;
        }
      }

      // Show loading
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      try {
        if (isTambah) {
          print('Adding new user...');
          final data = {
            'nama': _namaController.text.trim(),
            'username': _usernameController.text.trim(),
            'password': _passwordController.text.trim(),
            'level': _selectedLevel,
          };
          print('Data to insert: $data');
          await _service.tambahPengguna(data);
          
        } else if (isEdit) {
          print('Updating user...');
          
          // Get ID with proper null check
          final userId = widget.penggunaData!['id'];
          if (userId == null) {
            throw Exception('User ID is null');
          }
          
          final id = userId is int ? userId : int.parse(userId.toString());
          print('User ID: $id');
          
          final data = {
            'nama': _namaController.text.trim(),
            'username': _usernameController.text.trim(),
            'level': _selectedLevel,
          };

          // Only update password if provided
          final password = _passwordController.text.trim();
          if (password.isNotEmpty) {
            data['password'] = password;
          }

          print('Data to update: $data');
          await _service.updatePengguna(id, data);
          
        } else if (isHapus) {
          print('Deleting user...');
          
          // Get ID with proper null check
          final userId = widget.penggunaData!['id'];
          if (userId == null) {
            throw Exception('User ID is null');
          }
          
          final id = userId is int ? userId : int.parse(userId.toString());
          print('User ID to delete: $id');
          await _service.hapusPengguna(id);
        }

        print('Operation completed successfully');

        // Close loading
        if (!mounted) return;
        Navigator.of(context).pop();

        // Call success callback
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        }

        // Close dialog
        if (!mounted) return;
        Navigator.of(context).pop();

        // Show success message with simple AlertDialog (to avoid PemberitahuanSukses issues)
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xFFE9B9A4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  isTambah
                      ? "Berhasil menambahkan pengguna"
                      : isEdit
                          ? "Berhasil menyimpan perubahan"
                          : "Berhasil menghapus pengguna",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        
        // Auto close after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        });
        
      } catch (e) {
        print('Error during operation: $e');
        print('Error type: ${e.runtimeType}');
        
        // Close loading
        if (mounted) {
          Navigator.of(context).pop();
        }

        if (!mounted) return;

        String errorMessage = 'Terjadi kesalahan: ${e.toString()}';

        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('duplicate') || errorStr.contains('unique')) {
          errorMessage = 'Username sudah digunakan';
        } else if (errorStr.contains('foreign')) {
          errorMessage = 'Data masih digunakan di tabel lain';
        } else if (errorStr.contains('null')) {
          errorMessage = 'Data tidak valid, periksa kembali';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      print('Fatal error in submit: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = "Tambah Pengguna Baru";
    if (isEdit) title = "Edit Pengguna";
    if (isHapus) title = "Hapus Pengguna";

    String userName = '';
    if (widget.penggunaData != null && widget.penggunaData!['nama'] != null) {
      userName = widget.penggunaData!['nama'].toString();
    }

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
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),

            if (isHapus)
              Text(
                userName.isNotEmpty 
                    ? "Apakah kamu yakin ingin menghapus pengguna $userName?"
                    : "Apakah kamu yakin ingin menghapus pengguna ini?",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),

            if (!isHapus) ...[
              _buildInputField(
                "Nama",
                controller: _namaController,
              ),
              const SizedBox(height: 8),
              
              _buildInputField(
                "Username",
                controller: _usernameController,
              ),
              const SizedBox(height: 8),
              
              _buildInputField(
                isEdit ? "Password (kosongkan jika tidak diubah)" : "Password",
                controller: _passwordController,
                obscure: true,
              ),
              const SizedBox(height: 8),

              _buildLevelDropdown(),
            ],

            const SizedBox(height: 14),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String hint, {
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 11),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelDropdown() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLevel,
          isExpanded: true,
          isDense: true,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black,
          ),
          items: const [
            DropdownMenuItem(
              value: 'admin',
              child: Text('Admin'),
            ),
            DropdownMenuItem(
              value: 'user',
              child: Text('User'),
            ),
            DropdownMenuItem(
              value: 'petugas',
              child: Text('Petugas'),
            ),
          ],
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLevel = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}