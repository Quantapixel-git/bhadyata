import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_dashboard.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/constants/base_url.dart';

class EmployerTellUsMore extends StatefulWidget {
  const EmployerTellUsMore({super.key});

  @override
  State<EmployerTellUsMore> createState() => _EmployerTellUsMoreState();
}

class _EmployerTellUsMoreState extends State<EmployerTellUsMore> {
  // Page control (same flow as HR)
  final _pageController = PageController();
  int _currentPage = 0;

  // Separate form keys for per-step validation
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // Controllers — Company
  final _companyNameController = TextEditingController();
  final _designationController = TextEditingController();
  final _websiteController = TextEditingController();
  final _industryController = TextEditingController();
  final _companySizeController = TextEditingController();
  final _locationController = TextEditingController();
  final _aboutCompanyController = TextEditingController();

  // Controllers — Bank
  final _bankAccountNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankBranchController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();

    _companyNameController.dispose();
    _designationController.dispose();
    _websiteController.dispose();
    _industryController.dispose();
    _companySizeController.dispose();
    _locationController.dispose();
    _aboutCompanyController.dispose();

    _bankAccountNameController.dispose();
    _bankAccountNumberController.dispose();
    _bankIfscController.dispose();
    _bankNameController.dispose();
    _bankBranchController.dispose();
    super.dispose();
  }

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

  Future<void> _submitProfile() async {
    final valid2 = _formKeyStep2.currentState?.validate() ?? false;
    if (!valid2) return;

    try {
      final userId = await SessionManager.getValue('employer_id');
      if (userId == null || (userId.isEmpty)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User ID not found. Please log in again."),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final body = {
        "user_id": userId,
        "company_name": _companyNameController.text.trim(),
        "designation": _designationController.text.trim(),
        "company_website": _websiteController.text.trim(),
        "industry_type": _industryController.text.trim(),
        "company_size": _companySizeController.text.trim(),
        "office_location": _locationController.text.trim(),
        "about_company": _aboutCompanyController.text.trim(),
        "bank_account_name": _bankAccountNameController.text.trim(),
        "bank_account_number": _bankAccountNumberController.text.trim(),
        "bank_ifsc": _bankIfscController.text.trim().toUpperCase(),
        "bank_name": _bankNameController.text.trim(),
        "bank_branch": _bankBranchController.text.trim(),
      };

      final url = Uri.parse("${ApiConstants.baseUrl}employerSave-profile");

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

      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && (data['success'] == true)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Profile saved successfully"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => EmployerDashboardPage()),
          (route) => false,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Failed to save profile."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Ensure dialog is closed on error
      if (mounted) {
        Navigator.of(context, rootNavigator: true).maybePop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
                      // Left teaser (web only) — mirrors HR
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
                                  "Grow Your Business With Badhyata",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Complete your company profile in two quick steps — company details and bank details. Start hiring with confidence.",
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

                      // Right form card
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
                              // Step indicator (same style as HR)
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

                              // Pages
                              Expanded(
                                child: PageView(
                                  controller: _pageController,
                                  physics: const BouncingScrollPhysics(),
                                  onPageChanged: (i) =>
                                      setState(() => _currentPage = i),
                                  children: [
                                    _buildStep1Form(), // Company details
                                    _buildStep2Form(), // Bank details
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

  // —— STEP 1: Company Details ——
  Widget _buildStep1Form() {
    return Form(
      key: _formKeyStep1,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 3, 8, 16),
        child: Column(
          children: [
            _buildTextField(
              _companyNameController,
              "Company Name",
              icon: Icons.business,
              validator: _required("Company Name"),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _designationController,
              "Your Designation / Role",
              icon: Icons.badge_outlined,
              validator: _required("Your Designation / Role"),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _websiteController,
              "Company Website (Optional)",
              icon: Icons.language,
              isUrl: true,
              validator: _optionalUrl("Company Website (Optional)"),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _industryController,
              "Industry Type",
              icon: Icons.category_outlined,
              validator: _required("Industry Type"),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _companySizeController,
              "Company Size",
              icon: Icons.group_outlined,
              validator: _required("Company Size"),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _locationController,
              "Office Location / Address",
              icon: Icons.location_on_outlined,
              validator: _required("Office Location / Address"),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _aboutCompanyController,
              "About the Company",
              icon: Icons.info_outline,
              maxLines: 1,
              validator: _required("About the Company"),
            ),
          ],
        ),
      ),
    );
  }

  // —— STEP 2: Bank Details ——
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
            _buildTextField(
              _bankAccountNameController,
              "Account Holder Name",
              icon: Icons.account_circle,
              validator: _required("Account Holder Name"),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _bankAccountNumberController,
              "Account Number",
              icon: Icons.confirmation_number,
              isNumeric: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty)
                  return "Account Number is required";
                if (v.trim().length < 9) return "Enter a valid account number";
                return null;
              },
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _bankIfscController,
              "IFSC Code",
              icon: Icons.account_balance_wallet,
              textCapitalization: TextCapitalization.characters,
              // validator: (v) {
              //   if (v == null || v.trim().isEmpty)
              //     return "IFSC Code is required";
              //   final ifsc = v.trim().toUpperCase();
              //   final reg = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
              //   if (!reg.hasMatch(ifsc))
              //     return "Enter a valid IFSC (e.g., HDFC0001234)";
              //   return null;
              // },
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _bankNameController,
              "Bank Name",
              icon: Icons.account_balance,
              validator: _required("Bank Name"),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _bankBranchController,
              "Branch Name",
              icon: Icons.location_city,
              validator: _required("Branch Name"),
            ),
          ],
        ),
      ),
    );
  }

  // —— Shared field builder (matches HR styles) ——
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    bool isUrl = false,
    bool isNumeric = false,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      validator:
          validator ??
          (v) {
            if (v == null || v.isEmpty) return "$label is required";
            if (isUrl && v.trim().isNotEmpty) {
              final ok = Uri.tryParse(v.trim())?.hasAbsolutePath ?? false;
              final startsHttp =
                  v.trim().startsWith("http://") ||
                  v.trim().startsWith("https://");
              if (!ok || !startsHttp) return "Enter a valid URL (https://...)";
            }
            return null;
          },
    );
  }

  // —— Validators ——
  String? Function(String?) _required(String field) {
    return (v) => (v == null || v.trim().isEmpty) ? "$field is required" : null;
  }

  String? Function(String?) _optionalUrl(String field) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      final url = v.trim();
      final parsed = Uri.tryParse(url);
      final startsHttp =
          url.startsWith("http://") || url.startsWith("https://");
      if (parsed == null || !startsHttp)
        return "Enter a valid URL (https://...)";
      return null;
    };
  }
}

// Tiny step dot widget (reused from HR)
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
