import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/admin/alat_admin.dart';
import 'package:peminjaman_alat/screens/admin/dashboard_admin.dart';
import 'package:peminjaman_alat/screens/admin/pengembalian_admin.dart';
import 'package:peminjaman_alat/screens/admin/pengguna_admin.dart';
import 'package:peminjaman_alat/screens/admin/peminjaman_admin.dart';
import 'package:peminjaman_alat/screens/auth/login_page.dart';

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
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PenggunaAdmin(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Alat'),
            onTap: () {
              Navigator.pop(context);
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
                  builder: (context) => PeminjamanAdmin(),
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
                  builder: (context) => const DashboardAdmin(), // Ganti jika ada halaman log
                ),
              );
            },
          ),

          const Divider(), // garis pemisah

          /// 👉 LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context); // tutup drawer dulu
              
              // Navigasi ke halaman login dan hapus history
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );

              // Jika ada fungsi logout sebenarnya (hapus token, session, dll)
              // AuthService.logout();
            },
          ),
        ],
      ),
    );
  }
}
