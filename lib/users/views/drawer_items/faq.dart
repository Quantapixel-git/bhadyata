import 'package:flutter/material.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/user_sidedrawer.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  // full FAQ model for better typing
  final List<_FAQ> _allFaqs = [
    _FAQ(
      question: "How to apply for jobs?",
      answer:
          "Open a job, read the details and click 'Apply'. Make sure your profile and resume are up to date before applying.",
    ),
    _FAQ(
      question: "How do I update my profile?",
      answer:
          "Go to Profile > Edit. Update fields, save changes and upload a profile image to improve your chances.",
    ),
    _FAQ(
      question: "Payment & Subscription",
      answer:
          "Manage subscriptions and payment history from Profile > Subscriptions. All transactions are listed under Payments.",
    ),
    _FAQ(
      question: "How does KYC verification work?",
      answer:
          "Upload required documents (ID, address proof) under Account > KYC. Our team will review and update your status within 48 hours.",
    ),
    _FAQ(
      question: "Profile Issues",
      answer:
          "Make sure your personal details and skills are correctly entered. If problems persist, contact support with screenshots.",
    ),
    _FAQ(
      question: "Contact Support",
      answer:
          "Use the Contact Support card on this page to email or call our team, or open an in-app chat for faster responses.",
    ),
    _FAQ(
      question: "Why was my application rejected?",
      answer:
          "Rejections may be due to mismatch in skills, budget, or missing documents. Check the rejection note (if any) for details.",
    ),
    _FAQ(
      question: "How to post a project?",
      answer:
          "Go to the 'Post Project' screen, add title/description/requirements, set the budget and publish. You can manage proposals later.",
    ),
    _FAQ(
      question: "How do I become an employer?",
      answer:
          "Sign up and complete employer onboarding: add company details and verify KYC. Employer role will be enabled after approval.",
    ),
    _FAQ(
      question: "Can I edit an application after submitting?",
      answer:
          "Currently you cannot edit a submitted application. Withdraw it and re-apply with an updated proposal if the job allows.",
    ),
    _FAQ(
      question: "How to get featured or promoted?",
      answer:
          "Featured listings are part of paid plans. Contact sales via the contact card for pricing and promotion options.",
    ),
    _FAQ(
      question: "Security & Data Privacy",
      answer:
          "We follow standard security practices. Your personal data is used only for platform functionality — check our Privacy Policy for details.",
    ),
  ];

  // filter / UI state
  List<_FAQ> _filteredFaqs = [];
  final TextEditingController _searchCtrl = TextEditingController();
  bool _expandedAll = false;

  @override
  void initState() {
    super.initState();
    _filteredFaqs = List.from(_allFaqs);
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredFaqs = List.from(_allFaqs);
      } else {
        _filteredFaqs = _allFaqs
            .where(
              (f) =>
                  f.question.toLowerCase().contains(q) ||
                  f.answer.toLowerCase().contains(q),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDrawerWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // final isWeb = constraints.maxWidth > 800;
          // Make the content span full width (user wanted full width)
          final horizontalPadding = 16.0;

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.primary, // changed as requested
              elevation: 2,
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "FAQ",
                style: TextStyle(
                  color: Colors.white, // white text
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header + search + actions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Need Assistance?",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Find answers to frequently asked questions or contact support for help.",
                              style: TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _searchCtrl,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Search FAQs, topics, keywords...',
                                        prefixIcon: const Icon(Icons.search),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // On wide screens show contact card at right
                    ],
                  ),

                  const SizedBox(height: 18),

                  // FAQ list area (full width)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    child: Column(
                      children: [
                        if (_filteredFaqs.isEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 60,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No results found.',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try different keywords or contact support for help.',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        ] else
                          ..._filteredFaqs.map((f) {
                            return HoverCard(
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                child: Theme(
                                  data: Theme.of(
                                    context,
                                  ).copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    leading: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppColors.primary
                                          .withOpacity(0.12),
                                      child: Icon(
                                        Icons.help_outline,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    title: Text(
                                      f.question,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    initiallyExpanded: _expandedAll,
                                    childrenPadding: const EdgeInsets.fromLTRB(
                                      16,
                                      0,
                                      16,
                                      16,
                                    ),
                                    children: [
                                      // ensure full-width and left-aligned answer
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Text(
                                            f.answer,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// lightweight FAQ model
class _FAQ {
  final String question;
  final String answer;
  _FAQ({required this.question, required this.answer});
}

// ----------------- HoverCard (Reused) -----------------
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
    final transform = isHovered
        ? Matrix4.translationValues(0, -6, 0)
        : Matrix4.identity();
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: transform,
        child: widget.child,
      ),
    );
  }
}
