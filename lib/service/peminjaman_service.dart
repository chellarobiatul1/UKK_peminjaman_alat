import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamanService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<void> ajukanPeminjaman({
    required int userId,
    required String tanggalPinjam,
    required String tanggalKembali,
    required List<Map<String, dynamic>> alatList,
  }) async {
    try {
      // 1️⃣ Simpan detail_peminjaman, ambil semua ID
      List<int> detailIds = [];

      for (var alat in alatList) {
        final res = await _supabase
            .from('detail_peminjaman')
            .insert({
              'alat': alat['id'], // id alat dari tabel alat
              'jumlah': alat['count'], 
              'tanggal_kembali_rencana': tanggalKembali,
            })
            .select('id')  // Ambil id detail_peminjaman yang baru saja disimpan
            .single();

        detailIds.add(res['id'] as int);
      }

      print('Detail IDs: $detailIds'); // debug: pastikan List<int>

      // 2️⃣ Simpan peminjaman utama dengan status 'pending'
      final resPeminjaman = await _supabase.from('peminjaman').insert({
        'user_id': userId,
        'tanggal_pinjam': tanggalPinjam,
        'tanggal_kembali': tanggalKembali,
        'status_peminjaman': 'pending', // status awal adalah 'pending'
        'detail_peminjaman': detailIds, // List<int> → array di Supabase
      }).select().single();

      print('Peminjaman Berhasil Disimpan: ${resPeminjaman['id']}');

    } catch (e) {
      print('Error saat ajukan peminjaman: $e');
      throw 'Gagal menyimpan peminjaman: $e';
    }
  }
}
