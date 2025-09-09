import 'package:flutter/material.dart';
import 'package:jobshub/users/otp_screen.dart';
import 'package:jobshub/admin/admin_login.dart';
import 'package:jobshub/clients/client_login.dart';

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
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
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
                          Image.asset("assets/job.png", height: 90),
                          const SizedBox(height: 12),
                          Text(
                            "JobsHub Login",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
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
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Send OTP",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

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
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
