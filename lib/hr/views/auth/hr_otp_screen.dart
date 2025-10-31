import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jobshub/hr/views/info_collector/hr_complete_profile.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class HROtpScreen extends StatefulWidget {
  final String mobile;
  const HROtpScreen({super.key, required this.mobile});

  @override
  State<HROtpScreen> createState() => _HROtpScreenState();
}

class _HROtpScreenState extends State<HROtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
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

  void _verifyOtp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HrCompleteProfile()),
    );
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
              "Enter the 4-digit code sent to",
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

            /// 🔹 OTP Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: isWeb ? 70 : 60,
                  child: TextField(
                    controller: _controllers[index],
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
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

            /// 🔹 Verify OTP Button
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

            /// 🔹 Resend OTP
            _canResend
                ? TextButton(
                    onPressed: _startTimer,
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
        if (isWeb) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              iconTheme: const IconThemeData(color: Colors.black87),
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 60,
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: otpContent,
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              // backgroundColor: Colors.white,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                ),
                child: otpContent,
              ),
            ),
          );
        }
      },
    );
  }
}
