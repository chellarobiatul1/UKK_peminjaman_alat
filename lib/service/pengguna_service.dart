import 'package:supabase_flutter/supabase_flutter.dart';

class PenggunaService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getUsers() async {
    final data = await supabase.from('users').select();
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> tambahPengguna(Map<String, dynamic> data) async {
    await supabase.from('users').insert(data);
  }

  Future<void> updatePengguna(int id, Map<String, dynamic> data) async {
    await supabase.from('users').update(data).eq('id', id);
  }

  Future<void> hapusPengguna(int id) async {
    await supabase.from('users').delete().eq('id', id);
  }
}
