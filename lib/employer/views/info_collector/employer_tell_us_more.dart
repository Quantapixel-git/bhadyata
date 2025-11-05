import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_dashboard.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/constants/constants.dart';

class EmployerTellUsMore extends StatefulWidget {
  const EmployerTellUsMore({super.key});

  @override
  State<EmployerTellUsMore> createState() => _EmployerTellUsMoreState();
}

class _EmployerTellUsMoreState extends State<EmployerTellUsMore> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _companyNameController = TextEditingController();
  final _designationController = TextEditingController();
  final _websiteController = TextEditingController();
  final _industryController = TextEditingController();
  final _companySizeController = TextEditingController();
  final _locationController = TextEditingController();
  final _aboutCompanyController = TextEditingController();
  final _bankAccountNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankBranchController = TextEditingController();

  @override
  void dispose() {
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

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final userId = await SessionManager.getValue('employer_id');
      if (userId == null) {
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
        "bank_ifsc": _bankIfscController.text.trim(),
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
          MaterialPageRoute(builder: (_) => EmployerDashboardPage()),
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
        SnackBar(content: Text("Error: $e"),  behavior: SnackBarBehavior.floating,),
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
                "We’ll help you connect with the right candidates",
                style: TextStyle(
                  fontSize: isWeb ? 16 : 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // 🏢 Company Fields
              _buildTextField(
                _companyNameController,
                "Company Name",
                icon: Icons.business,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _designationController,
                "Your Designation / Role",
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _websiteController,
                "Company Website (Optional)",
                icon: Icons.language,
                isUrl: true,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _industryController,
                "Industry Type",
                icon: Icons.category_outlined,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _companySizeController,
                "Company Size",
                icon: Icons.group_outlined,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _locationController,
                "Office Location / Address",
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _aboutCompanyController,
                "About the Company",
                icon: Icons.info_outline,
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
          appBar: AppBar(
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
              padding: const EdgeInsets.only(bottom: 8, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🏢 Left Info
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Grow Your Business With Badhyata",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE91E63),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Complete your company profile, add your details, and start hiring the best talent with confidence.",
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

                  // 💼 Right Form Card
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
      validator: (v) {
        if (v == null || v.isEmpty) return "$label is required";
        if (isUrl && !Uri.parse(v).isAbsolute) return "Enter a valid URL";
        return null;
      },
    );
  }
}
