import 'package:flutter/material.dart';
import 'package:peminjaman_alat/auth/login_page.dart';
import 'package:peminjaman_alat/screens/petugas/dashboard_petugas.dart';
import 'package:peminjaman_alat/screens/petugas/persetujuan_page.dart';
import 'package:peminjaman_alat/screens/petugas/cetak_laporan_page.dart';
import 'package:peminjaman_alat/screens/petugas/monitoring_pengembalian.dart';

class DrawerPetugas extends StatelessWidget {
  const DrawerPetugas({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: const Color(0xFFF6F6F6),
      child: Column(
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF4A261),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.engineering, color: Colors.black),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Petugas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Manajemen Alat',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ================= MENU =================
          _drawerItem(
            context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const DashboardPetugas(),
                ),
              );
            },
          ),

          _drawerItem(
            context,
            icon: Icons.list_alt,
            title: 'Persetujuan',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const PersetujuanPage(),
                ),
              );
            },
          ),

          // ===== MENU BARU =====
          _drawerItem(
            context,
            icon: Icons.assignment_return,
            title: 'Monitoring Pengembalian',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const MonitoringPengembalian(),
                ),
              );
            },
          ),

          _drawerItem(
            context,
            icon: Icons.print,
            title: 'Cetak Laporan',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CetakLaporanPage(),
                ),
              );
            },
          ),

          const Spacer(),

          // ================= LOGOUT =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= ITEM BUILDER =================
  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFF4A261)),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
