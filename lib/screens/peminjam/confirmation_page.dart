import 'package:flutter/material.dart';
import 'package:peminjaman_alat/service/aktifitas_service.dart';
import 'package:peminjaman_alat/screens/peminjam/list_aktifitas.dart';

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

      /// APPBAR
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

      /// BODY
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: orangeColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 40,
                  color: orangeColor,
                ),
              ),

              const SizedBox(height: 24),

              /// TITLE
              const Text(
                "Successful!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// DESC
              const Text(
                "Permintaan peminjaman berhasil diajukan.\nSilakan tunggu konfirmasi.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 24),

              /// RINGKASAN
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

              /// BUTTON
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
                  onPressed: () {
  // ✅ BUAT SALINAN LIST
  final List<Map<String, dynamic>> alatDisimpan =
      List<Map<String, dynamic>>.from(
        alatList.map((e) => Map<String, dynamic>.from(e)),
      );

  // ✅ SIMPAN KE AKTIFITAS
  AktifitasService.tambahAktifitas(
    nama: nama,
    user: user,
    tanggalPinjam: tanggalPinjam,
    tanggalKembali: tanggalKembali,
    alatList: alatDisimpan, // ⬅️ pakai salinan
  );

  // ✅ KOSONGKAN BOX (AMAN SEKARANG)
  alatList.clear();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const ListAktifitas(),
    ),
    (route) => false,
  );
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
