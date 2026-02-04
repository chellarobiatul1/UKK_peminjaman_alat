import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../drawer/drawer_admin.dart'; // pastikan path ini sesuai

class KategoriAdmin extends StatefulWidget {
  const KategoriAdmin({super.key});

  @override
  State<KategoriAdmin> createState() => _KategoriAdminState();
}

class _KategoriAdminState extends State<KategoriAdmin> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> kategoriList = [];
  bool isLoading = true;

  static const Color primaryOrange = Color(0xFFF26A2E);

  @override
  void initState() {
    super.initState();
    loadKategori();
  }

  Future<void> loadKategori() async {
    try {
      final data = await supabase
          .from('kategori')
          .select('id, nama_kategori')
          .order('nama_kategori');

      setState(() {
        kategoriList = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Load kategori error: $e');
    }
  }

  Future<void> tambahKategori(String nama) async {
    await supabase.from('kategori').insert({
      'nama_kategori': nama.trim(),
    });
    loadKategori();
    _snack('Kategori ditambahkan');
  }

  Future<void> updateKategori(int id, String nama) async {
    await supabase
        .from('kategori')
        .update({'nama_kategori': nama.trim()})
        .eq('id', id);
    loadKategori();
    _snack('Kategori diperbarui');
  }

  Future<void> hapusKategori(int id) async {
    await supabase.from('kategori').delete().eq('id', id);
    loadKategori();
    _snack('Kategori dihapus');
  }

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ================= FORM =================
  void showForm({int? id, String? namaAwal}) {
    final controller = TextEditingController(text: namaAwal ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: Text(id == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Nama kategori',
            prefixIcon: Icon(Icons.category_outlined, color: primaryOrange),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryOrange),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              if (id == null) {
                await tambahKategori(controller.text);
              } else {
                await updateKategori(id, controller.text);
              }

              if (mounted) Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void konfirmasiHapus(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: const Text('Hapus Kategori'),
        content: const Text(
          'Kategori ini akan dihapus permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              await hapusKategori(id);
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerAdmin(), // ← drawer ditambahkan
      backgroundColor: const Color(0xFFF5F5F5),

      // HEADER mirip peminjaman admin
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            color: const Color(0xFFE9B9A5),
            child: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Kategori Alat',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // LIST KATEGORI
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : kategoriList.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: kategoriList.length,
                        itemBuilder: (context, index) {
                          final kategori = kategoriList[index];
                          final nama = kategori['nama_kategori'];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: primaryOrange.withOpacity(0.15),
                                child: Text(
                                  nama.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: primaryOrange,
                                  ),
                                ),
                              ),
                              title: Text(
                                nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'ID: ${kategori['id']}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    color: primaryOrange,
                                    onPressed: () => showForm(
                                      id: kategori['id'],
                                      namaAwal: nama,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    color: Colors.red[600],
                                    onPressed: () =>
                                        konfirmasiHapus(kategori['id']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryOrange,
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.electrical_services_outlined,
              size: 70, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'Belum ada kategori alat',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
