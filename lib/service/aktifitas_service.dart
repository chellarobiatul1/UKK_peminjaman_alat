class AktifitasService {
  static final List<Map<String, dynamic>> _aktifitas = [];

  static void tambahAktifitas({
    required String nama,
    required String user,
    required String tanggalPinjam,
    required String tanggalKembali,
    required List<Map<String, dynamic>> alatList,
  }) {
    _aktifitas.add({
      'nama': nama,
      'user': user,
      'tanggalPinjam': tanggalPinjam,
      'tanggalKembali': tanggalKembali,
      'alatList': alatList,
    });
  }

  static List<Map<String, dynamic>> getAktifitas() {
    return _aktifitas;
  }
}
