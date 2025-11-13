import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';

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
    debugPrint('[admin] initState -> fetching categories');
    fetchCategories();
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  /// Update category
  Future<void> _updateCategory(int id, String name, XFile? imageFile) async {
    const String apiUrl =
        "https://dialfirst.in/quantapixel/badhyata/api/update-category";

    debugPrint(
      '[_updateCategory] id=$id name="$name" imageFile=${imageFile?.name}',
    );

    try {
      final request = http.MultipartRequest("POST", Uri.parse(apiUrl));
      request.fields['id'] = id.toString();
      request.fields['category_name'] = name;

      if (imageFile != null) {
        if (kIsWeb) {
          debugPrint('[_updateCategory] web upload using bytes');
          final bytes = await imageFile.readAsBytes();
          final fileName = imageFile.name.isNotEmpty
              ? imageFile.name
              : "upload.jpg";
          request.files.add(
            http.MultipartFile.fromBytes('image', bytes, filename: fileName),
          );
        } else {
          debugPrint('[_updateCategory] mobile upload using file path');
          request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.path),
          );
        }
      } else {
        debugPrint('[_updateCategory] no new image, sending only name + id');
      }

      debugPrint(
        '[_updateCategory] sending request with fields=${request.fields} '
        ' files=${request.files.length}',
      );

      final streamed = await request.send();
      final respStr = await streamed.stream.bytesToString();

      debugPrint('[_updateCategory] response status=${streamed.statusCode}');
      debugPrint('[_updateCategory] response body=$respStr');

      if (streamed.statusCode == 200) {
        final data = jsonDecode(respStr);

        if (data["status"] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Category updated successfully"),
            ),
          );

          debugPrint('[_updateCategory] success -> refreshing categories');
          await fetchCategories(); // reload list from server
        } else {
          debugPrint('[_updateCategory] failed: ${data["message"]}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Failed: ${data["message"]}"),
            ),
          );
        }
      } else {
        debugPrint('[_updateCategory] server error ${streamed.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Server Error: ${streamed.statusCode}"),
          ),
        );
      }
    } catch (e, st) {
      debugPrint('[_updateCategory] exception: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Error: $e"),
        ),
      );
    }
  }

  Future<void> _deleteCategory(int id) async {
    debugPrint('[delete] request to delete category id=$id');

    // show confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Category"),
        content: const Text("Are you sure you want to delete this category?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      debugPrint('[delete] cancelled by user for id=$id');
      return;
    }

    // show a small progress indicator dialog while calling API
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      const String url =
          "https://dialfirst.in/quantapixel/badhyata/api/delete-category";
      final body = jsonEncode({'id': id});
      debugPrint('[delete] POST $url body=$body');

      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      // close progress dialog
      Navigator.pop(context);

      debugPrint('[delete] response status=${res.statusCode} body=${res.body}');

      if (res.statusCode == 200) {
        final Map<String, dynamic> j =
            jsonDecode(res.body) as Map<String, dynamic>;
        final status = j['status'];
        final message = j['message'] ?? 'No message';

        if (status == 1 || status == true) {
          // remove from local list
          setState(() {
            categories.removeWhere((c) => c['id'] == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(message.toString()),
            ),
          );
          debugPrint('[delete] success: $message');
          // optionally refresh from server instead of local remove:
          // await fetchCategories();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Failed to delete: $message'),
            ),
          );
          debugPrint('[delete] failed server returned status!=1: $j');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Server error: ${res.statusCode}'),
          ),
        );
        debugPrint('[delete] non-200 status: ${res.statusCode}');
      }
    } catch (e, st) {
      // close progress dialog if still open
      try {
        Navigator.pop(context);
      } catch (_) {}
      debugPrint('[delete] exception: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Error deleting category: $e'),
        ),
      );
    }
  }

  /// Add category (handles both mobile/native and web file upload)
  Future<void> _addCategory(String name, XFile? imageFile) async {
    const String apiUrl =
        "https://dialfirst.in/quantapixel/badhyata/api/add-category";

    debugPrint('[_addCategory] name="$name" imageFile=${imageFile?.name}');
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['category_name'] = name;

      if (imageFile != null) {
        if (kIsWeb) {
          debugPrint('[_addCategory] running on Web - using fromBytes');
          final bytes = await imageFile.readAsBytes();
          // Provide a filename fallback
          final fileName = imageFile.name.isNotEmpty
              ? imageFile.name
              : 'upload.jpg';
          request.files.add(
            http.MultipartFile.fromBytes('image', bytes, filename: fileName),
          );
          debugPrint(
            '[_addCategory] attached ${bytes.length} bytes as $fileName',
          );
        } else {
          debugPrint(
            '[_addCategory] running on native - using fromPath: ${imageFile.path}',
          );
          request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.path),
          );
        }
      } else {
        debugPrint('[_addCategory] no image attached');
      }

      debugPrint(
        '[_addCategory] sending request to $apiUrl with fields=${request.fields} files=${request.files.length}',
      );
      final streamed = await request.send();
      final respStr = await streamed.stream.bytesToString();
      debugPrint(
        '[_addCategory] response status=${streamed.statusCode} body=$respStr',
      );

      if (streamed.statusCode == 201) {
        final data = jsonDecode(respStr);
        if (data["status"] == 1 || data["status"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Category added successfully"),
            ),
          );
          debugPrint('[_addCategory] success -> refreshing categories');
          await fetchCategories();
          return;
        } else {
          debugPrint('[_addCategory] API returned failure: ${data["message"]}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Failed: ${data["message"] ?? "Unknown"}"),
            ),
          );
          return;
        }
      } else {
        debugPrint('[_addCategory] server error ${streamed.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Server Error: ${streamed.statusCode}"),
          ),
        );
      }
    } catch (e, st) {
      debugPrint('[_addCategory] exception: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Error: $e"),
        ),
      );
    }
  }

  /// Fetch categories
  Future<void> fetchCategories() async {
    const String url =
        "https://dialfirst.in/quantapixel/badhyata/api/getallcategory";
    debugPrint('[fetchCategories] GET $url');
    try {
      setState(() => isLoading = true);
      final response = await http.get(Uri.parse(url));
      debugPrint(
        '[fetchCategories] status=${response.statusCode} body=${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == 1 || data["status"] == true) {
          setState(() {
            categories = (data["data"] ?? []) as List<dynamic>;
            isLoading = false;
          });
          debugPrint(
            '[fetchCategories] loaded ${categories.length} categories',
          );
        } else {
          setState(() => isLoading = false);
          debugPrint('[fetchCategories] API returned failure status');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Failed to load categories."),
            ),
          );
        }
      } else {
        setState(() => isLoading = false);
        debugPrint('[fetchCategories] non-200: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Server error: ${response.statusCode}"),
          ),
        );
      }
    } catch (e, st) {
      debugPrint('[fetchCategories] exception: $e');
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

  void _showCategoryDialog({Map<String, dynamic>? editCategory}) async {
    _editingCategoryId = editCategory?['id'];
    _categoryNameController.text = editCategory?['category_name'] ?? '';
    XFile? _selectedImage;

    debugPrint(
      '[dialog] open ${_editingCategoryId == null ? "add" : "edit"} dialog editCategory=$_editingCategoryId',
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Future<void> pickImage() async {
              try {
                final picker = ImagePicker();
                final picked = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                debugPrint(
                  '[dialog] image picked: ${picked?.name ?? "none"} path=${picked?.path}',
                );
                if (picked != null) {
                  setStateDialog(() => _selectedImage = picked);
                }
              } catch (e, st) {
                debugPrint('[dialog] pick image error: $e');
                debugPrintStack(stackTrace: st);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Image pick error: $e')));
              }
            }

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
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _selectedImage != null
                            ? kIsWeb
                                  ? Image.network(
                                      _selectedImage!.path,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(_selectedImage!.path),
                                      fit: BoxFit.cover,
                                    )
                            : Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.cloud_upload,
                                      size: 28,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Tap to upload image',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (editCategory != null &&
                        editCategory['image'] != null &&
                        _selectedImage == null)
                      Column(
                        children: [
                          const SizedBox(height: 6),
                          const Text(
                            'Current image preview',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              editCategory['image'],
                              height: 80,
                              width: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image),
                            ),
                          ),
                        ],
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
                    debugPrint(
                      '[dialog] saving category name="$name" image=${_selectedImage?.name}',
                    );
                    if (_editingCategoryId == null) {
                      debugPrint('[dialog] creating new category');
                      await _addCategory(name, _selectedImage);
                    } else {
                      debugPrint(
                        '[dialog] updating category id=$_editingCategoryId',
                      );
                      await _updateCategory(
                        _editingCategoryId!,
                        name,
                        _selectedImage,
                      );
                    }
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

  // Desktop/wide table layout (clean, full-width inside content area)
  Widget _desktopTable(BuildContext context, double maxWidth) {
    // final double containerWidth = maxWidth.clamp(600.0, 1200.0);
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // color: Colors.white,
          // borderRadius: BorderRadius.circular(12),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.06),
          //     blurRadius: 10,
          //     offset: const Offset(0, 6),
          //   ),
          // ],
        ),
        child: Column(
          children: [
            // header row
            // Container(
            //   // padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            //   decoration: BoxDecoration(
            //     color: AppColors.primary,
            //     borderRadius: const BorderRadius.vertical(
            //       top: Radius.circular(12),
            //     ),
            //   ),
            //   child: Row(
            //     children: const [
            //       Expanded(
            //         flex: 1,
            //         child: Text(
            //           'ID',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: Text(
            //           'Image',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         flex: 5,
            //         child: Text(
            //           'Category Name',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         flex: 2,
            //         child: Text(
            //           'Actions',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // rows
            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: categories.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  final imgUrl = cat['image'] as String?;
                  return InkWell(
                    onTap: () => debugPrint(
                      '[row tap] category id=${cat['id']} name=${cat['category_name']}',
                    ),
                    hoverColor: Colors.grey.shade50,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 22,
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text(cat['id'].toString())),
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 56,
                                width: 56,
                                child: imgUrl == null
                                    ? Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey.shade400,
                                      )
                                    : Image.network(
                                        imgUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                              Icons.broken_image,
                                              // color: Colors.redAccent,
                                            ),
                                      ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              cat['category_name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed: () => _showCategoryDialog(
                                    editCategory: Map<String, dynamic>.from(
                                      cat,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => _deleteCategory(cat['id']),
                                ),
                              ],
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
      ),
    );
  }

  // Mobile/narrow list layout
  Widget _mobileList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final cat = categories[idx];
        final imgUrl = cat['image'] as String?;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ListTile(
            onTap: () => debugPrint('[tile tap] id=${cat['id']}'),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 60,
                width: 60,
                child: imgUrl == null
                    ? const Icon(Icons.image_not_supported)
                    : Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
              ),
            ),
            title: Text(
              cat['category_name'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('ID: ${cat['id']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () => _showCategoryDialog(
                    editCategory: Map<String, dynamic>.from(cat),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _deleteCategory(cat['id']),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminDashboardWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool narrow = constraints.maxWidth < 900;
          return Column(
            children: [
              AppBar(

                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: false,
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
                    tooltip: "Refresh",
                    onPressed: fetchCategories,
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // content area
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      // horizontal: narrow ? 8 : 20,
                      vertical: 18,
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
                        : (narrow
                              ? _mobileList(context)
                              : _desktopTable(context, constraints.maxWidth)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
