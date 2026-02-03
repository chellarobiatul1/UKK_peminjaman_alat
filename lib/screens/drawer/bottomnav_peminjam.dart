import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/peminjam/box_peminjam.dart';
import 'package:peminjaman_alat/screens/peminjam/daftar_alat.dart';
import 'package:peminjaman_alat/screens/peminjam/list_aktifitas.dart';
import 'package:peminjaman_alat/screens/peminjam/profile_peminjam.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final int boxCount;

  const BottomNav({
    super.key,
    required this.currentIndex,
    this.boxCount = 0,
  });

  void _navigate(BuildContext context, int index) {
    Widget page;

    switch (index) {
      case 0:
        page = const DaftarAlat();
        break;
      case 1:
        page = const BoxPeminjam();
        break;
      case 2:
        page = ListAktifitas(
        );
        break;
      case 3:
        page = const ProfilePeminjam();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

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
        if (index == currentIndex) return;
        _navigate(context, index);
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
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
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
