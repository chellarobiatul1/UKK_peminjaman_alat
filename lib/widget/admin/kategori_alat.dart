import 'package:flutter/material.dart';

class KategoriAlat extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const KategoriAlat({
    super.key,
    required this.text,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor:
              isActive ? const Color(0xFFF26A2E) : Colors.white,
        ),
      ),
    );
  }
}
