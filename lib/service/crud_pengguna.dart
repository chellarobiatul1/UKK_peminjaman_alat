import 'package:supabase_flutter/supabase_flutter.dart';

class CrudPengguna {
  final SupabaseClient supabase = Supabase.instance.client;

  // 1️⃣ Ambil semua pengguna
  Future<List<Map<String, dynamic>>> getPengguna() async {
    final data = await supabase.from('pengguna').select();
    return List<Map<String, dynamic>>.from(data);
  }

  // 2️⃣ Tambah pengguna
  Future<void> tambahPengguna(Map<String, dynamic> data) async {
    await supabase.from('pengguna').insert(data);
  }

  // 3️⃣ Update pengguna
  Future<void> updatePengguna(int id, Map<String, dynamic> data) async {
    await supabase.from('pengguna').update(data).eq('id', id);
  }

  // 4️⃣ Hapus pengguna
  Future<void> hapusPengguna(int id) async {
    await supabase.from('pengguna').delete().eq('id', id);
  }
}
