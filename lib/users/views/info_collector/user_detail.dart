import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/bottom_nav.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/constants/constants.dart';

class JobProfileDetailsPage extends StatefulWidget {
  const JobProfileDetailsPage({super.key});

  @override
  State<JobProfileDetailsPage> createState() => _JobProfileDetailsPageState();
}

class _JobProfileDetailsPageState extends State<JobProfileDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final _skillsController = TextEditingController();
  final _educationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _resumeUrlController = TextEditingController();
  final _bioController = TextEditingController();
  final _bankAccountNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankBranchController = TextEditingController();

  @override
  void dispose() {
    _skillsController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _linkedinController.dispose();
    _resumeUrlController.dispose();
    _bioController.dispose();
    _bankAccountNameController.dispose();
    _bankAccountNumberController.dispose();
    _bankIfscController.dispose();
    _bankNameController.dispose();
    _bankBranchController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final userIdStr = await SessionManager.getValue('user_id');
      final userId = userIdStr != null && userIdStr.isNotEmpty
          ? int.tryParse(userIdStr)
          : null;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("User ID not found. Please log in again."),
          ),
        );
        return;
      }

      final body = {
        "user_id": userId,
        "skills": _skillsController.text.trim(),
        "education": _educationController.text.trim(),
        "experience": _experienceController.text.trim(),
        "linkedin_url": _linkedinController.text.trim(),
        "resume_url": _resumeUrlController.text.trim(),
        "bio": _bioController.text.trim(),
        "bank_account_name": _bankAccountNameController.text.trim(),
        "bank_account_number": _bankAccountNumberController.text.trim(),
        "bank_ifsc": _bankIfscController.text.trim(),
        "bank_name": _bankNameController.text.trim(),
        "bank_branch": _bankBranchController.text.trim(),
      };

      final url = Uri.parse("${ApiConstants.baseUrl}employeeSave-profile");

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      Navigator.pop(context);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(data['message'] ?? "Profile saved successfully"),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashBoardScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(data['message'] ?? "Failed to save profile."),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 800;

        Widget formContent = Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tell Us More",
                style: TextStyle(
                  fontSize: isWeb ? 28 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We’ll match you with the best job opportunities",
                style: TextStyle(
                  fontSize: isWeb ? 16 : 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // 🧠 Profile Fields
              _buildTextField(
                _skillsController,
                "Skills (comma separated)",
                icon: Icons.code,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _educationController,
                "Education (e.g., B.Tech Computer Science)",
                icon: Icons.school,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _experienceController,
                "Experience (e.g., 2 years, Fresher)",
                icon: Icons.work_outline,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _linkedinController,
                "LinkedIn Profile URL",
                icon: Icons.link,
                isUrl: true,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _resumeUrlController,
                "Resume URL (Google Drive, Dropbox, etc.)",
                icon: Icons.picture_as_pdf,
                isUrl: true,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _bioController,
                "Short Bio / About Yourself",
                icon: Icons.person_outline,
                maxLines: 3,
              ),
              const SizedBox(height: 25),

              Text(
                "Bank Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 15),

              _buildTextField(
                _bankAccountNameController,
                "Account Holder Name",
                icon: Icons.account_circle,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _bankAccountNumberController,
                "Account Number",
                icon: Icons.confirmation_number,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _bankIfscController,
                "IFSC Code",
                icon: Icons.account_balance_wallet,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _bankNameController,
                "Bank Name",
                icon: Icons.account_balance,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _bankBranchController,
                "Branch Name",
                icon: Icons.location_city,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitProfile,
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

        return Scaffold(
          appBar: isWeb
              ? AppBar(
                  automaticallyImplyLeading: true,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.black),
                )
              : AppBar(
                  automaticallyImplyLeading: true,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.black),
                ),
          body: SafeArea(
            child: isWeb
                ? _buildWebLayout(formContent)
                : _buildMobileLayout(formContent),
          ),
        );
      },
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

  // 💻 Web Layout (Same as SignUpPage)
  Widget _buildWebLayout(Widget formContent) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFE6EC), Color(0xFFF8D8E7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                top: 10,
                // horizontal: 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🩷 Left Section
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Build Your Job Profile",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE91E63),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Add your education, experience, and bank details — and get matched with top employers instantly!",
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

                  // 🩷 Right Form Card
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 40,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool isUrl = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return "$label is required";
        if (isUrl && !Uri.parse(v).isAbsolute) return "Enter a valid URL";
        return null;
      },
    );
  }
}
