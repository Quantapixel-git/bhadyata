// import 'package:flutter/material.dart';
// import 'package:jobshub/employer/views/auth/employer_otp.dart';
// import 'package:jobshub/common/utils/AppColor.dart';

// class EmployerLogin extends StatefulWidget {
//   const EmployerLogin({super.key});

//   @override
//   State<EmployerLogin> createState() => _EmployerLoginState();
// }

// class _EmployerLoginState extends State<EmployerLogin> {
//   final _mobileController = TextEditingController();
//   String? _mobileError;

//   void _sendOtp() {
//     final mobile = _mobileController.text.trim();
//     setState(() => _mobileError = null);
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => EmployerOtpScreen(mobile: mobile)),
//     );
//   }

//   Widget _buildLoginContent(bool isWeb, double width) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const SizedBox(height: 20),

//         // 🔹 Logo and text
//         Column(
//           children: [
//             Image.asset("assets/job_bgr.png", height: isWeb ? 120 : 100),
//             const SizedBox(height: 20),
//             Text(
//               "Employer Login",
//               style: TextStyle(
//                 fontSize: isWeb ? 30 : 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primary,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Login to continue",
//               style: TextStyle(
//                 fontSize: isWeb ? 18 : 14,
//                 color: Colors.black54,
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 40),

//         // 🔹 Mobile Number Input
//         SizedBox(
//           width: isWeb ? width * 0.9 : double.infinity,
//           child: TextField(
//             controller: _mobileController,
//             keyboardType: TextInputType.phone,
//             maxLength: 10,
//             decoration: InputDecoration(
//               counterText: '',
//               labelText: "Mobile Number",
//               prefixIcon: Icon(
//                 Icons.phone_iphone_rounded,
//                 color: AppColors.primary,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: AppColors.primary, width: 2),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               errorText: _mobileError,
//             ),
//           ),
//         ),

//         const SizedBox(height: 25),

//         // 🔹 Send OTP Button
//         SizedBox(
//           width: isWeb ? width * 0.9 : double.infinity,
//           height: 50,
//           child: ElevatedButton(
//             onPressed: _sendOtp,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
//             child: const Text(
//               "Send OTP",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 17,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff8f9fb),
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             bool isWeb = constraints.maxWidth > 800;

//             if (isWeb) {
//               // 💻 Desktop/Web Layout
//               return Center(
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 50),
//                   constraints: const BoxConstraints(
//                     maxWidth: 800,
//                     maxHeight: 700,
//                   ),
//                   padding: const EdgeInsets.all(40),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 12,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       // Left side (branding/illustration)
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 30),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset("assets/job_bgr.png", height: 160),
//                               const SizedBox(height: 20),
//                               Text(
//                                 "Welcome, Employer!",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primary,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               const Text(
//                                 "Easily manage your job postings and find the best talent on Badhyata.",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // Divider
//                       Container(
//                         width: 1,
//                         height: 400,
//                         color: Colors.grey.shade300,
//                       ),

//                       // Right side (form)
//                       Expanded(
//                         child: SingleChildScrollView(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 30),
//                             child: _buildLoginContent(true, 300),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             } else {
//               // 📱 Mobile Layout (unchanged)
//               return Center(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
//                     child: _buildLoginContent(false, double.infinity),
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/constants.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/auth/employer_otp.dart';

class EmployerLogin extends StatefulWidget {
  const EmployerLogin({super.key});

  @override
  State<EmployerLogin> createState() => _EmployerLoginState();
}

class _EmployerLoginState extends State<EmployerLogin> {
  final _mobileController = TextEditingController();
  String? _mobileError;

  Future<void> _sendOtp() async {
    final mobile = _mobileController.text.trim();

    // 🔹 Validate mobile number
    if (mobile.isEmpty || mobile.length != 10) {
      setState(() => _mobileError = "Enter a valid 10-digit mobile number");
      return;
    } else {
      setState(() => _mobileError = null);
    }

    final url = Uri.parse("${ApiConstants.baseUrl}sendOtp");

    try {
      // 🔹 Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // 🔹 Prepare body
      final body = {
        "mobile": mobile,
        "fcm_token": "abc123xyz",
        "role": 2, // ✅ Employer Role
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      Navigator.pop(context); // Close loading dialog

      // 🧾 Log formatted API response
      print("\n═══════════════════════════════════════════");
      print("🔹 API Endpoint: $url");
      print("🔹 Request Body: $body");
      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Raw Response:");
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      try {
        final formatted = encoder.convert(jsonDecode(response.body));
        print(formatted);
      } catch (_) {
        print(response.body);
      }
      print("═══════════════════════════════════════════\n");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final success = data['status'] == true || data['success'] == true;

        if (success) {
          final otp =
              data['otp_demo']?.toString() ??
              data['data']?['otp_code']?.toString() ??
              "";

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("OTP sent successfully! (OTP: $otp)")),
          );

          // ✅ Navigate to OTP screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmployerOtpScreen(
                mobile: mobile,
                otp: otp, // Pass OTP for development
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Failed to send OTP")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      print("❌ Exception while calling sendOtp: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
    }
  }

  Widget _buildLoginContent(bool isWeb, double width) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),

        // 🔹 Logo and Heading
        Column(
          children: [
            Image.asset("assets/job_bgr.png", height: isWeb ? 120 : 100),
            const SizedBox(height: 20),
            Text(
              "Employer Login",
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

        const SizedBox(height: 40),

        // 🔹 Mobile Input
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
                      // Left Branding
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/job_bgr.png", height: 160),
                              const SizedBox(height: 20),
                              Text(
                                "Welcome, Employer!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Easily manage your job postings and find the best talent on Badhyata.",
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

                      // Right Form
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
              // 📱 Mobile Layout
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
