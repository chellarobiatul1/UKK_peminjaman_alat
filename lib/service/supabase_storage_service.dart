import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'supabase_service.dart';
import 'dart:io' as io;

class SupabaseStorageService {
  static const String bucketName = 'alat';

  /// 🔹 Upload untuk WEB (bytes)
  static Future<String?> uploadImageWeb(
    Uint8List bytes,
    String originalName,
  ) async {
    try {
      final fileName =
          'alat_${DateTime.now().millisecondsSinceEpoch}${extension(originalName)}';

      await SupabaseService.client.storage
          .from(bucketName)
          .uploadBinary(fileName, bytes);

      return SupabaseService.client.storage
          .from(bucketName)
          .getPublicUrl(fileName);
    } catch (e) {
      print('Upload WEB error: $e');
      return null;
    }
  }

  /// 🔹 Upload untuk MOBILE / DESKTOP
  static Future<String?> uploadImage(io.File file) async {
    try {
      final fileName =
          'alat_${DateTime.now().millisecondsSinceEpoch}${extension(file.path)}';

      await SupabaseService.client.storage
          .from(bucketName)
          .upload(fileName, file);

      return SupabaseService.client.storage
          .from(bucketName)
          .getPublicUrl(fileName);
    } catch (e) {
      print('Upload FILE error: $e');
      return null;
    }
  }
}
