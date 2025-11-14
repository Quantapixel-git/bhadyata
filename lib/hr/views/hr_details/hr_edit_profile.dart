import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';
// import 'package:jobshub/hr/views/Sidebar_dashboard/hr_side_bar.dart';

class HrEditProfilePage extends StatefulWidget {
  const HrEditProfilePage({super.key});

  @override
  State<HrEditProfilePage> createState() => _HrEditProfilePageState();
}

class _HrEditProfilePageState extends State<HrEditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _firstController = TextEditingController();
  final _lastController = TextEditingController();

  Map<String, dynamic>? _profile; // current profile for prefills
  PlatformFile? _pickedImage; // new file chosen
  bool _removeImage = false; // remove_image=1
  bool _loading = true;
  bool _saving = false;

  // ==== DEBUG HELPERS =======================================================

  void _debugPrintMap(String title, Map<String, dynamic> map) {
    if (!kDebugMode) return;
    debugPrint('— $title —');
    map.forEach((k, v) => debugPrint('  $k: $v'));
  }

  void _debugHttpResponse(
    String label,
    http.Response resp, {
    int bodyMax = 4000,
  }) {
    if (!kDebugMode) return;
    debugPrint('[$label] Status: ${resp.statusCode}');
    debugPrint('[$label] Headers: ${resp.headers}');
    final body = resp.body;
    if (body.length > bodyMax) {
      debugPrint(
        '[$label] Body (${body.length} chars, truncated): ${body.substring(0, bodyMax)}...',
      );
    } else {
      debugPrint('[$label] Body: $body');
    }
  }

  /// Read the streamed response ONCE, log it (in debug), and return the Response.
  Future<http.Response> _streamToResponse(
    String label,
    http.StreamedResponse sResp, {
    int bodyMax = 4000,
  }) async {
    final resp = await http.Response.fromStream(sResp);
    if (kDebugMode) _debugHttpResponse(label, resp, bodyMax: bodyMax);
    return resp;
  }

  void _logError(Object e, StackTrace st, {String where = ''}) {
    if (!kDebugMode) return;
    debugPrint('❌ Error${where.isNotEmpty ? " at $where" : ""}: $e');
    debugPrintStack(stackTrace: st);
  }

  // ==========================================================================

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstController.dispose();
    _lastController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() => _loading = true);
      final userId = await SessionManager.getValue('hr_id');
      if (kDebugMode) debugPrint('➡️ loadProfile for user_id: $userId');

      final url = Uri.parse("${ApiConstants.baseUrl}getProfileById");
      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      _debugHttpResponse('getProfileById', resp);

      if (resp.statusCode == 200) {
        dynamic decoded;
        try {
          decoded = jsonDecode(resp.body);
        } catch (e, st) {
          _logError(e, st, where: 'jsonDecode(getProfileById)');
          _snack("Invalid response from server (not JSON).");
          return;
        }

        if (decoded is Map &&
            decoded['success'] == true &&
            decoded['data'] != null) {
          _profile = Map<String, dynamic>.from(decoded['data'] as Map);
          _firstController.text = (_profile?['first_name'] ?? '').toString();
          _lastController.text = (_profile?['last_name'] ?? '').toString();
          if (kDebugMode) _debugPrintMap('Loaded profile', _profile!);
        } else {
          _snack(
            decoded is Map
                ? (decoded['message'] ?? "Failed to load profile")
                : "Failed to load profile",
          );
        }
      } else {
        _snack("HTTP ${resp.statusCode} while loading profile");
      }
    } catch (e, st) {
      _logError(e, st, where: '_loadProfile');
      _snack("Error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickImage() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // important for web
    );
    if (res != null && res.files.isNotEmpty) {
      final f = res.files.first;
      if (kDebugMode) {
        debugPrint(
          '📸 Picked image: name=${f.name}, size=${f.size}, ext=${f.extension}, hasBytes=${f.bytes != null}',
        );
      }
      setState(() {
        _pickedImage = f;
        _removeImage = false; // user picked a new image, so don't remove
      });
    } else {
      if (kDebugMode) debugPrint('📸 Image picking cancelled');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _saving = true);
      final userId = await SessionManager.getValue('hr_id');
      if (userId == null || userId.toString().isEmpty) {
        _snack("User ID not found. Please log in again.");
        return;
      }

      final url = Uri.parse("${ApiConstants.baseUrl}editUserProfile");
      final req = http.MultipartRequest('POST', url);

      req.fields['user_id'] = userId.toString();

      if (_firstController.text.trim().isNotEmpty) {
        req.fields['first_name'] = _firstController.text.trim();
      }
      if (_lastController.text.trim().isNotEmpty) {
        req.fields['last_name'] = _lastController.text.trim();
      }
      if (_removeImage) {
        req.fields['remove_image'] = '1';
      }
      if (_pickedImage != null && _pickedImage!.bytes != null) {
        req.files.add(
          http.MultipartFile.fromBytes(
            'profile_image',
            _pickedImage!.bytes!,
            filename: _pickedImage!.name,
          ),
        );
      }

      // 🔎 Log outgoing request
      if (kDebugMode) {
        debugPrint('— edit-user-profile REQUEST —');
        _debugPrintMap('fields', req.fields.map((k, v) => MapEntry(k, v)));
        debugPrint(
          'files: ${req.files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes)').join(', ')}',
        );
        debugPrint('url: $url');
      }

      // Send + read ONCE
      final streamed = await req.send();
      final resp = await _streamToResponse('edit-user-profile', streamed);

      dynamic decoded;
      try {
        decoded = jsonDecode(resp.body);
      } catch (e, st) {
        _logError(e, st, where: 'jsonDecode(edit-user-profile)');
        _snack(
          "Server returned non-JSON (HTTP ${resp.statusCode}). See console.",
        );
        return;
      }

      if (resp.statusCode == 200 &&
          decoded is Map &&
          decoded['success'] == true) {
        _snack(decoded['message'] ?? "Profile updated");
        await _loadProfile(); // refresh
        setState(() {
          _pickedImage = null;
          _removeImage = false;
        });
      } else {
        // bubble backend validation errors if present
        String msg = "Failed to update profile (HTTP ${resp.statusCode})";
        if (decoded is Map) {
          if (decoded['message'] != null) msg = decoded['message'].toString();
          if (decoded['errors'] != null && kDebugMode) {
            debugPrint('🧾 Validation errors: ${decoded['errors']}');
          }
        }
        _snack(msg);
      }
    } catch (e, st) {
      _logError(e, st, where: '_save');
      _snack("Error: $e");
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String msg) {
    if (kDebugMode) debugPrint('🔔 Snack: $msg');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;
        return HrDashboardWrapper(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: !isWeb,
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 650),
                            child: _buildFormCard(context),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormCard(BuildContext context) {
    final avatarUrl = _profile?['profile_image_url']?.toString();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar + change/remove actions
              Row(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundImage:
                        _pickedImage != null && _pickedImage!.bytes != null
                        ? MemoryImage(_pickedImage!.bytes!)
                        : (avatarUrl != null &&
                              avatarUrl.isNotEmpty &&
                              !_removeImage)
                        ? NetworkImage(avatarUrl) as ImageProvider
                        : const AssetImage('assets/job_bgr.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.photo_library),
                          label: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              "Change Photo",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            if (kDebugMode)
                              debugPrint('🗑️ Marking photo for removal');
                            setState(() {
                              _pickedImage = null; // discard picked
                              _removeImage = true; // mark for delete
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline),
                          label: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              "Remove Photo",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        if (_pickedImage != null && !_removeImage)
                          Text(
                            _pickedImage!.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Name fields
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _firstController,
                      label: "First Name",
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? "First name is required"
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _lastController,
                      label: "Last Name",
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? "Last name is required"
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (_removeImage)
                const Text(
                  "Photo will be removed",
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              const SizedBox(height: 10),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Text(
                            "Save Changes",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (v) {
        if (kDebugMode) debugPrint('✏️ $label changed -> "$v"');
      },
    );
  }
}
