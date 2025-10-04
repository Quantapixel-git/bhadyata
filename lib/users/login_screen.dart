import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_login.dart';
import 'package:jobshub/clients/client_login.dart';
import 'package:jobshub/hr/view/hr_login_screen.dart';
import 'package:jobshub/users/otp_screen.dart';
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

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => OtpScreen(mobile: mobile)),
        (route) => false
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

            // 🔹 Login content (shared between web & mobile)
            Widget loginContent = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isWeb ? 50 : 60),

                // 🔹 Logo and Title
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      _showAdminButton = true;
                    });
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/job_bgr.png",
                        height: isWeb ? 100 : 90,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Badhyata Login",
                        style: TextStyle(
                          fontSize: isWeb ? 28 : 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Enter your mobile number to continue",
                        style: TextStyle(
                          fontSize: isWeb ? 18 : 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isWeb ? 40 : 30),

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
                  height: isWeb ? 55 : 48,
                  child: ElevatedButton(
                    onPressed: _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Send OTP",
                      style: TextStyle(
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 New User? Sign Up
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpPage()),
                    );
                  },
                  child: Text(
                    "New User? Sign Up",
                    style: TextStyle(
                      fontSize: isWeb ? 16 : 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // 🔹 Show Admin Login button (appears on long press)
                if (_showAdminButton) ...[
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AdminLoginPage()),
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
                          maxWidth: isWeb ? 450 : double.infinity,
                        ),
                        child: isWeb
                            ? Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: loginContent,
                                ),
                              )
                            : loginContent,
                      ),
                    ),
                  ),
                ),

                Container(
                  color: Colors.grey.shade100,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        // ✅ Client Login
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ClientLoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Are you a client?",
                            style: TextStyle(
                              fontSize: isWeb ? 16 : 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HrLoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Are you HR?",
                            style: TextStyle(
                              fontSize: isWeb ? 16 : 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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
