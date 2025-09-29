import 'package:flutter/material.dart';
import 'package:jobshub/users/kyc_screen.dart';
import 'package:jobshub/utils/AppColor.dart';

class ClientOtpPage extends StatefulWidget {
  final String mobile;
  const ClientOtpPage({super.key, required this.mobile});

  @override
  State<ClientOtpPage> createState() => _ClientOtpPageState();
}

class _ClientOtpPageState extends State<ClientOtpPage> {
  final _otpController = TextEditingController();
  String? _otpError;

  void _verifyOtp() {
    final otp = _otpController.text.trim();
    setState(() {
      _otpError = null;
      if (otp.isEmpty || otp.length < 4) {
        _otpError = "Enter valid 4-digit OTP";
      }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Successful"),
            backgroundColor: Colors.green,
          ),
        );
         Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => KycStepperPage()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: AppColors.primary,
         iconTheme: const IconThemeData(
    color: Colors.white,)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "OTP sent to ${widget.mobile}",
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 60,
                    child: TextField(
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                        _otpController.text = _otpController.text
                            .padRight(4, ' ')
                            .replaceRange(index, index + 1, value);
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              if (_otpError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _otpError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 30),

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
                  ),
                  child: const Text(
                    "Verify OTP",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Change Mobile Number?",style: TextStyle(color: AppColors.primary),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
