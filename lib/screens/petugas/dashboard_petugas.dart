import 'package:flutter/material.dart';

class DashboardPetugas extends StatelessWidget {
  const DashboardPetugas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Petugas')),
      body: const Center(child: Text('Ini UI Petugas')),
    );
  }
}
