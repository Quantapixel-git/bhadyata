import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';
import 'package:jobshub/users/home_page.dart'; // for AppDrawer

class UserHelpSupportPage extends StatelessWidget {
  const UserHelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy FAQ data
    final List<Map<String, String>> faqList = [
      {
        "question": "How to apply for jobs?",
        "answer":
            "Learn the step-by-step process to apply for jobs. Go to the job details page and click 'Apply'."
      },
      {
        "question": "Payment & Subscription",
        "answer":
            "Get information about payments and premium features. You can manage subscriptions from your profile."
      },
      {
        "question": "Profile Issues",
        "answer":
            "Resolve issues related to profile, resume, and account. Make sure your details are complete and correct."
      },
      {
        "question": "Contact Support",
        "answer":
            "Reach out to our support team for assistance via email or chat within the app."
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = kIsWeb && constraints.maxWidth > 800;

        if (isWeb) {
          // 💻 Web layout with sidebar
          return Scaffold(
            body: Row(
              children: [
                const AppDrawer(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: _buildFAQList(faqList),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // 📱 Mobile layout with AppBar
          double horizontalPadding =
              constraints.maxWidth <= 600 ? 16 : constraints.maxWidth * 0.2;

          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "Help & Support",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: AppColors.primary,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: _buildFAQList(faqList),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildFAQList(List<Map<String, String>> faqList) {
    return Column(
      children: faqList.map((faq) {
        return HoverCard(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ExpansionTile(
              leading:
                  const Icon(Icons.help_outline, color: AppColors.primary),
              title: Text(
                faq["question"]!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(faq["answer"]!),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ----------------- HoverCard Widget -----------------
class HoverCard extends StatefulWidget {
  final Widget child;
  const HoverCard({super.key, required this.child});

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform:
            isHovered ? Matrix4.translationValues(0, -4, 0) : Matrix4.identity(),
        child: widget.child,
      ),
    );
  }
}
