import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

class UserHelpSupportPage extends StatelessWidget {
  const UserHelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy FAQ data
    final List<Map<String, String>> faqList = [
      {
        "question": "How to apply for jobs?",
        "answer": "Learn the step-by-step process to apply for jobs. Go to the job details page and click 'Apply'."
      },
      {
        "question": "Payment & Subscription",
        "answer": "Get information about payments and premium features. You can manage subscriptions from your profile."
      },
      {
        "question": "Profile Issues",
        "answer": "Resolve issues related to profile, resume, and account. Make sure your details are complete and correct."
      },
      {
        "question": "Contact Support",
        "answer": "Reach out to our support team for assistance via email or chat within the app."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Help & Support",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: faqList.map((faq) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  leading: const Icon(Icons.help_outline, color: AppColors.primary),
                  title: Text(
                    faq["question"]!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(faq["answer"]!),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
