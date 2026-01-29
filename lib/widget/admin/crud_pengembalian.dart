import 'package:flutter/material.dart';
import 'pemberitahuan_sukses.dart'; // pastikan import ini

class CrudPengembalian extends StatelessWidget {
  const CrudPengembalian({super.key});

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> alatControllers = [TextEditingController()];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: StatefulBuilder(
        builder: (context, setState) => Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE7B9A6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'EDIT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _input('Nama'),

                /// Alat Dinamis
                ...List.generate(alatControllers.length, (index) {
                  return _input(
                    'Alat ${index + 1}',
                    suffix: index == alatControllers.length - 1
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                alatControllers.add(TextEditingController());
                              });
                            },
                            child: const Icon(Icons.add),
                          )
                        : null,
                    controller: alatControllers[index],
                  );
                }),

                _input('Tanggal peminjaman'),
                _input('Tanggal kembali'),
                _input('Tanggal pengembalian'),
                _input('kondisi'),
                _input('Denda'),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('batal'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // tutup dialog

                        // Tampilkan pemberitahuan sukses sesuai UI sebelumnya
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const PemberitahuanSukses(
                              message: "Berhasil menyimpan perubahan",
                            ),
                          ),
                        );
                      },
                      child: const Text('selesai'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(String hint,
      {Widget? suffix, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
