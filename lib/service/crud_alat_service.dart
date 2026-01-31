import 'supabase_service.dart';

class CrudAlatService {
  static final client = SupabaseService.client;

  static Future<List<Map<String, dynamic>>> getAll() async {
    final res = await client
        .from('alat')
        .select('id, nama_alat, jumlah_total, kondisi, kategori, gambar');

    return (res as List<dynamic>).map((e) {
      return {
        'id': e['id'],
        'title': e['nama_alat'],
        'stock': e['jumlah_total'],
        'status': e['kondisi'],
        'category': e['kategori'].toString(),
        'image_path': e['gambar'] ?? 'assets/images/default.jpg',
      };
    }).toList();
  }

  static Future<void> create({
    required String nama,
    required int jumlah,
    required String kondisi,
    required int kategori,
    required String gambar,
  }) async {
    await client.from('alat').insert({
      'nama_alat': nama.trim(),
      'jumlah_total': jumlah,
      'kondisi': kondisi.trim(),
      'kategori': kategori,
      'gambar': gambar.trim().isNotEmpty ? gambar.trim() : null,
    });
  }

  static Future<void> update({
    required int id,
    required String nama,
    required int jumlah,
    required String kondisi,
    required int kategori,
    required String gambar,
  }) async {
    await client.from('alat').update({
      'nama_alat': nama.trim(),
      'jumlah_total': jumlah,
      'kondisi': kondisi.trim(),
      'kategori': kategori,
      'gambar': gambar.trim().isNotEmpty ? gambar.trim() : null,
    }).eq('id', id);
  }

  static Future<void> delete(int id) async {
    await client.from('alat').delete().eq('id', id);
  }
}
