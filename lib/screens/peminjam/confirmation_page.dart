import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/peminjam/daftar_alat.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color orangeColor = Color(0xFFF36F21);

    return Scaffold(
      backgroundColor: Colors.white,

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Confirmation',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // BODY
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ICON CHECK
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: orangeColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                size: 40,
                color: orangeColor,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // SUCCESS TEXT
          const Text(
            'Successful!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // DESCRIPTION
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Permintaan anda sedang diajukan tunggu beberapa saat untuk mendapatkan jawaban',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SizedBox(
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DaftarAlat(),
                    ),
                  );
                },
                child: const Text(
                  'Lanjutkan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
