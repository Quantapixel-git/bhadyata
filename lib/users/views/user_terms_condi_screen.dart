import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class UserTermsConditionsPage extends StatelessWidget {
  const UserTermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Terms & Conditions",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Welcome to Badhyata Connect!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Please read the following terms and conditions carefully before using our job portal app. By using this app, you agree to these terms.",
              ),
              SizedBox(height: 20),

              Text(
                "1. User Responsibilities",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "• Provide accurate and updated profile details.\n"
                "• Do not share false information or apply with fake profiles.\n"
                "• Respect employers and other users of the platform.",
              ),
              SizedBox(height: 20),

              Text(
                "2. Job Applications",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "• You are responsible for verifying job details before applying.\n"
                "• The app only connects candidates and employers; it does not guarantee job offers.",
              ),
              SizedBox(height: 20),

              Text(
                "3. Payments & Services",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "• Some premium features may require payment.\n"
                "• Payments made are non-refundable unless otherwise stated.",
              ),
              SizedBox(height: 20),

              Text(
                "4. Data & Privacy",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "• We respect your privacy and follow our Privacy Policy.\n"
                "• By using the app, you agree to allow us to process your data for job matching purposes.",
              ),
              SizedBox(height: 20),

              Text(
                "5. Termination",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "• We reserve the right to suspend or terminate accounts violating our policies.",
              ),
              SizedBox(height: 20),

              Text(
                "By using BadhyataConnect, you agree to these terms.",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
