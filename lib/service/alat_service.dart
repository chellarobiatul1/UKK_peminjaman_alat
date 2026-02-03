import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart' show debugPrint;

class CrudAlatService {
  static const String bucketName = 'alat';

  // GET ALL
  static Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final res = await Supabase.instance.client
          .from('alat')
          .select('id, nama_alat, jumlah_total, kondisi, kategori, gambar');

      return res.map((e) {
        final path = e['gambar'] as String?;
        String imageUrl = 'assets/images/default.jpg';
        
        if (path != null && path.isNotEmpty) {
          try {
            imageUrl = Supabase.instance.client.storage
                .from(bucketName)
                .getPublicUrl(path);
          } catch (e) {
            debugPrint('Error getting public URL: $e');
          }
        }

        return {
          'id': e['id'],
          'title': e['nama_alat'] ?? '',
          'stock': e['jumlah_total'] ?? 0,
          'status': e['kondisi'] ?? '',
          'category': e['kategori']?.toString() ?? '',
          'image_path': imageUrl,
          'image_storage': path, // Path asli untuk delete
        };
      }).toList();
    } catch (e) {
      debugPrint('Error getting all alat: $e');
      return [];
    }
  }

  // CREATE
  static Future<void> create({
    required String nama,
    required int jumlah,
    required String kondisi,
    required int kategori,
    Uint8List? imageBytes,
    String? fileName,
  }) async {
    String? uploadedPath;

    // Upload image jika ada
    if (imageBytes != null && fileName != null && fileName.trim().isNotEmpty) {
      try {
        final ext = p.extension(fileName).replaceAll('.', '').toLowerCase();
        if (ext.isEmpty) {
          throw Exception('File extension tidak valid');
        }

        final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_${nama.replaceAll(' ', '_')}.$ext';
        uploadedPath = uniqueFileName; // Simpan di root bucket

        debugPrint('Uploading to: $uploadedPath');

        await Supabase.instance.client.storage
            .from(bucketName)
            .uploadBinary(
              uploadedPath,
              imageBytes,
              fileOptions: FileOptions(
                cacheControl: '3600',
                upsert: false,
                contentType: _getContentType(ext),
              ),
            );

        debugPrint('Upload berhasil: $uploadedPath');
      } catch (e) {
        debugPrint('Upload gambar gagal (create): $e');
        // Jangan rethrow, lanjutkan tanpa gambar
        uploadedPath = null;
      }
    }

    // Insert ke database
    try {
      await Supabase.instance.client.from('alat').insert({
        'nama_alat': nama.trim(),
        'jumlah_total': jumlah,
        'kondisi': kondisi.trim(),
        'kategori': kategori,
        'gambar': uploadedPath,
      });
      debugPrint('Data berhasil disimpan');
    } catch (e) {
      debugPrint('Error insert alat: $e');
      // Jika insert gagal dan gambar sudah diupload, hapus gambar
      if (uploadedPath != null) {
        try {
          await Supabase.instance.client.storage
              .from(bucketName)
              .remove([uploadedPath]);
        } catch (deleteError) {
          debugPrint('Error deleting orphaned image: $deleteError');
        }
      }
      rethrow;
    }
  }

  // UPDATE
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

    // Upload gambar baru jika ada
    if (imageBytes != null && fileName != null && fileName.trim().isNotEmpty) {
      try {
        final ext = p.extension(fileName).replaceAll('.', '').toLowerCase();
        if (ext.isEmpty) {
          throw Exception('File extension tidak valid');
        }

        final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_${nama.replaceAll(' ', '_')}.$ext';
        newPath = uniqueFileName;

        debugPrint('Uploading new image to: $newPath');

        await Supabase.instance.client.storage
            .from(bucketName)
            .uploadBinary(
              newPath,
              imageBytes,
              fileOptions: FileOptions(
                cacheControl: '3600',
                upsert: true,
                contentType: _getContentType(ext),
              ),
            );

        debugPrint('Upload berhasil: $newPath');

        // Hapus gambar lama setelah upload baru berhasil
        if (oldImagePath != null && oldImagePath.isNotEmpty && oldImagePath != newPath) {
          try {
            await Supabase.instance.client.storage
                .from(bucketName)
                .remove([oldImagePath]);
            debugPrint('Gambar lama berhasil dihapus: $oldImagePath');
          } catch (e) {
            debugPrint('Gagal hapus gambar lama: $e');
            // Tidak fatal, lanjutkan
          }
        }
      } catch (e) {
        debugPrint('Upload gambar baru gagal (update): $e');
        // Tetap gunakan path lama jika upload gagal
        newPath = oldImagePath;
      }
    }

    // Update database
    try {
      await Supabase.instance.client.from('alat').update({
        'nama_alat': nama.trim(),
        'jumlah_total': jumlah,
        'kondisi': kondisi.trim(),
        'kategori': kategori,
        'gambar': newPath,
      }).eq('id', id);
      
      debugPrint('Data berhasil diupdate');
    } catch (e) {
      debugPrint('Error update alat: $e');
      rethrow;
    }
  }

  // DELETE
  static Future<void> delete(int id, {String? imagePath}) async {
    // Hapus dari database dulu
    try {
      await Supabase.instance.client.from('alat').delete().eq('id', id);
      debugPrint('Data berhasil dihapus dari database');
    } catch (e) {
      debugPrint('Error delete alat: $e');
      rethrow;
    }

    // Hapus gambar setelah data berhasil dihapus
    if (imagePath != null && imagePath.isNotEmpty) {
      try {
        await Supabase.instance.client.storage
            .from(bucketName)
            .remove([imagePath]);
        debugPrint('Gambar berhasil dihapus: $imagePath');
      } catch (e) {
        debugPrint('Gagal hapus gambar di storage: $e');
        // Tidak fatal, sudah terhapus dari database
      }
    }
  }

  // Helper untuk content type
  static String _getContentType(String ext) {
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}