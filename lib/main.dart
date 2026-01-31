import 'package:flutter/material.dart';
import 'package:peminjaman_alat/screens/auth/splash_page.dart';
import 'package:peminjaman_alat/service/supabase_service.dart';
import 'package:peminjaman_alat/screens/admin/alat_admin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await SupabaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
