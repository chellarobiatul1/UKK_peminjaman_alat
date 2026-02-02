import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:path/path.dart' as p; // rename jadi p biar gampang
import 'package:flutter/foundation.dart' show debugPrint;

class CrudAlatService {
  static const String bucketName = 'alat';

  // GET ALL (sudah OK, tapi sesuaikan image_path kalau perlu public URL)
  static Future<List<Map<String, dynamic>>> getAll() async {
    final res = await Supabase.instance.client
        .from('alat')
        .select('id, nama_alat, jumlah_total, kondisi, kategori, gambar');

    return res.map((e) {
      final path = e['gambar'] as String?;
      final imageUrl = path != null && path.isNotEmpty
          ? Supabase.instance.client.storage.from(bucketName).getPublicUrl(path)
          : 'assets/images/default.jpg';

      return {
        'id': e['id'],
        'title': e['nama_alat'],
        'stock': e['jumlah_total'],
        'status': e['kondisi'],
        'category': e['kategori']?.toString() ?? '',
        'image_path': imageUrl,  // sekarang pakai full public URL
      };
    }).toList();
  }

  static Future<void> create({
    required String nama,
    required int jumlah,
    required String kondisi,
    required int kategori,
    Uint8List? imageBytes,
    String? fileName,
  }) async {
    String? uploadedPath;

    if (imageBytes != null && fileName != null && fileName.trim().isNotEmpty) {
      final ext = p.extension(fileName).replaceAll('.', '').toLowerCase();
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      uploadedPath = 'alat-images/$uniqueFileName'; // folder biar rapi

      try {
        await Supabase.instance.client.storage.from(bucketName).uploadBinary(
              uploadedPath,
              imageBytes,
              fileOptions: FileOptions(
                cacheControl: '3600',
                upsert: false,
                contentType: ext.isNotEmpty ? 'image/$ext' : 'image/jpeg',
              ),
            );
      } catch (e) {
        debugPrint('Upload gambar gagal (create): $e');
        rethrow; // biar error bisa ditangkap di widget
      }
    }

    await Supabase.instance.client.from('alat').insert({
      'nama_alat': nama.trim(),
      'jumlah_total': jumlah,
      'kondisi': kondisi.trim(),
      'kategori': kategori,
      'gambar': uploadedPath,
    });
  }

  static Future<void> update({
    required int id,
    required String nama,
    required int jumlah,
    required String kondisi,
    required int kategori,
    Uint8List? imageBytes,
    String? fileName,
    String? oldImagePath,
  }) async {
    String? newPath = oldImagePath;

    if (imageBytes != null && fileName != null && fileName.trim().isNotEmpty) {
      // Hapus gambar lama kalau ada dan diganti
      if (oldImagePath != null && oldImagePath.isNotEmpty) {
        try {
          await Supabase.instance.client.storage.from(bucketName).remove([oldImagePath]);
        } catch (e) {
          debugPrint('Gagal hapus gambar lama: $e');
          // lanjut aja, tidak fatal
        }
      }

      final ext = p.extension(fileName).replaceAll('.', '').toLowerCase();
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      newPath = 'alat-images/$uniqueFileName';

      try {
        await Supabase.instance.client.storage.from(bucketName).uploadBinary(
              newPath,
              imageBytes,
              fileOptions: FileOptions(
                cacheControl: '3600',
                upsert: true,
                contentType: ext.isNotEmpty ? 'image/$ext' : 'image/jpeg',
              ),
            );
      } catch (e) {
        debugPrint('Upload gambar baru gagal (update): $e');
        rethrow;
      }
    }

    await Supabase.instance.client.from('alat').update({
      'nama_alat': nama.trim(),
      'jumlah_total': jumlah,
      'kondisi': kondisi.trim(),
      'kategori': kategori,
      'gambar': newPath,
    }).eq('id', id);
  }

  static Future<void> delete(int id, {String? imagePath}) async {
    if (imagePath != null && imagePath.isNotEmpty) {
      try {
        await Supabase.instance.client.storage.from(bucketName).remove([imagePath]);
      } catch (e) {
        debugPrint('Gagal hapus gambar di storage: $e');
      }
    }

    await Supabase.instance.client.from('alat').delete().eq('id', id);
  }
}