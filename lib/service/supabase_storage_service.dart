import 'dart:io';
import 'package:path/path.dart';
import 'supabase_service.dart';

class SupabaseStorageService {
  static const String bucketName = 'alat';

  static Future<String?> uploadImage(File file) async {
    try {
      final fileName =
          'alat_${DateTime.now().millisecondsSinceEpoch}${extension(file.path)}';

      await SupabaseService.client.storage
          .from(bucketName)
          .upload(fileName, file);

      final publicUrl = SupabaseService.client.storage
          .from(bucketName)
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      print('Upload image error: $e');
      return null;
    }
  }
}
