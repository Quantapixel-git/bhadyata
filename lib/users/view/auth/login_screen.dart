import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_login.dart';
import 'package:jobshub/employer/view/auth/employer_login.dart';
import 'package:jobshub/hr/view/auth/hr_login_screen.dart';
import 'package:jobshub/users/view/auth/otp_screen.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileController = TextEditingController();
  String? _mobileError;
  bool _showAdminButton = false;

  void _sendOtp() {
    final mobile = _mobileController.text.trim();
    setState(() => _mobileError = null);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OtpScreen(mobile: mobile)),
    );
  }

  Widget _buildLoginContent(bool isWeb, double width) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),

        // 🔹 Logo (long press → Admin)
        GestureDetector(
          onLongPress: () => setState(() => _showAdminButton = true),
          child: Column(
            children: [
              Image.asset("assets/job_bgr.png", height: isWeb ? 120 : 100),
              const SizedBox(height: 20),
              Text(
                "Welcome to Badhyata",
                style: TextStyle(
                  fontSize: isWeb ? 30 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Login to continue",
                style: TextStyle(
                  fontSize: isWeb ? 18 : 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // 🔹 Mobile input
        SizedBox(
          width: isWeb ? width * 0.9 : double.infinity,
          child: TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: InputDecoration(
              counterText: '',
              labelText: "Mobile Number",
              prefixIcon: Icon(
                Icons.phone_iphone_rounded,
                color: AppColors.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(14),
              ),
              errorText: _mobileError,
            ),
          ),
        ),

        const SizedBox(height: 25),

        // 🔹 Send OTP Button
        SizedBox(
          width: isWeb ? width * 0.9 : double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Send OTP",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 25),

        // 🔹 Links
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmployerLogin()),
          ),
          child: const Text(
            "Are you an Employer?",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),

        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HrLoginPage()),
          ),
          child: const Text(
            "Are you an HR?",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),

        const SizedBox(height: 15),

        // 🔹 Admin button (hidden)
        if (_showAdminButton)
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AdminLoginPage()),
            ),
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: const Text("Admin Login"),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary, width: 1.5),
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWeb = constraints.maxWidth > 800;

            if (isWeb) {
              // 💻 Desktop/Web Layout
              return Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                    maxHeight: 700,
                  ),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Left side (branding)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/job_bgr.png", height: 160),
                              const SizedBox(height: 20),
                              Text(
                                "Welcome to Badhyata",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Connecting job seekers, HRs, and employers — all in one place.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Divider
                      Container(
                        width: 1,
                        height: 400,
                        color: Colors.grey.shade300,
                      ),

                      // Right side (form)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildLoginContent(true, 300),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // 📱 Mobile Layout (unchanged)
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
                    child: _buildLoginContent(false, double.infinity),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
