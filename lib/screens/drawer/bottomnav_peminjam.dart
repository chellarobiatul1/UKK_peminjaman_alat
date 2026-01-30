import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/peminjam/box_peminjam.dart'; // pastikan path sesuai

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int boxCount;
  final BuildContext parentContext; // tambahkan context supaya bisa navigasi

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.boxCount = 0,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey[600],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        // jika Box diklik
        if (index == 1) {
          Navigator.push(
            parentContext,
            MaterialPageRoute(
              builder: (_) => const BoxPeminjam(),
            ),
          );
        } else {
          onTap(index);
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.add_box_outlined),
              if (boxCount > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      boxCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: 'Box',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          label: 'List',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'User',
        ),
      ],
    );
  }
}
