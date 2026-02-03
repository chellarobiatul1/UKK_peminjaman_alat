import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriService {
  static final _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getKategori() async {
    final data = await _supabase
        .from('kategori')
        .select('id, nama_kategori')
        .order('nama_kategori');

    return List<Map<String, dynamic>>.from(data);
  }
}
