import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_routes.dart';

import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/bottom_nav.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/constants/base_url.dart';

class JobProfileDetailsPage extends StatefulWidget {
  const JobProfileDetailsPage({super.key});

  @override
  State<JobProfileDetailsPage> createState() => _JobProfileDetailsPageState();
}

class _JobProfileDetailsPageState extends State<JobProfileDetailsPage> {
  // Page control (same pattern as HR)
  final _pageController = PageController();
  int _currentPage = 0;

  // Separate form keys per step
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // ---------- Category (from API) ----------
  List<String> _categories = [];
  String? _selectedCategory;
  bool _catLoading = true;

  // Job types (local list)
  final List<String> _jobTypes = [
    'One-time',
    'Salary-based',
    'Commision-based',
    'Projects',
  ];
  String? _selectedJobType;

  // Step 1 controllers
  final _skillsController = TextEditingController();
  final _educationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _resumeUrlController = TextEditingController();
  final _bioController = TextEditingController();

  // Step 2 controllers (Bank)
  final _bankAccountNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankBranchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _catLoading = true);
    try {
      final url = Uri.parse("${ApiConstants.baseUrl}getallcategory");
      final res = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final decoded = jsonDecode(res.body);
        if (decoded['status'] == 1 && decoded['data'] is List) {
          final names =
              (decoded['data'] as List)
                  .map((e) => (e['category_name'] ?? '').toString())
                  .where((s) => s.isNotEmpty)
                  .toSet() // de-dupe
                  .toList()
                ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

          setState(() {
            _categories = names;
            _selectedCategory = _categories.isNotEmpty
                ? _categories.first
                : null;
          });
        } else {
          setState(() {
            _categories = [];
            _selectedCategory = null;
          });
        }
      } else {
        setState(() {
          _categories = [];
          _selectedCategory = null;
        });
      }
    } catch (_) {
      setState(() {
        _categories = [];
        _selectedCategory = null;
      });
    } finally {
      if (mounted) setState(() => _catLoading = false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();

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

  // ——— Navigation between steps ———
  Future<void> _goNext() async {
    final ok = _formKeyStep1.currentState?.validate() ?? false;
    if (!ok) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _goBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  // ——— Submit API ———
  Future<void> _submitProfile() async {
    final ok = _formKeyStep2.currentState?.validate() ?? false;
    if (!ok) return;

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
        "category": _selectedCategory, // <- category name from API
        "job_type": _selectedJobType,
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
        Navigator.pushReplacementNamed(context, AppRoutes.userDashboard);
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
        final isWeb = constraints.maxWidth > 800;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            automaticallyImplyLeading: true,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 24 : 16,
                    vertical: isWeb ? 16 : 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isWeb)
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24.0, top: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  "Build Your Job Profile",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Complete your profile in two quick steps — tell us about yourself and add your bank details.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _StepDot(
                                    active: _currentPage == 0,
                                    label: "1",
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 24,
                                    height: 2,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(width: 8),
                                  _StepDot(
                                    active: _currentPage == 1,
                                    label: "2",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _currentPage == 0
                                    ? "Tell Us More"
                                    : "Bank Details",
                                style: TextStyle(
                                  fontSize: isWeb ? 24 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: PageView(
                                  controller: _pageController,
                                  physics: const BouncingScrollPhysics(),
                                  onPageChanged: (i) =>
                                      setState(() => _currentPage = i),
                                  children: [
                                    _buildStep1Form(),
                                    _buildStep2Form(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  if (_currentPage == 1)
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: _goBack,
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          side: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Text(
                                            "Back",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_currentPage == 1)
                                    const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _currentPage == 0
                                          ? _goNext
                                          : _submitProfile,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          _currentPage == 0
                                              ? "Next"
                                              : "Save & Continue",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ——— STEP 1 ———
  Widget _buildStep1Form() {
    return Form(
      key: _formKeyStep1,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 8, 18, 24),
        child: Column(
          children: [
            _field(
              controller: _skillsController,
              label: "Skills (comma separated)",
              icon: Icons.code,
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Skills are required" : null,
            ),
            const SizedBox(height: 15),
            _field(
              controller: _educationController,
              label: "Education (e.g., B.Tech Computer Science)",
              icon: Icons.school,
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Education is required" : null,
            ),
            const SizedBox(height: 15),
            _field(
              controller: _experienceController,
              label: "Experience (e.g., 2 years, Fresher)",
              icon: Icons.work_outline,
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Experience is required" : null,
            ),
            const SizedBox(height: 15),
            _field(
              controller: _linkedinController,
              label: "LinkedIn Profile URL",
              icon: Icons.link,
              isUrl: true,
            ),
            const SizedBox(height: 15),
            _field(
              controller: _resumeUrlController,
              label: "Resume URL (Google Drive, Dropbox, etc.)",
              icon: Icons.picture_as_pdf,
              isUrl: true,
            ),
            const SizedBox(height: 15),
            _field(
              controller: _bioController,
              label: "Short Bio / About Yourself",
              icon: Icons.person_outline,
              maxLines: 1,
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Bio is required" : null,
            ),
            const SizedBox(height: 20),

            // Category (from API)
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: _catLoading
                  ? null
                  : (v) => setState(() => _selectedCategory = v),
              decoration: _dropdownDecoration(
                _catLoading ? "Loading categories..." : "Category",
                Icons.category_outlined,
              ),
              validator: (_) {
                if (_catLoading) return "Please wait...";
                if (_selectedCategory == null || _selectedCategory!.isEmpty) {
                  return "Category is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 15),

            // Job Type
            DropdownButtonFormField<String>(
              value: _selectedJobType,
              isExpanded: true,
              items: _jobTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedJobType = v),
              decoration: _dropdownDecoration("Job Type", Icons.work_outline),
              validator: (v) => v == null ? 'Job Type is required' : null,
            ),
          ],
        ),
      ),
    );
  }

  // ——— STEP 2 ———
  Widget _buildStep2Form() {
    return Form(
      key: _formKeyStep2,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 6),
            const Text(
              "Bank Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 15),
            _field(
              controller: _bankAccountNameController,
              label: "Account Holder Name",
              icon: Icons.account_circle,
              validator: _required,
            ),
            const SizedBox(height: 15),
            _field(
              controller: _bankAccountNumberController,
              label: "Account Number",
              icon: Icons.confirmation_number,
              validator: _required,
            ),
            const SizedBox(height: 15),
            _field(
              controller: _bankIfscController,
              label: "IFSC Code",
              icon: Icons.account_balance_wallet,
              validator: _required,
            ),
            const SizedBox(height: 15),
            _field(
              controller: _bankNameController,
              label: "Bank Name",
              icon: Icons.account_balance,
              validator: _required,
            ),
            const SizedBox(height: 15),
            _field(
              controller: _bankBranchController,
              label: "Branch Name",
              icon: Icons.location_city,
              validator: _required,
            ),
          ],
        ),
      ),
    );
  }

  // ——— Shared text field (matches HR look) ———
  Widget _field({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    String? Function(String?)? validator,
    bool isUrl = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isUrl ? TextInputType.url : TextInputType.text,
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
        if (validator != null) return validator(v);
        if (isUrl &&
            v != null &&
            v.isNotEmpty &&
            !(Uri.tryParse(v)?.isAbsolute ?? false)) {
          return "Enter a valid URL";
        }
        return null;
      },
    );
  }

  String? _required(String? v) =>
      (v == null || v.isEmpty) ? "This field is required" : null;

  InputDecoration _dropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

// Tiny step dot (same style as HR)
class _StepDot extends StatelessWidget {
  final bool active;
  final String label;
  const _StepDot({required this.active, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
