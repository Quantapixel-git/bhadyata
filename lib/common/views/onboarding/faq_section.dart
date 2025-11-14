import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

/// ---------- FAQ ----------
class EmployerFaqSection extends StatelessWidget {
  const EmployerFaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = const [
      [
        'How do I create an employer account with badhaya?',
        'Click “Hire Now”, complete your company details, and verify your phone number to activate your recruiter account.',
      ],
      [
        'How do I start hiring from badhyata?',
        'Post a job with your requirements. After verification, candidates matching your criteria will call you or you can call them from the database.',
      ],
      [
        'How does badhyata ensure that only Candidates matching the job criteria contact me?',
        'We use skill tags, location, experience, and salary filters; only relevant candidates see your contact options.',
      ],
      [
        'When will I start receiving Candidate responses?',
        'Usually within an hour of posting, depending on city and role demand.',
      ],
      [
        'What types of payment do you accept?',
        'UPI, net banking, credit/debit cards, and approved corporate billing in select cases.',
      ],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeading('Frequently Asked Questions (Employer)'),
          const SizedBox(height: 8),
          const Divider(height: 24),
          ...faqs.map((q) => _faqTile(q[0], q[1])).toList(),
        ],
      ),
    );
  }

  
Widget _sectionHeading(String text) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      text,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    ),
    const SizedBox(height: 6),
    Container(width: 80, height: 4, color: Colors.black),
  ],
);

  Widget _faqTile(String q, String a) => Theme(
    data: ThemeData().copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 0),
      childrenPadding: const EdgeInsets.only(left: 0, right: 0, bottom: 12),
      iconColor: AppColors.secondary,
      collapsedIconColor: AppColors.secondary,
      title: Text(
        q,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        const SizedBox(height: 6),

        // ✅ Force left alignment
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            a,
            textAlign: TextAlign.left,
            style: const TextStyle(color: Colors.black54),
          ),
        ),

        const Divider(height: 28),
      ],
    ),
  );
}