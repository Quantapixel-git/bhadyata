import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/app_color.dart';

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

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
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
            const SnackBar(content: Text("Failed to load categories.")),
          );
        }
      } else {
        setState(() => isLoading = false);
        debugPrint('[fetchCategories] non-200: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error: ${response.statusCode}")),
        );
      }
    } catch (e, st) {
      debugPrint('[fetchCategories] exception: $e');
      debugPrintStack(stackTrace: st);
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  /// Add category
  Future<void> _addCategory(String name, XFile? imageFile) async {
    const String apiUrl =
        "https://dialfirst.in/quantapixel/badhyata/api/add-category";
    debugPrint('[_addCategory] name="$name" imageFile=${imageFile?.name}');
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['category_name'] = name;

      if (imageFile != null) {
        if (kIsWeb) {
          final bytes = await imageFile.readAsBytes();
          final fileName = imageFile.name.isNotEmpty
              ? imageFile.name
              : 'upload.jpg';
          request.files.add(
            http.MultipartFile.fromBytes('image', bytes, filename: fileName),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.path),
          );
        }
      }

      debugPrint(
        '[_addCategory] sending request fields=${request.fields} files=${request.files.length}',
      );
      final streamed = await request.send();
      final respStr = await streamed.stream.bytesToString();
      debugPrint('[_addCategory] status=${streamed.statusCode} body=$respStr');

      if (streamed.statusCode == 201 || streamed.statusCode == 200) {
        final data = jsonDecode(respStr);
        if (data["status"] == 1 || data["status"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Category added successfully")),
          );
          await fetchCategories();
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: ${data["message"] ?? "Unknown"}")),
          );
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error: ${streamed.statusCode}")),
        );
      }
    } catch (e, st) {
      debugPrint('[_addCategory] exception: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
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
          final bytes = await imageFile.readAsBytes();
          final fileName = imageFile.name.isNotEmpty
              ? imageFile.name
              : "upload.jpg";
          request.files.add(
            http.MultipartFile.fromBytes('image', bytes, filename: fileName),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.path),
          );
        }
      }

      debugPrint(
        '[_updateCategory] sending request fields=${request.fields} files=${request.files.length}',
      );
      final streamed = await request.send();
      final respStr = await streamed.stream.bytesToString();
      debugPrint(
        '[_updateCategory] status=${streamed.statusCode} body=$respStr',
      );

      if (streamed.statusCode == 200) {
        final data = jsonDecode(respStr);
        if (data["status"] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Category updated successfully")),
          );
          await fetchCategories();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed: ${data["message"]}")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error: ${streamed.statusCode}")),
        );
      }
    } catch (e, st) {
      debugPrint('[_updateCategory] exception: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  /// Delete category
  Future<void> _deleteCategory(int id) async {
    debugPrint('[delete] request to delete category id=$id');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      const String url =
          "https://dialfirst.in/quantapixel/badhyata/api/delete-category";
      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'id': id}),
      );

      Navigator.pop(context); // close progress

      debugPrint('[delete] status=${res.statusCode} body=${res.body}');
      if (res.statusCode == 200) {
        final Map<String, dynamic> j =
            jsonDecode(res.body) as Map<String, dynamic>;
        final status = j['status'];
        final message = j['message'] ?? 'No message';
        if (status == 1 || status == true) {
          setState(() => categories.removeWhere((c) => c['id'] == id));
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message.toString())));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete: $message')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${res.statusCode}')),
        );
      }
    } catch (e, st) {
      try {
        Navigator.pop(context);
      } catch (_) {}
      debugPrint('[delete] exception: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting category: $e')));
    }
  }

  /// Open add/edit dialog similar to banner dialog
  void _openAddEditDialog({Map<String, dynamic>? editCategory}) {
    _editingCategoryId = editCategory?['id'];
    _categoryNameController.text = editCategory?['category_name'] ?? '';
    XFile? _selectedImage;

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
                if (picked != null)
                  setStateDialog(() => _selectedImage = picked);
              } catch (e, st) {
                debugPrint('pickImage error: $e');
                debugPrintStack(stackTrace: st);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Image pick error: $e')));
              }
            }

            return AlertDialog(
              title: Text(
                _editingCategoryId == null ? 'Add Category' : 'Edit Category',
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
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _selectedImage != null
                            ? (kIsWeb
                                  ? Image.network(
                                      _selectedImage!.path,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => const Center(
                                        child: Icon(Icons.broken_image),
                                      ),
                                    )
                                  : Image.file(
                                      File(_selectedImage!.path),
                                      fit: BoxFit.cover,
                                    ))
                            : (editCategory != null &&
                                  editCategory['image'] != null)
                            ? Image.network(
                                editCategory['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.broken_image,
                                            size: 36,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Image not available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = _categoryNameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Category name cannot be empty."),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    if (_editingCategoryId == null) {
                      await _addCategory(name, _selectedImage);
                    } else {
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
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Desktop list view (banner-like)
  Widget _desktopList() {
    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, i) {
        final cat = categories[i];
        final imgUrl = cat['image'] as String?;
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imgUrl == null
                ? Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade100,
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey.shade400,
                    ),
                  )
                : Image.network(
                    imgUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
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
                onPressed: () => _openAddEditDialog(
                  editCategory: Map<String, dynamic>.from(cat),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _confirmDelete(cat['id']),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Mobile list (card style)
  Widget _mobileList() {
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
                  onPressed: () => _openAddEditDialog(
                    editCategory: Map<String, dynamic>.from(cat),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(cat['id']),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) await _deleteCategory(id);
  }

  @override
  Widget build(BuildContext context) {
    return AdminDashboardWrapper(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Manage Categories',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                onPressed: () => _openAddEditDialog(),
                icon: const Icon(Icons.add, color: Colors.white),
              ),
              IconButton(
                onPressed: fetchCategories,
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              width: double.infinity,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : categories.isEmpty
                  ? const Center(child: Text('No categories found'))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final narrow = constraints.maxWidth < 900;
                        return narrow ? _mobileList() : _desktopList();
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
