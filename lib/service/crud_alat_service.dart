import 'dart:io';
import 'supabase_service.dart';
import 'supabase_storage_service.dart';

class CrudAlatService {
  static Future<List<Map<String, dynamic>>> getAll() async {
    final res = await SupabaseService.client
        .from('alat')
        .select('id, nama_alat, jumlah_total, kondisi, kategori, gambar');

    final data = res as List;

    return data.map((e) => {
          'id': e['id'],
          'title': e['nama_alat'],
          'stock': e['jumlah_total'],
          'status': e['kondisi'],
          'category': e['kategori'].toString(),
          'image_path':
              e['gambar'] ?? 'assets/images/default.jpg',
        }).toList();
  }

  static Future<void> create({
    required String nama,
    required int jumlah,
    required String kondisi,
    required int kategori,
    File? gambar,
  }) async {
    String? imageUrl;

    if (gambar != null) {
      imageUrl = await SupabaseStorageService.uploadImage(gambar);
    }

    await SupabaseService.client.from('alat').insert({
      'nama_alat': nama.trim(),
      'jumlah_total': jumlah,
      'kondisi': kondisi.trim(),
      'kategori': kategori,
      'gambar': imageUrl,
    });
  }

  static Future<void> update({
    required int id,
    required String nama,
    required int jumlah,
    required String kondisi,
    required int kategori,
    File? gambar,
  }) async {
    String? imageUrl;

    if (gambar != null) {
      imageUrl = await SupabaseStorageService.uploadImage(gambar);
    }

    await SupabaseService.client.from('alat').update({
      'nama_alat': nama.trim(),
      'jumlah_total': jumlah,
      'kondisi': kondisi.trim(),
      'kategori': kategori,
      if (imageUrl != null) 'gambar': imageUrl,
    }).eq('id', id);
  }

  static Future<void> delete(int id) async {
    await SupabaseService.client.from('alat').delete().eq('id', id);
  }
}
