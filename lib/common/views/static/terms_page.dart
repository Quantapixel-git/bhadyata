import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f4f8),
      appBar: AppBar(
        elevation: 0.8,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 900;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: const Color(0xfffbf7ff),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 32 : 20,
                      vertical: 26,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Terms & Conditions",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Last updated: 02 December 2025",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 22),
                        Divider(color: Colors.grey.shade300),
                        const SizedBox(height: 22),

                        _sectionTitle("1. Acceptance of Terms"),
                        _paragraph(
                          "By accessing or using the BADHYATA platform, you agree to comply with and be bound by these Terms & Conditions. "
                          "If you do not agree, you must not use our services.",
                        ),

                        _sectionTitle("2. User Responsibilities"),
                        _paragraph(
                          "Users must provide accurate information during registration and while using the platform. "
                          "You agree not to misuse the platform, engage in fraud, or violate any applicable laws.",
                        ),
                        _bullet("Provide accurate and complete information."),
                        _bullet(
                          "Maintain confidentiality of login credentials.",
                        ),
                        _bullet("Use the platform only for lawful purposes."),
                        _bullet(
                          "Refrain from any activity that may harm, overload, or impair the platform.",
                        ),

                        _sectionTitle(
                          "3. Employer, HR, and Employee Obligations",
                        ),
                        _paragraph("All parties using the platform must:"),
                        _bullet("Communicate respectfully and professionally."),
                        _bullet(
                          "Avoid posting misleading job descriptions or personal information.",
                        ),
                        _bullet(
                          "Follow all compliance and verification guidelines.",
                        ),

                        _sectionTitle("4. Payments & Fees"),
                        _paragraph(
                          "Certain services on the BADHYATA platform may require payment. "
                          "By completing a transaction, you agree to the pricing, billing, and refund terms published on the website.",
                        ),
                        _bullet("Payments must be legitimate and authorized."),
                        _bullet(
                          "Refunds, if applicable, will follow our Refund Policy.",
                        ),
                        _bullet(
                          "BADHYATA reserves the right to modify service prices with notice.",
                        ),

                        _sectionTitle("5. KYC Verification"),
                        _paragraph(
                          "Users may be required to complete KYC as part of the verification process. "
                          "Providing false documents or impersonation will result in account suspension.",
                        ),

                        _sectionTitle("6. Content Ownership"),
                        _paragraph(
                          "All text, graphics, icons, and images on the BADHYATA platform are protected by copyright laws. "
                          "Unauthorized use, duplication, or distribution is prohibited.",
                        ),

                        _sectionTitle("7. Account Suspension & Termination"),
                        _paragraph(
                          "We may suspend or terminate accounts that violate our policies, engage in fraud, "
                          "or misuse the services. Suspended users may lose access to their data.",
                        ),

                        _sectionTitle("8. Limitation of Liability"),
                        _paragraph(
                          "BADHYATA is not liable for job disputes, hiring decisions, incorrect information posted by users, "
                          "or any losses incurred due to misuse of the platform.",
                        ),

                        _sectionTitle("9. Modifications to Terms"),
                        _paragraph(
                          "We reserve the right to update these Terms at any time. "
                          "Changes will be effective immediately upon posting on the platform.",
                        ),

                        _sectionTitle("10. Contact Information"),
                        _paragraph(
                          "If you have questions about these Terms & Conditions, reach us at:",
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "📧 support@badhyata.com\n📞 +91 98765 43210",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Helper Widgets ---

  static Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16.5,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  static Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  static Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "•  ",
            style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
