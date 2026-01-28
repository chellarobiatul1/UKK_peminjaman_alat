import 'package:flutter/material.dart';

class PemberitahuanSukses extends StatelessWidget {
  final String message;

  const PemberitahuanSukses({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF4F5D7E),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ICON CEKLIS
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.black,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),

            /// TEKS
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
