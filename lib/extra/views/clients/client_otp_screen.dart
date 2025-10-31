// import 'package:flutter/material.dart';
// import 'package:jobshub/extra/views/clients/client_dashboard.dart';
// import 'package:jobshub/common/utils/AppColor.dart';

// class ClientOtpScreen extends StatefulWidget {
//   final String mobile;
//   const ClientOtpScreen({super.key, required this.mobile});

//   @override
//   State<ClientOtpScreen> createState() => ClientOtpScreenState();
// }

// class ClientOtpScreenState extends State<ClientOtpScreen> {
//   final _otpController = TextEditingController();
//   String? _otpError;

//   void _verifyOtp() {
//     final otp = _otpController.text.trim();
//     setState(() {
//       _otpError = null;
//       if (otp.isEmpty || otp.length < 4) {
//         _otpError = "Enter valid 4-digit OTP";
//         return;
//       }
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) =>  ClientDashboardPage()),
//            (route) => false
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         bool isWeb = constraints.maxWidth > 800;

//         // 🔹 OTP UI shared
//         Widget otpContent = Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (isWeb) ...[
//               Image.asset("assets/job_bgr.png", height: 90),
//               const SizedBox(height: 20),
//             ],
//             Text(
//               "OTP sent to ${widget.mobile}",
//               style: const TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//             const SizedBox(height: 40),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(4, (index) {
//                 return SizedBox(
//                   width: 60,
//                   child: TextField(
//                     onChanged: (value) {
//                       if (value.isNotEmpty && index < 3) {
//                         FocusScope.of(context).nextFocus();
//                       }
//                       _otpController.text = _otpController.text
//                           .padRight(4, ' ')
//                           .replaceRange(index, index + 1, value);
//                     },
//                     maxLength: 1,
//                     textAlign: TextAlign.center,
//                     keyboardType: TextInputType.number,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     decoration: InputDecoration(
//                       counterText: "",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),

//             if (_otpError != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text(
//                   _otpError!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),

//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _verifyOtp,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Verify OTP",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text(
//                 "Change Mobile Number?",
//                 style: TextStyle(color: AppColors.primary),
//               ),
//             ),
//           ],
//         );

//         // 🔹 Web = Centered Card (no AppBar), Mobile = Scaffold with AppBar
//         if (isWeb) {
//           return Scaffold(
//             body: Center(
//               child: SingleChildScrollView(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 450),
//                   child: Card(
//                     elevation: 8,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(32.0),
//                       child: otpContent,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         } else {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text("Verify OTP"),
//               backgroundColor: AppColors.primary,
//             ),
//             body: SafeArea(
//               child: SingleChildScrollView(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
//                 child: otpContent,
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
