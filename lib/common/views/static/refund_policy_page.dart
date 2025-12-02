import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class RefundPolicyPage extends StatelessWidget {
  const RefundPolicyPage({super.key});

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
          'Refund Policy',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
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
                        // Header
                        const Text(
                          "Refund Policy",
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

                        Divider(color: Colors.grey.shade300, height: 1),
                        const SizedBox(height: 22),

                        // 1. Overview
                        const Text(
                          "1. Overview",
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "This Refund Policy describes the conditions under which payments made on the Badhyata platform may be refunded. "
                          "By using our services, you agree to the terms outlined in this policy.",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.grey.shade800,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // 2. Eligibility for Refunds
                        const Text(
                          "2. Eligibility for Refunds",
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Refunds may be considered in the following cases:",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _bullet(
                          "Duplicate payment due to a technical error.",
                        ),
                        _bullet(
                          "Incorrect amount charged due to billing issues.",
                        ),
                        _bullet(
                          "Service not provided after confirmed payment, subject to verification.",
                        ),
                        _bullet(
                          "Any other valid case evaluated and approved by our support team.",
                        ),

                        const SizedBox(height: 22),

                        // 3. Non-Refundable Payments
                        const Text(
                          "3. Non-Refundable Payments",
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Payments made on the platform may not be eligible for refund in the following situations:",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _bullet(
                          "Change of mind after availing or using the service.",
                        ),
                        _bullet(
                          "Failure to meet eligibility criteria due to incorrect or incomplete information provided by the user.",
                        ),
                        _bullet(
                          "Breach of our Terms & Conditions or fraudulent activity detected.",
                        ),

                        const SizedBox(height: 22),

                        // 4. Refund Request Process
                        const Text(
                          "4. Refund Request Process",
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "To request a refund, you can reach out to our support team using the details provided on the Contact Us page. "
                          "Please include the following information:",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _bullet("Your full name and registered mobile number."),
                        _bullet("Transaction ID / Payment reference number."),
                        _bullet("Date and amount of the transaction."),
                        _bullet("Brief description of the issue and reason for refund."),

                        const SizedBox(height: 22),

                        // 5. Processing Time
                        const Text(
                          "5. Processing Time",
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Once a refund request is received, our team will review it and may contact you for additional details or verification. "
                          "If the refund is approved, it will typically be processed within 5–7 business days. "
                          "The time taken for the amount to reflect in your account may vary depending on your bank or payment provider.",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.grey.shade800,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // 6. Mode of Refund
                        const Text(
                          "6. Mode of Refund",
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Approved refunds will ordinarily be processed to the original mode of payment used at the time of the transaction. "
                          "In some cases, refunds may be issued as wallet balance or credit on the platform, depending on the nature of the service and "
                          "ongoing arrangements with payment providers.",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.grey.shade800,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // 7. Changes to this Policy
                        const Text(
                          "7. Changes to this Policy",
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "We may update this Refund Policy from time to time to reflect changes in our processes, legal requirements, or services. "
                          "Any updates will be published on this page with a revised “Last updated” date.",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.grey.shade800,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // 8. Contact for Refund Queries
                        const Text(
                          "8. Contact for Refund Queries",
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "If you have any questions regarding this Refund Policy or need support regarding a payment, "
                          "you can contact our support team at:",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "📧  support@badhyata.com\n📞  +91 98765 43210",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),
                        Text(
                          "We aim to handle all genuine refund requests fairly and transparently.",
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.5,
                            color: Colors.grey.shade700,
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

  // small helper for bullet text
  static Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ",
              style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87)),
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
