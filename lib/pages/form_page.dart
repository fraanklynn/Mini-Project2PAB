import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../main.dart';

class FormPage extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const FormPage({super.key, this.initialData});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController namaC = TextEditingController();
  final TextEditingController beratC = TextEditingController();
  String? selectedJenis;
  final ThemeController themeController = Get.find<ThemeController>();

  final List<String> jenisSampah = [
    "Plastik",
    "Kertas",
    "Logam",
    "Kaca",
    "Kaleng",
    "Minyak Jelantah",
    "Kardus"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      namaC.text = widget.initialData!["nama"].toString();
      beratC.text = widget.initialData!["berat"].toString();
      selectedJenis = widget.initialData!["jenis"];
    }
  }

  @override
  void dispose() {
    namaC.dispose();
    beratC.dispose();
    super.dispose();
  }

  void simpan() async {
    final nama = namaC.text.trim();
    final jenis = selectedJenis;
    final berat = double.tryParse(beratC.text.trim());

    if (nama.isEmpty || jenis == null || berat == null || berat <= 0) {
      Get.snackbar(
        "Error",
        "Harap isi semua data dengan benar!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      if (widget.initialData != null) {
        await supabase.from('setoran_sampah').update({
          'nama': nama,
          'jenis': jenis,
          'berat': berat,
        }).eq('id', widget.initialData!['id']);
      } else {
        await supabase.from('setoran_sampah').insert({
          'nama': nama,
          'jenis': jenis,
          'berat': berat,
        });
      }
      Get.back(result: true);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menyimpan data: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF1F8F4),
      appBar: AppBar(
        title: const Text(
          "Tambah / Edit Setoran",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                themeController.toggleTheme();
              },
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    colors: [
                      Color(0xFF0F3D1E),
                      Color(0xFF145A32),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [
                      Color(0xFF2E7D32),
                      Color(0xFF66BB6A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 12),
            TextField(
              controller: namaC,
              decoration: InputDecoration(
                labelText: "Nama",
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black54,
                  width: 1.5
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFB7CBBE),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF2E7D32),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: selectedJenis,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              decoration: InputDecoration(
                labelText: "Jenis Sampah",
                prefixIcon: const Icon(Icons.delete_outline),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black54,
                  width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFB7CBBE),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF2E7D32),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              items: jenisSampah.map((jenis) {
                return DropdownMenuItem<String>(
                  value: jenis,
                  child: Text(
                    jenis,
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedJenis = value;
                });
              },
            ),
            const SizedBox(height: 18),
            TextField(
              controller: beratC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Berat (Kg)",
                hintText: "Contoh 1.5 ",
                prefixIcon: const Icon(Icons.scale_outlined),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black54,
                  width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFB7CBBE),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF2E7D32),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.save_outlined),
                    SizedBox(width: 8),
                    Text(
                      "Simpan Data",
                      style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}