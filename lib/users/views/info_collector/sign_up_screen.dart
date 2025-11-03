import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/info_collector/user_detail.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/constants/constants.dart';

class SignUpPage extends StatefulWidget {
  final String mobile; // ✅ Accept mobile from previous screen

  const SignUpPage({super.key, required this.mobile});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _referralController = TextEditingController();

  File? _pickedImageFile;
  Uint8List? _webImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // ✅ Prefill mobile and make it read-only
    _mobileController.text = widget.mobile;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  // 🖼 Pick image — works for both web & mobile
  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        if (kIsWeb) {
          final bytes = await picked.readAsBytes();
          setState(() {
            _webImageBytes = bytes;
            _pickedImageFile = null;
          });
        } else {
          setState(() {
            _pickedImageFile = File(picked.path);
            _webImageBytes = null;
          });
        }
      }
    } catch (e) {
      print("❌ Image pick error: $e");
    }
  }

  // 🔹 Submit updateProfile API
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // final prefs = await SharedPreferences.getInstance();
      // final userId = prefs.getInt('user_id');
      final userIdStr = await SessionManager.getValue('user_id');
      final userId = userIdStr != null && userIdStr.isNotEmpty
          ? int.tryParse(userIdStr)
          : null;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User ID not found. Please verify OTP again."),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final url = Uri.parse("${ApiConstants.baseUrl}updateProfile");
      var request = http.MultipartRequest('POST', url);

      request.fields['user_id'] = userId.toString();
      request.fields['role'] = '1'; // ✅ Fixed role = 1 (User)
      request.fields['first_name'] = _firstNameController.text.trim();
      request.fields['last_name'] = _lastNameController.text.trim();
      request.fields['email'] = _emailController.text.trim();
      request.fields['mobile'] = _mobileController.text.trim();
      if (_referralController.text.trim().isNotEmpty) {
        request.fields['referred_by'] = _referralController.text.trim();
      }

      // 🖼 Add image (works for both web & mobile)
      if (_pickedImageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_image',
            _pickedImageFile!.path,
          ),
        );
      } else if (_webImageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'profile_image',
            _webImageBytes!,
            filename: 'profile.png',
          ),
        );
      }

      // 🔹 Show loader
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // 🚀 Send request
      var response = await request.send();
      Navigator.pop(context);

      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);

      // 🧾 Pretty Print API Response
      const encoder = JsonEncoder.withIndent('  ');
      final pretty = encoder.convert(data);
      print("\n═══════════════════════════════════════════");
      print("🔹 API Endpoint: $url");
      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Form Data Sent:");
      print(request.fields);
      print("🔹 Response Body:\n$pretty");
      print("═══════════════════════════════════════════\n");

      // ✅ Handle Response
      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully ✅"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const JobProfileDetailsPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Failed to update profile."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      print("❌ Exception while updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWeb = constraints.maxWidth > 800;

            Widget formContent = Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Complete Your Profile",
                    style: TextStyle(
                      fontSize: isWeb ? 28 : 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Join Badhyata and get started",
                    style: TextStyle(
                      fontSize: isWeb ? 16 : 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 🖼 Profile Image
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _pickedImageFile != null
                          ? FileImage(_pickedImageFile!)
                          : _webImageBytes != null
                          ? MemoryImage(_webImageBytes!)
                          : null,
                      child: _pickedImageFile == null && _webImageBytes == null
                          ? const Icon(
                              Icons.camera_alt,
                              size: 32,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 🧍‍♂ First Name
                  _buildTextField(
                    _firstNameController,
                    "First Name",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 15),

                  _buildTextField(
                    _lastNameController,
                    "Last Name",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 15),

                  _buildTextField(
                    _emailController,
                    "Email",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),

                  // 📱 Mobile (prefilled & locked)
                  TextFormField(
                    controller: _mobileController,
                    readOnly: true, // ✅ make it uneditable
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildTextField(
                    _referralController,
                    "Referral Code (Optional)",
                    icon: Icons.card_giftcard_outlined,
                    isRequired: false, // ✅ optional now
                  ),

                  const SizedBox(height: 30),

                  // 🔘 Save & Continue
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        "Save & Continue",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );

            return isWeb
                ? _buildWebLayout(formContent)
                : _buildMobileLayout(formContent);
          },
        ),
      ),
    );
  }

  // 📱 Mobile Layout
  Widget _buildMobileLayout(Widget formContent) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
          child: formContent,
        ),
      ),
    );
  }

  // 💻 Web Layout
  Widget _buildWebLayout(Widget formContent) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: constraints.maxHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFE6EC), Color(0xFFF8D8E7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    top: 10,
                    // horizontal: 0,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 🩷 Left content
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 40.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Welcome to BADHYATA",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE91E63),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Create your professional profile and unlock opportunities. "
                                    "It only takes a minute to get started!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 🩷 Right form container
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 30,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 25,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: formContent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true, // ✅ Default: required unless specified
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return "$label is required";
        }
        return null; // ✅ No validation if optional
      },
    );
  }
}
