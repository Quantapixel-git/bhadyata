import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jobshub/common/constants/constants.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/bottom_nav.dart';
import 'package:jobshub/users/views/info_collector/sign_up_screen.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  final String? otp; // 👈 optional dev OTP display

  const OtpScreen({super.key, required this.mobile, this.otp});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  String? _otpError;
  bool _canResend = false;
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // 🔹 Autofill the OTP if provided (for dev/testing)
    if (widget.otp != null && widget.otp!.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        for (
          int i = 0;
          i < _controllers.length && i < widget.otp!.length;
          i++
        ) {
          _controllers[i].text = widget.otp![i];
        }
      });
    }
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  // 🔹 Verify OTP API Call
  void _verifyOtp() async {
    String otp = _controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      setState(() {
        _otpError = "Please enter the complete 6-digit OTP.";
      });
      return;
    }

    setState(() => _otpError = null);

    final url = Uri.parse("${ApiConstants.baseUrl}verifyOtp");
    final body = {"mobile": widget.mobile, "otp_code": otp, "role": "1"};

    try {
      // 🔹 Show loader
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

      Navigator.pop(context); // close loader

      print("\n═══════════════════════════════════════════");
      print("🔹 API Endpoint: $url");
      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Request Body: ${jsonEncode(body)}");
      print("🔹 Response Body:");
      try {
        const encoder = JsonEncoder.withIndent('  ');
        final pretty = encoder.convert(jsonDecode(response.body));
        print(pretty);
      } catch (_) {
        print(response.body);
      }
      print("═══════════════════════════════════════════\n");

      final data = jsonDecode(response.body);

      // ✅ OTP verified successfully
      if (response.statusCode == 200 &&
          (data['success'] == true || data['status'] == true)) {
        final userData = data['data'];
        final userId = userData?['id'];
        final isNewUser = data['is_new_user'] ?? false;

        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setInt('user_id', userId ?? 0);
        // await prefs.setBool('is_new_user', isNewUser);
        await SessionManager.setValue('user_id', userId?.toString() ?? '');
        await SessionManager.setValue('is_new_user', isNewUser.toString());

        print(
          "✅ Saved to SharedPrefs → user_id: $userId | is_new_user: $isNewUser",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP Verified Successfully ✅"),
            backgroundColor: Colors.green,
          ),
        );

        // 🚀 Navigate based on user type
        if (isNewUser) {
          // ✅ Save mobile also to SharedPreferences for later use
          // await prefs.setString('mobile', widget.mobile);
          await SessionManager.setValue('mobile', widget.mobile);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  SignUpPage(mobile: widget.mobile), // 👈 send to next page
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
          );
        }
      } else {
        // ❌ Invalid or expired OTP
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Invalid OTP, please try again."),
            backgroundColor: Colors.redAccent,
          ),
        );
        // Stay on same page (do nothing)
      }
    } catch (e) {
      Navigator.pop(context);
      print("❌ Exception while calling verifyOtp: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 800;

        Widget otpContent = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isWeb) ...[
              Image.asset("assets/job_bgr.png", height: 100),
              const SizedBox(height: 30),
            ],
            const Text(
              "OTP Verification",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Enter the 6-digit code sent to",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: isWeb ? 16 : 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "+91 ${widget.mobile}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 35),

            // 🔹 OTP Input Fields
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: isWeb ? 60 : 50,
                  child: TextField(
                    controller: _controllers[index],
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              }),
            ),

            if (_otpError != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _otpError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 35),

            // 🔹 Verify OTP Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isWeb ? 3 : 0,
                ),
                child: const Text(
                  "Verify OTP",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔹 Resend OTP
            _canResend
                ? TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 👈 Go back to previous page
                    },
                    child: const Text(
                      "Resend OTP",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    "Resend in $_secondsRemaining sec",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
          ],
        );

        // 🔹 Responsive Layout
        return Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            iconTheme: const IconThemeData(color: Colors.black87),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Container(
                constraints: isWeb ? const BoxConstraints(maxWidth: 520) : null,
                padding: const EdgeInsets.all(30),
                decoration: isWeb
                    ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      )
                    : null,
                child: otpContent,
              ),
            ),
          ),
        );
      },
    );
  }
}
