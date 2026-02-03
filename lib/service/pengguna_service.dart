import 'package:supabase_flutter/supabase_flutter.dart';

class PenggunaService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Mengambil semua data users dari database
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final data = await supabase
          .from('users')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error getting users: $e');
      rethrow;
    }
  }

  /// Mengambil data user berdasarkan ID
  Future<Map<String, dynamic>?> getUserById(int id) async {
    try {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', id)
          .single();
      return data;
    } catch (e) {
      print('Error getting user by id: $e');
      return null;
    }
  }

  /// Menambahkan pengguna baru
  Future<void> tambahPengguna(Map<String, dynamic> data) async {
    try {
      await supabase.from('users').insert(data);
    } catch (e) {
      print('Error tambah pengguna: $e');
      rethrow;
    }
  }

  /// Update data pengguna
  Future<void> updatePengguna(int id, Map<String, dynamic> data) async {
    try {
      await supabase
          .from('users')
          .update(data)
          .eq('id', id);
    } catch (e) {
      print('Error update pengguna: $e');
      rethrow;
    }
  }

  /// Hapus pengguna berdasarkan ID
  Future<void> hapusPengguna(int id) async {
    try {
      await supabase
          .from('users')
          .delete()
          .eq('id', id);
    } catch (e) {
      print('Error hapus pengguna: $e');
      rethrow;
    }
  }

  /// Cek apakah username sudah digunakan
  Future<bool> isUsernameExist(String username, {int? excludeId}) async {
    try {
      var query = supabase
          .from('users')
          .select()
          .eq('username', username);
      
      if (excludeId != null) {
        query = query.neq('id', excludeId);
      }
      
      final data = await query;
      return data.isNotEmpty;
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }
}