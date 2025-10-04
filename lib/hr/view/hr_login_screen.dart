import 'package:flutter/material.dart';
import 'package:jobshub/hr/view/hr_otp_screen.dart';
import 'package:jobshub/utils/AppColor.dart';

class HrLoginPage extends StatefulWidget {
  const HrLoginPage({super.key});

  @override
  State<HrLoginPage> createState() => HrLoginPageState();
}

class HrLoginPageState extends State<HrLoginPage> {
  final _mobileController = TextEditingController();
  String? _mobileError;

  bool _isValidMobile(String mobile) {
    return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
  }

  void _sendOtp() {
    final mobile = _mobileController.text.trim();
    setState(() {
      _mobileError = null;
      if (_isValidMobile(mobile)) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => HrOtpScreen(mobile: mobile),
          ),(route) => false
        );
      } else {
        _mobileError = "Enter a valid 10-digit mobile number";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWeb = constraints.maxWidth > 800;

            // 🔹 Shared login content
            Widget loginContent = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/job_bgr.png", height: 100),
                const SizedBox(height: 20),
                Text(
                  "HR Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your mobile number to login",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 40),

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
                const SizedBox(height: 30),

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
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
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
            );
          },
        ),
      ),
    );
  }
}
