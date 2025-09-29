import 'package:flutter/material.dart';
import 'package:jobshub/users/otp_screen.dart';
import 'package:jobshub/admin/admin_login.dart';
import 'package:jobshub/clients/client_login.dart';
import 'package:jobshub/users/sign_up_screen.dart';
import 'package:jobshub/utils/AppColor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileController = TextEditingController();
  String? _mobileError;
  bool _showAdminButton = false;

  bool _isValidMobile(String mobile) {
    return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
  }

  void _sendOtp() {
    final mobile = _mobileController.text.trim();
    if (_isValidMobile(mobile)) {
      setState(() => _mobileError = null);

      // Navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpPage(mobile: mobile),
        ),
      );
    } else {
      setState(() => _mobileError = "Enter a valid 10-digit mobile number");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWeb = constraints.maxWidth > 800;

            Widget loginContent = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),

                // 🔹 Logo and Title (long press to show admin button)
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      _showAdminButton = true;
                    });
                  },
                  child: Column(
                    children: [
                      Image.asset("assets/job_bgr.png", height: 90),
                      const SizedBox(height: 12),
                      Text(
                        "Badhyata Login",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Enter your mobile number to continue",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // 🔹 Mobile input
                TextField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: "Mobile Number",
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: _mobileError,
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
                const SizedBox(height: 20),

                // 🔹 Send OTP button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Send OTP",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),


// 🔹 New User? Sign Up
TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SignUpPage(),
      ),
    );
  },
  child: const Text(
    "New User? Sign Up",
    style: TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    ),
  ),
),

                // 🔹 Show Admin Login button (optional)
                if (_showAdminButton) ...[
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AdminLoginPage()),
                        );
                      },
                      icon: const Icon(Icons.admin_panel_settings),
                      label: const Text("Go to Admin Login"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isWeb ? 400 : double.infinity,
                        ),
                        child: loginContent,
                      ),
                    ),
                  ),
                ),

                // 🔹 Bottom client login link
                Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClientLoginPage()),
                      );
                    },
                    child: const Center(
                      child: Text(
                        "Are you a client?",
                        style: TextStyle(
                           color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
