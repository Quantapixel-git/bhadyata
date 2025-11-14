import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_dashboard.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/constants/base_url.dart';

class HrTellUsMore extends StatefulWidget {
  const HrTellUsMore({super.key});

  @override
  State<HrTellUsMore> createState() => _HrTellUsMoreState();
}

class _HrTellUsMoreState extends State<HrTellUsMore> {
  // Page control
  final _pageController = PageController();
  int _currentPage = 0;

  // Separate form keys per page so we only validate the visible one
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // Controllers
  final _positionController = TextEditingController();
  final _experienceController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _bioController = TextEditingController();
  final _bankAccountNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankBranchController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _positionController.dispose();
    _experienceController.dispose();
    _linkedinController.dispose();
    _bioController.dispose();
    _bankAccountNameController.dispose();
    _bankAccountNumberController.dispose();
    _bankIfscController.dispose();
    _bankNameController.dispose();
    _bankBranchController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    try {
      final isValidStep2 = _formKeyStep2.currentState?.validate() ?? false;
      if (!isValidStep2) return;

      final userIdStr = await SessionManager.getValue('hr_id');
      if (userIdStr == null || userIdStr.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User ID not found. Please log in again."),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final body = {
        "user_id": userIdStr,
        "position_title": _positionController.text.trim(),
        "experience_years":
            int.tryParse(_experienceController.text.trim()) ?? 0,
        "linkedin_url": _linkedinController.text.trim(),
        "bio": _bioController.text.trim(),
        "bank_account_name": _bankAccountNameController.text.trim(),
        "bank_account_number": _bankAccountNumberController.text.trim(),
        "bank_ifsc": _bankIfscController.text.trim(),
        "bank_name": _bankNameController.text.trim(),
        "bank_branch": _bankBranchController.text.trim(),
      };

      final url = Uri.parse("${ApiConstants.baseUrl}hrSave-Profile");

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
            content: Text(data['message'] ?? "Profile saved successfully"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HrDashboard()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Failed to save profile."),
            behavior: SnackBarBehavior.floating,
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

  Future<void> _goNext() async {
    // Validate step 1 before moving to step 2
    final isValid = _formKeyStep1.currentState?.validate() ?? false;
    if (!isValid) return;
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Empower Your Career With Badhyata",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Complete your HR profile in two quick steps — tell us about yourself and add your bank details.",
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
                              // Step header / indicator
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

                              // Swiper
                              Expanded(
                                child: PageView(
                                  controller: _pageController,
                                  physics: const BouncingScrollPhysics(),
                                  onPageChanged: (i) =>
                                      setState(() => _currentPage = i),
                                  children: [
                                    _buildStep1Form(), // page 1
                                    _buildStep2Form(), // page 2
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Footer actions
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
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: const Text("Back", style: TextStyle(fontSize: 18),),
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
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
        child: Column(
          children: [
            _buildTextField(
              _positionController,
              "Position Title",
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _experienceController,
              "Experience (in years)",
              icon: Icons.timeline,
              isNumeric: true,
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
              _bioController,
              "Short Bio / About You",
              icon: Icons.info_outline,
              maxLines: 3,
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
            Text(
              "Bank Details",
              style: const TextStyle(
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
              isNumeric: true,
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
          ],
        ),
      ),
    );
  }

  // ——— Shared field builder ———
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    bool isUrl = false,
    bool isNumeric = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
     
    );
  }
}

// Tiny step dot widget
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
