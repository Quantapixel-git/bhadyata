import 'package:flutter/material.dart';
import 'package:jobshub/hr/view/drawer_dashboard/hr_dashboard.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class HrCompleteProfile extends StatefulWidget {
  const HrCompleteProfile({super.key});

  @override
  State<HrCompleteProfile> createState() => _HrCompleteProfileState();
}

class _HrCompleteProfileState extends State<HrCompleteProfile> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _signUp() {
    // if (_formKey.currentState!.validate()) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HrDashboard()),
    );
    // }
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

                  // 🔹 First Name
                  TextFormField(
                    controller: _firstNameController,
                    decoration: _inputDecoration(
                      label: "First Name",
                      icon: Icons.person,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "First name is required"
                        : null,
                  ),
                  const SizedBox(height: 15),

                  // 🔹 Last Name
                  TextFormField(
                    controller: _lastNameController,
                    decoration: _inputDecoration(
                      label: "Last Name",
                      icon: Icons.person_outline,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Last name is required"
                        : null,
                  ),
                  const SizedBox(height: 15),

                  // 🔹 Email
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration(
                      label: "Email",
                      icon: Icons.email_outlined,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Email is required";
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // 🔹 Mobile
                  TextFormField(
                    controller: _mobileController,
                    decoration: _inputDecoration(
                      label: "Mobile Number",
                      icon: Icons.phone_android,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Mobile number is required";
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return "Enter a valid 10-digit number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Next Button
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
            );

            // 💻 Web Layout
            if (isWeb) {
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
                              image: AssetImage('assets/profile_bg.png'),
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
                                    Icons.account_circle_outlined,
                                    size: 80,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    "Let's build your profile",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "Enter your basic details to start creating your HR account and access recruiter tools.",
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
                    child: formContent,
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
