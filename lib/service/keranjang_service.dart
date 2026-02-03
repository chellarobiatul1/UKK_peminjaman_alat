class KeranjangService {
  static final List<Map<String, dynamic>> _keranjang = [];

  /// Ambil semua isi keranjang
  static List<Map<String, dynamic>> getKeranjang() {
    return _keranjang;
  }

  /// Tambah alat ke keranjang
  static void tambahAlat(Map<String, dynamic> alat) {
    final index =
        _keranjang.indexWhere((item) => item['id'] == alat['id']);

    if (index != -1) {
      _keranjang[index]['count']++;
    } else {
      _keranjang.add({
        'id': alat['id'],
        'title': alat['title'],
        'image': alat['image'],
        'count': 1,
      });
    }
  }

  /// Tambah jumlah
  static void tambahJumlah(int index) {
    _keranjang[index]['count']++;
  }

  /// Kurangi jumlah
  static void kurangJumlah(int index) {
    if (_keranjang[index]['count'] > 1) {
      _keranjang[index]['count']--;
    }
  }

  /// Hapus alat
  static void hapusAlat(int index) {
    _keranjang.removeAt(index);
  }

  /// Total semua alat
  static int totalAlat() {
    return _keranjang.fold(
      0,
      (sum, item) => sum + (item['count'] as int),
    );
  }

  /// Bersihkan keranjang
  static void clear() {
    _keranjang.clear();
  }
}
