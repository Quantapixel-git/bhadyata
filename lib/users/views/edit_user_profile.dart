import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

import 'package:jobshub/common/constants/constants.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/user_sidedrawer.dart';

class UserEditProfilePage extends StatefulWidget {
  const UserEditProfilePage({super.key});

  @override
  State<UserEditProfilePage> createState() => _UserEditProfilePageState();
}

class _UserEditProfilePageState extends State<UserEditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _firstController = TextEditingController();
  final _lastController = TextEditingController();

  Map<String, dynamic>? _profile; // server payload for prefills
  PlatformFile? _pickedImage; // newly chosen image file (web/mobile bytes)
  bool _removeImage = false; // send remove_image=1
  bool _loading = true;
  bool _saving = false;

  // =================== DEBUG HELPERS ===================
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

  Future<http.Response> _streamToResponse(
    String label,
    http.StreamedResponse sResp, {
    int bodyMax = 4000,
  }) async {
    final resp = await http.Response.fromStream(sResp);
    _debugHttpResponse(label, resp, bodyMax: bodyMax);
    return resp;
  }

  void _logError(Object e, StackTrace st, {String where = ''}) {
    if (!kDebugMode) return;
    debugPrint('❌ Error${where.isNotEmpty ? " at $where" : ""}: $e');
    debugPrintStack(stackTrace: st);
  }
  // =====================================================

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

      final userId = await SessionManager.getValue('user_id');
      if (kDebugMode) debugPrint('➡️ loadProfile for user_id: $userId');

      if (userId == null || userId.toString().isEmpty) {
        _snack("User ID not found. Please log in again.");
        return;
      }

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

          // These keys should exist per your existing employer screen usage
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
      withData: true, // important for web bytes
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
        _removeImage = false; // new image, don't remove
      });
    } else {
      if (kDebugMode) debugPrint('📸 Image picking cancelled');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _saving = true);

      final userId = await SessionManager.getValue('user_id');
      if (userId == null || userId.toString().isEmpty) {
        _snack("User ID not found. Please log in again.");
        return;
      }

      final url = Uri.parse("${ApiConstants.baseUrl}editUserProfile");
      final req = http.MultipartRequest('POST', url);

      req.fields['user_id'] = userId.toString();

      final first = _firstController.text.trim();
      final last = _lastController.text.trim();

      if (first.isNotEmpty) req.fields['first_name'] = first;
      if (last.isNotEmpty) req.fields['last_name'] = last;

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

      if (kDebugMode) {
        debugPrint('— edit-user-profile REQUEST —');
        _debugPrintMap('fields', req.fields.map((k, v) => MapEntry(k, v)));
        debugPrint(
          'files: ${req.files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes)').join(', ')}',
        );
        debugPrint('url: $url');
      }

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
        await _loadProfile(); // refresh view/state
        setState(() {
          _pickedImage = null;
          _removeImage = false;
        });
      } else {
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
    return AppDrawerWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 900;

          return Scaffold(
             backgroundColor: AppColors.white,
            appBar: AppBar(
              automaticallyImplyLeading: !isWeb,
              backgroundColor: AppColors.white,
              elevation: 2,
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "Edit Profile",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            body: _loading
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
          );
        },
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    // Try a few likely keys your API may expose
    final avatarUrl =
        (_profile?['profile_image_url'] ??
                _profile?['profile_image'] ??
                _profile?['image'] ??
                '')
            .toString();

    // Optional read-only fields if present (email, mobile)
    final email = (_profile?['email'] ?? '').toString();
    final mobile = (_profile?['mobile'] ?? '').toString();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Avatar + actions
            Row(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundImage:
                      _pickedImage != null && _pickedImage!.bytes != null
                      ? MemoryImage(_pickedImage!.bytes!)
                      : (avatarUrl.isNotEmpty && !_removeImage)
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
                            _pickedImage = null;
                            _removeImage = true;
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

            const SizedBox(height: 16),

            // Optional read-only info if available
            if (email.isNotEmpty || mobile.isNotEmpty) ...[
              const SizedBox(height: 8),
              if (email.isNotEmpty)
                _readonlyTile(
                  icon: Icons.email_outlined,
                  label: "Email",
                  value: email,
                ),
              if (mobile.isNotEmpty)
                _readonlyTile(
                  icon: Icons.phone_android,
                  label: "Mobile",
                  value: mobile,
                ),
            ],

            if (_removeImage) ...[
              const SizedBox(height: 10),
              const Text(
                "Photo will be removed",
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],

            const SizedBox(height: 22),

            // Save
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

  Widget _readonlyTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
