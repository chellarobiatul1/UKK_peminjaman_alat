import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/admin/alat_admin.dart';
import 'package:peminjaman_alat/screens/admin/dashboard_admin.dart';
import 'package:peminjaman_alat/screens/admin/pengembalian_admin.dart';
import 'package:peminjaman_alat/screens/admin/pengguna_admin.dart';
import 'package:peminjaman_alat/screens/admin/peminjaman_admin.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'DASHBOARD',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Pengguna'),
            onTap: () {
              Navigator.pop(context); // tutup drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PenggunaAdmin(),
                ),
              );
            },
          ),

          /// 👉 MENU ALAT
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Alat'),
            onTap: () {
              Navigator.pop(context); // tutup drawer dulu
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AlatAdmin(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardAdmin(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.timelapse),
            title: const Text('Peminjaman'),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  PeminjamanAdmin(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Pengembalian'),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PengembalianAdmin(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Log Aktivitas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardAdmin(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
