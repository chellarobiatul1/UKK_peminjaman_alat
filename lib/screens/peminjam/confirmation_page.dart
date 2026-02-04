import 'package:flutter/material.dart';
import 'package:peminjaman_alat/service/peminjaman_service.dart';
import 'package:peminjaman_alat/screens/peminjam/list_aktifitas.dart';
import 'package:peminjaman_alat/service/auth_service.dart';

class ConfirmationPage extends StatelessWidget {
  final String nama;
  final String user;
  final String tanggalPinjam;
  final String tanggalKembali;
  final List<Map<String, dynamic>> alatList;

  const ConfirmationPage({
    super.key,
    required this.nama,
    required this.user,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.alatList,
  });

  static const Color orangeColor = Color(0xFFF36F21);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Confirmation",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: orangeColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 40,
                  color: orangeColor,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Successful!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Permintaan peminjaman berhasil diajukan.\nSilakan tunggu konfirmasi.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama: $nama"),
                    Text("User: $user"),
                    const SizedBox(height: 6),
                    Text("Pinjam: $tanggalPinjam"),
                    Text("Kembali: $tanggalKembali"),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: orangeColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  ),
  onPressed: () async {
    try {
      // copy list alat
      final List<Map<String, dynamic>> alatDisimpan = alatList
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      // pakai userId manual
      final userId = AuthService.currentUserId;
      if (userId == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan login terlebih dahulu')),
        );
        return;
      }

      // panggil service untuk ajukan peminjaman
      await PeminjamanService.ajukanPeminjaman(
        userId: userId,
        tanggalPinjam: tanggalPinjam,
        tanggalKembali: tanggalKembali,
        alatList: alatDisimpan,
      );

      // kosongkan keranjang setelah peminjaman diajukan
      alatList.clear();

      if (!context.mounted) return;

      // Navigasi ke ListAktifitas
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const ListAktifitas(),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengajukan peminjaman: $e'),
        ),
      );
    }
  },
  child: const Text(
    "Lanjutkan",
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
