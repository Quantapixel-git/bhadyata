import 'package:flutter/material.dart';
import 'package:jobshub/employer/views/drawer_dashboard/employer_dashboard.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class EmployerTellUsMore extends StatefulWidget {
  const EmployerTellUsMore({super.key});

  @override
  State<EmployerTellUsMore> createState() => _EmployerTellUsMoreState();
}

class _EmployerTellUsMoreState extends State<EmployerTellUsMore> {
  final _formKey = GlobalKey<FormState>();

  final _companyNameController = TextEditingController();
  final _designationController = TextEditingController();
  final _websiteController = TextEditingController();
  final _industryController = TextEditingController();
  final _companySizeController = TextEditingController();
  final _locationController = TextEditingController();
  final _aboutCompanyController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _designationController.dispose();
    _websiteController.dispose();
    _industryController.dispose();
    _companySizeController.dispose();
    _locationController.dispose();
    _aboutCompanyController.dispose();
    super.dispose();
  }

  void _submitProfile() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => EmployerDashboardPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWeb = constraints.maxWidth > 800;

            Widget formContent = Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tell us More",
                      style: TextStyle(
                        fontSize: isWeb ? 26 : 24,
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
                    const SizedBox(height: 25),
                
                    // 🔹 Company Name
                    TextFormField(
                      controller: _companyNameController,
                      decoration: _inputDecoration(
                        label: "Company Name",
                        icon: Icons.business,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? "Please enter company name"
                          : null,
                    ),
                    const SizedBox(height: 15),
                
                    // 🔹 Your Designation
                    TextFormField(
                      controller: _designationController,
                      decoration: _inputDecoration(
                        label: "Your Designation / Role",
                        icon: Icons.badge_outlined,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? "Please enter your designation"
                          : null,
                    ),
                    const SizedBox(height: 15),
                
                    // 🔹 Website
                    TextFormField(
                      controller: _websiteController,
                      decoration: _inputDecoration(
                        label: "Company Website (Optional)",
                        icon: Icons.language,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return null;
                        if (!Uri.parse(v).isAbsolute) return "Enter valid URL";
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                
                    // 🔹 Industry Type
                    TextFormField(
                      controller: _industryController,
                      decoration: _inputDecoration(
                        label: "Industry Type (e.g., IT, Manufacturing, Finance)",
                        icon: Icons.category_outlined,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? "Please enter industry type"
                          : null,
                    ),
                    const SizedBox(height: 15),
                
                    // 🔹 Company Size
                    TextFormField(
                      controller: _companySizeController,
                      decoration: _inputDecoration(
                        label: "Company Size (e.g., 10–50 employees)",
                        icon: Icons.group_outlined,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? "Please enter company size"
                          : null,
                    ),
                    const SizedBox(height: 15),
                
                    // 🔹 Office Location
                    TextFormField(
                      controller: _locationController,
                      decoration: _inputDecoration(
                        label: "Office Location / Address",
                        icon: Icons.location_on_outlined,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? "Please enter office location"
                          : null,
                    ),
                    const SizedBox(height: 15),
                
                    // 🔹 About Company
                    TextFormField(
                      controller: _aboutCompanyController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                        label: "About the Company",
                        icon: Icons.info_outline,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? "Please write a short company description"
                          : null,
                    ),
                    const SizedBox(height: 30),
                
                    // 🔹 Submit Button
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
                        ),
                        child: const Text(
                          "Next",
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
              ),
            );

            if (isWeb) {
              // 💻 Web/Desktop Layout
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 40,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 600,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage('assets/office_bg.png'),
                              fit: BoxFit.cover,
                              opacity: 0.15,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.business_center,
                                    size: 80,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    "Grow your team with Badhyata",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "Complete your company profile to start finding perfect candidates faster and smarter.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 60),
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: SingleChildScrollView(child: formContent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // 📱 Mobile Layout
              return Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
                      child: formContent,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
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
