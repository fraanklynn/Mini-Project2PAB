import 'package:bank_sampah_digital/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import 'form_page.dart';
import '../controllers/theme_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> dataSetoran = [];
  bool isLoading = true;
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    getDataSetoran();
  }

  Future<void> getDataSetoran() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await supabase
          .from('setoran_sampah')
          .select()
          .order('id', ascending: true);

      setState(() {
        dataSetoran = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  double get totalBerat {
    double total = 0;
    for (var item in dataSetoran) {
      total += item["berat"] ?? 0;
    }
    return total;
  }

  Future<void> tambahSetoran() async {
    final result = await Get.to(() => const FormPage());
    if (result != null) {
      getDataSetoran();
    }
  }

  Future<void> logout() async {
    try {
      await supabase.auth.signOut();

      Get.snackbar(
        "Logout Berhasil",
        "Anda telah keluar dari akun",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );

      Get.offAll(() => const LoginPage());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal Logout",
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
        title: const Row(
          children: [
            Icon(Icons.recycling),
            SizedBox(width: 8),
            Text(
              "Bank Sampah Digital",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: isDark
            ? const LinearGradient(
                colors: [
                  Color(0xFF1B3A2B), 
                  Color(0xFF244D36),
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: const Text(
                      "Yakin ingin keluar dari akun?",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          "Batal",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          Get.back();
                          await logout();
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 22,
            ),
            decoration: BoxDecoration(
              gradient : isDark
              ? LinearGradient(
                colors: [
                  Color(0xFF0F3D1E),
                  Color(0xFF145A32),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
              : LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(
                          Icons.inventory_2,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Total Setoran",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${dataSetoran.length}",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.white30,
                    ),
                    Column(
                      children: [
                        const Icon(
                          Icons.scale,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Total Berat",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${totalBerat.toStringAsFixed(1)} Kg",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : dataSetoran.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8F5E9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.recycling,
                                size: 55,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Belum ada data setoran",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Tekan tombol + untuk menambahkan data baru",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: dataSetoran.length,
                        itemBuilder: (context, index) {
                          final item = dataSetoran[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            color: Theme.of(context).cardColor,
                            elevation: 6,
                            shadowColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? const Color(0xFF2A2A2A)
                                      : const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.recycling,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              title: Text(
                                item["nama"].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  "${item["jenis"]} - ${item["berat"]} Kg",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? const Color(0xFF2A2A2A)
                                          : const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Color(0xFF2E7D32),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Edit Data"),
                                              content: const Text("Yakin ingin mengedit data ini?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text(
                                                    "Batal",
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFF2E7D32),
                                                  ),
                                                  onPressed: () async {
                                                    Get.back();
                                                    final result = await Get.to(
                                                      () => FormPage(initialData: item),
                                                    );
                                                    if (result != null) {
                                                      getDataSetoran();
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Edit",
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red.shade700,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Hapus Data"),
                                              content: const Text(
                                                "Yakin ingin menghapus data ini?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text(
                                                    "Batal",
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      await supabase
                                                          .from(
                                                            'setoran_sampah',
                                                          )
                                                          .delete()
                                                          .eq('id', item['id']);
                                                      Get.back();
                                                      getDataSetoran();
                                                      Get.snackbar(
                                                        'Berhasil',
                                                        'Data berhasil dihapus!',
                                                        snackPosition:
                                                            SnackPosition.BOTTOM,
                                                      );
                                                    } catch (e) {
                                                      Get.back();
                                                      Get.snackbar(
                                                        'Error',
                                                        'Gagal menghapus data: $e',
                                                        snackPosition:
                                                            SnackPosition.BOTTOM,
                                                      );
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Hapus",
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
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
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        onPressed: tambahSetoran,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}