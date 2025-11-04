import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// import 'dart:html' as html;

class AdminCategoryPage extends StatefulWidget {
  const AdminCategoryPage({super.key});

  @override
  State<AdminCategoryPage> createState() => _AdminCategoryPageState();
}

class _AdminCategoryPageState extends State<AdminCategoryPage> {
  List<dynamic> categories = [];
  bool isLoading = true;

  final TextEditingController _categoryNameController = TextEditingController();
  int? _editingCategoryId;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> _addCategory(String name, XFile? imageFile) async {
    const String apiUrl =
        "https://dialfirst.in/quantapixel/badhyata/api/add-category";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['category_name'] = name;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = jsonDecode(respStr);

        if (data["status"] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Category added successfully"),
            ),
          );
          fetchCategories(); // Refresh list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Failed: ${data["message"] ?? "Unknown"}"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Server Error: ${response.statusCode}"),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error adding category: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Error: $e"),
        ),
      );
    }
  }

  Future<void> fetchCategories() async {
    const String url =
        "https://dialfirst.in/quantapixel/badhyata/api/getallcategory";

    try {
      final response = await http.get(Uri.parse(url));

      debugPrint("📡 API Response Status: ${response.statusCode}");
      debugPrint("📦 API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1) {
          setState(() {
            categories = data["data"];
            isLoading = false;
          });
          debugPrint("✅ Categories loaded: ${categories.length}");
        } else {
          setState(() => isLoading = false);
          debugPrint("❌ API returned failure status.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Failed to load categories."),
            ),
          );
        }
      } else {
        setState(() => isLoading = false);
        debugPrint("🚫 Server error ${response.statusCode}: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Server error: ${response.statusCode}"),
          ),
        );
      }
    } catch (e, st) {
      debugPrint("🟥 Error fetching categories: $e");
      debugPrintStack(stackTrace: st);
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isWeb = width >= 900;
    final bool isMobile = width < 800;

    return AdminDashboardWrapper(
      child: Column(
        children: [
          AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            automaticallyImplyLeading: !isWeb,
            title: const Text(
              "Manage Categories",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: "Add Category",
                onPressed: () => _showCategoryDialog(),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: fetchCategories,
                tooltip: "Refresh",
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : categories.isEmpty
                    ? const Center(
                        child: Text(
                          "No categories found",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            AppColors.primary.withOpacity(0.9),
                          ),
                          columnSpacing: isMobile ? 20 : 40,
                          dataRowHeight: 80,
                          columns: const [
                            DataColumn(
                              label: Text(
                                "ID",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Image",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Category Name",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Actions",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: categories.map((category) {
                            return DataRow(
                              cells: [
                                DataCell(Text(category['id'].toString())),
                                DataCell(
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: kIsWeb
                                        ? Image.network(
                                            "https://corsproxy.io/?${Uri.encodeComponent(category['image'])}",
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  debugPrint(
                                                    "🟥 Image load error (Web): ${category['image']}",
                                                  );
                                                  debugPrint(
                                                    "🔍 Error details: $error",
                                                  );
                                                  return const Icon(
                                                    Icons.broken_image,
                                                    color: Colors.redAccent,
                                                  );
                                                },
                                          )
                                        : Image.network(
                                            category['image'],
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  debugPrint(
                                                    "🟥 Image load error: ${category['image']}",
                                                  );
                                                  debugPrint(
                                                    "🔍 Error details: $error",
                                                  );
                                                  return const Icon(
                                                    Icons.broken_image,
                                                    color: Colors.redAccent,
                                                  );
                                                },
                                          ),
                                  ),
                                ),

                                DataCell(Text(category['category_name'])),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () => _showCategoryDialog(
                                          editCategory: category,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () =>
                                            _deleteCategory(category['id']),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Category"),
        content: const Text("Are you sure you want to delete this category?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                categories.removeWhere((c) => c['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                   behavior: SnackBarBehavior.floating,
                  content: Text("Category deleted locally.")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog({Map<String, dynamic>? editCategory}) async {
    _editingCategoryId = editCategory?['id'];
    _categoryNameController.text = editCategory?['category_name'] ?? '';
    XFile? _selectedImage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                _editingCategoryId == null ? "Add Category" : "Edit Category",
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _categoryNameController,
                      decoration: const InputDecoration(
                        labelText: "Category Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                        );
                        if (picked != null) {
                          setState(() => _selectedImage = picked);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _selectedImage != null
                            ? Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Text(
                                  "Tap to upload image",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = _categoryNameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                           behavior: SnackBarBehavior.floating,
                          content: Text("Category name cannot be empty."),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(context);
                    await _addCategory(name, _selectedImage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
