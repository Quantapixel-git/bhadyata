import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_dashboard.dart';
import 'package:jobshub/employer/views/info_collector/employer_complete_profile.dart';

class EmployerOtpScreen extends StatefulWidget {
  final String mobile;
  final String? otp;

  const EmployerOtpScreen({super.key, required this.mobile, this.otp});

  @override
  State<EmployerOtpScreen> createState() => _EmployerOtpScreenState();
}

class _EmployerOtpScreenState extends State<EmployerOtpScreen> {
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

    // Autofill test OTP
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

  // 🔹 Verify Employer OTP
  void _verifyOtp() async {
    String otp = _controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      setState(() => _otpError = "Please enter the complete 6-digit OTP.");
      return;
    }
    setState(() => _otpError = null);

    final url = Uri.parse("${ApiConstants.baseUrl}verifyOtp");
    final body = {
      "mobile": widget.mobile,
      "otp_code": otp,
      "role": "2", // Employer role
    };

    try {
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

      // Log for debugging
      print("\n═══════════════════════════════════════════");
      print("🔹 API Endpoint: $url");
      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Request Body: ${jsonEncode(body)}");
      print("🔹 Response Body:");
      try {
        const encoder = JsonEncoder.withIndent('  ');
        print(encoder.convert(jsonDecode(response.body)));
      } catch (_) {
        print(response.body);
      }
      print("═══════════════════════════════════════════\n");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          (data['success'] == true || data['status'] == true)) {
        final employerData = data['data'];
        final employerId = employerData?['id'];
        final isNew = data['is_new_user'] ?? false;

        // ✅ Save to SessionManager
        await SessionManager.setValue(
          'employer_id',
          employerId?.toString() ?? '0',
        );
        await SessionManager.setValue('is_new_employer', isNew.toString());
        await SessionManager.setValue('mobile', widget.mobile);

        print(
          "✅ Saved to SessionManager → employer_id: $employerId | is_new_employer: $isNew",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP Verified Successfully!"),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Redirect based on new or existing user
        if (isNew) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => EmployerCompleteProfile(mobile: widget.mobile),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => EmployerDashboardPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Invalid OTP, please try again."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      print("❌ Exception while verifying employer OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $e"),
          behavior: SnackBarBehavior.floating,
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

  /// Responsive OTP fields:
  /// - On mobile: try to fit all 6 boxes on a single line by calculating boxWidth.
  /// - If boxWidth would be too small (< minBoxWidth) then fallback to a scrollable row.
  Widget _buildOtpFields(double totalAvailableWidth, bool isWeb) {
    // Visual constants (match UserOtpScreen style)
    const double horizontalPadding = 70; // surrounding padding (30 left + 30 right + small buffer)
    const double spacing = 6; // space between boxes
    const double maxBoxWidth = 40; // desired max width for a box on wide screens
    const double minBoxWidth = 40; // minimum acceptable width before we fallback to scroll

    // total spacing between boxes = spacing * (n - 1)
    final totalSpacing = spacing * (6 - 1);

    // compute available width for boxes (subtract typical paddings)
    final availableForBoxes = totalAvailableWidth - horizontalPadding - totalSpacing;

    // computed box width
    final computedBoxWidth = (availableForBoxes / 6).clamp(0.0, maxBoxWidth);

    // if computed width is too small, fallback to horizontal scroll; otherwise layout single line
    final shouldScroll = computedBoxWidth < minBoxWidth;

    Widget buildField(int index, double boxWidth) {
      return SizedBox(
        width: boxWidth,
        child: TextField(
          controller: _controllers[index],
          onChanged: (value) {
            // only accept digits — trim to single char
            if (value.length > 1) {
              final digit = value.replaceAll(RegExp(r'[^0-9]'), '');
              _controllers[index].text = digit.isNotEmpty ? digit[0] : '';
            }
            if (value.isNotEmpty && index < 5) {
              FocusScope.of(context).nextFocus();
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).previousFocus();
            }
            setState(() {}); // update visual state if needed
          },
          maxLength: 1,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
    }

    if (!shouldScroll) {
      // Single-line, non-scrollable row with computed widths
      final boxWidth = computedBoxWidth;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (i) {
          return Padding(
            padding: EdgeInsets.only(right: i == 5 ? 0 : spacing),
            child: buildField(i, boxWidth),
          );
        }),
      );
    } else {
      // Fallback: horizontally scrollable row
      final fallbackBoxWidth = minBoxWidth;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: List.generate(6, (i) {
            return Padding(
              padding: EdgeInsets.only(right: i == 5 ? 0 : spacing),
              child: buildField(i, fallbackBoxWidth),
            );
          }),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 800;
        final screenWidth = MediaQuery.of(context).size.width;

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

            // 🔹 OTP Fields (responsive single-line on mobile)
            _buildOtpFields(screenWidth, isWeb),

            if (_otpError != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _otpError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 35),

            // 🔹 Verify Button
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
                      Navigator.pop(context);
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

        return Scaffold(
          backgroundColor: AppColors.white,
          // appBar: AppBar(
          //   backgroundColor: AppColors.white,
          //   elevation: 0.5,
          //   iconTheme: const IconThemeData(color: Colors.black87),
          // ),
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
