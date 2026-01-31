import 'package:flutter/material.dart';

class EditPeminjamanDialog extends StatefulWidget {
  final Map<String, String> item;
  final Function(Map<String, String>) onSave;

  const EditPeminjamanDialog({
    super.key,
    required this.item,
    required this.onSave,
  });

  @override
  State<EditPeminjamanDialog> createState() => _EditPeminjamanDialogState();
}

class _EditPeminjamanDialogState extends State<EditPeminjamanDialog> {
  late TextEditingController namaController;
  late List<TextEditingController> alatControllers;
  late TextEditingController tanggalPinjamController;
  late TextEditingController tanggalKembaliController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.item["nama"]);
    alatControllers = widget.item["alat"]!
        .split(", ")
        .map((e) => TextEditingController(text: e))
        .toList();
    tanggalPinjamController =
        TextEditingController(text: widget.item["tanggal peminjaman"]);
    tanggalKembaliController =
        TextEditingController(text: widget.item["tanggal kembali"]);
  }

  Future<void> _pickDate(TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    try {
      final parts = controller.text.split(" - ");
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = _monthIndex(parts[1]);
        int year = int.parse(parts[2]);
        initialDate = DateTime(year, month, day);
      }
    } catch (_) {}
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text =
          "${picked.day.toString().padLeft(2, '0')} - ${_monthName(picked.month)} - ${picked.year}";
      setState(() {});
    }
  }

  String _monthName(int month) {
    const months = [
      "", "Januari","Februari","Maret","April","Mei","Juni","Juli",
      "Agustus","September","Oktober","November","Desember"
    ];
    return months[month];
  }

  int _monthIndex(String name) {
    const months = [
      "", "Januari","Februari","Maret","April","Mei","Juni","Juli",
      "Agustus","September","Oktober","November","Desember"
    ];
    return months.indexOf(name);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE9B9A5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Peminjaman",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  hintText: "Nama Peminjam",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Column(
                children: List.generate(alatControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: alatControllers[index],
                            decoration: InputDecoration(
                              hintText: "Alat ${index + 1}",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        if (index == alatControllers.length - 1)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                alatControllers.add(TextEditingController());
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                      ],
                    ),
                  );
                }),
              ),

              GestureDetector(
                onTap: () => _pickDate(tanggalPinjamController),
                child: TextField(
                  controller: tanggalPinjamController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Tanggal Peminjaman",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _pickDate(tanggalKembaliController),
                child: TextField(
                  controller: tanggalKembaliController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Tanggal Kembali",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      child: const Text("Batal"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onSave({
                          "nama": namaController.text,
                          "alat": alatControllers.map((e) => e.text).join(", "),
                          "tanggal peminjaman": tanggalPinjamController.text,
                          "tanggal kembali": tanggalKembaliController.text,
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
