import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // ===== Tambahkan ini =====
  static Map<String, dynamic>? currentUser;

  static int get currentUserId => currentUser != null ? currentUser!['id'] as int : 0;

  // LOGIN USER
  static Future<String> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      final user = await _supabase
          .from('users')
          .select('id, username, password, level')
          .eq('username', username)
          .single();

      if (user == null) throw 'Username tidak ditemukan';

      final dbPassword = user['password'] as String?;
      final role = user['level'] as String?;

      if (dbPassword != password || role == null) throw 'Login gagal';

      currentUser = user; // simpan user yg login

      return role; // admin / petugas / peminjam
    } catch (e) {
      throw 'Login gagal: $e';
    }
  }

  // REGISTER USER tetap sama
  static Future<void> registerUser({
    required String nama,
    required String username,
    required String password,
    required String level,
  }) async {
    await _supabase.from('users').insert({
      'nama': nama,
      'username': username,
      'password': password,
      'level': level,
    });
  }
}
