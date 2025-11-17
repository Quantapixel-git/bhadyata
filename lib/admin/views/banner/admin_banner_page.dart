import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/app_color.dart';

class AdminBannerPage extends StatefulWidget {
  const AdminBannerPage({super.key});

  @override
  State<AdminBannerPage> createState() => _AdminBannerPageState();
}

class _AdminBannerPageState extends State<AdminBannerPage> {
  List<dynamic> banners = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    const String url =
        "https://dialfirst.in/quantapixel/badhyata/api/getBanner";
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data["status"] == 1) {
          setState(() {
            banners = (data["data"] ?? []) as List<dynamic>;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load banners: ${data["message"] ?? ""}'),
            ),
          );
        }
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${res.statusCode}')),
        );
      }
    } catch (e, st) {
      setState(() => isLoading = false);
      debugPrint('fetchBanners exception: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _addBanner(XFile? imageFile) async {
    const String apiUrl =
        "https://dialfirst.in/quantapixel/badhyata/api/addBanner";
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      if (imageFile != null) {
        if (kIsWeb) {
          final bytes = await imageFile.readAsBytes();
          final fileName = imageFile.name.isNotEmpty
              ? imageFile.name
              : 'banner.jpg';
          request.files.add(
            http.MultipartFile.fromBytes('image', bytes, filename: fileName),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.path),
          );
        }
      }

      final streamed = await request.send();
      final respStr = await streamed.stream.bytesToString();
      if (streamed.statusCode == 201 || streamed.statusCode == 200) {
        final data = jsonDecode(respStr);
        if (data['status'] == 1) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Banner added')));
          await fetchBanners();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed: ${data["message"]}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${streamed.statusCode}')),
        );
      }
    } catch (e, st) {
      debugPrint('addBanner exception: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _updateBanner(int id, XFile? imageFile) async {
    const String apiUrl =
        "https://dialfirst.in/quantapixel/badhyata/api/updateBanner";
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['id'] = id.toString();

      if (imageFile != null) {
        if (kIsWeb) {
          final bytes = await imageFile.readAsBytes();
          final fileName = imageFile.name.isNotEmpty
              ? imageFile.name
              : 'banner.jpg';
          request.files.add(
            http.MultipartFile.fromBytes('image', bytes, filename: fileName),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.path),
          );
        }
      }

      final streamed = await request.send();
      final respStr = await streamed.stream.bytesToString();
      if (streamed.statusCode == 200) {
        final data = jsonDecode(respStr);
        if (data['status'] == 1) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Banner updated')));
          await fetchBanners();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed: ${data["message"]}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${streamed.statusCode}')),
        );
      }
    } catch (e, st) {
      debugPrint('updateBanner exception: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteBanner(int id) async {
    const String url =
        "https://dialfirst.in/quantapixel/badhyata/api/deleteBanner";
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'id': id}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == 1) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Banner deleted')));
          setState(() => banners.removeWhere((b) => b['id'] == id));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed: ${data["message"]}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${res.statusCode}')),
        );
      }
    } catch (e, st) {
      debugPrint('deleteBanner exception: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _openAddEditDialog({Map<String, dynamic>? banner}) {
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
              title: Text(banner == null ? 'Add Banner' : 'Edit Banner'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                                  )
                                : Image.file(
                                    File(_selectedImage!.path),
                                    fit: BoxFit.cover,
                                  ))
                          : (banner != null && banner['image'] != null)
                          ? Image.network(
                              banner['image'],
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
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.cloud_upload),
                                  SizedBox(height: 8),
                                  Text('Tap to upload image'),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (banner == null) {
                      await _addBanner(_selectedImage);
                    } else {
                      await _updateBanner(banner['id'], _selectedImage);
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

  Widget _desktopList() {
    return ListView.separated(
      itemCount: banners.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, i) {
        final b = banners[i];
        final img = b['image'] as String?;
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: img == null
                ? const Icon(Icons.image)
                : Image.network(
                    img,
                    width: 80,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 56,
                      alignment: Alignment.center,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
          ),

          title: Text('Banner #${b['id']}'),
          subtitle: Text('Status: ${b['status'] ?? ""}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () =>
                    _openAddEditDialog(banner: Map<String, dynamic>.from(b)),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _deleteConfirm(b['id']),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteConfirm(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete Banner'),
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
    if (ok == true) await _deleteBanner(id);
  }

  @override
  Widget build(BuildContext context) {
    return AdminDashboardWrapper(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Manage Banners',
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
                onPressed: fetchBanners,
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : banners.isEmpty
                  ? const Center(child: Text('No banners found'))
                  : _desktopList(),
            ),
          ),
        ],
      ),
    );
  }
}
