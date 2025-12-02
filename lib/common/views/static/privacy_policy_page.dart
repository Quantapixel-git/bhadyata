import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        titleSpacing: 0,
        title: Row(
          children: [
            // If you have a logo, use it here
            // const CircleAvatar(
            //   radius: 14,
            //   backgroundImage: AssetImage('assets/job_bgr.png'),
            // ),
            // const SizedBox(width: 8),
            Text(
              'BADHYATA',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
              ),
            ),
            const SizedBox(width: 12),
            Container(width: 1, height: 24, color: Colors.grey.shade300),
            const SizedBox(width: 12),
            const Text(
              'Privacy Policy',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 960;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ───────── Left: Table of contents (only on wide screens)
                  if (isWide)
                    SizedBox(
                      width: 260,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'On this page',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _tocItem('1. Introduction'),
                              _tocItem('2. Information We Collect'),
                              _tocItem('3. How We Use Your Information'),
                              _tocItem('4. Cookies & Tracking'),
                              _tocItem('5. Data Sharing'),
                              _tocItem('6. Data Retention & Security'),
                              _tocItem('7. Your Rights'),
                              _tocItem('8. Changes to this Policy'),
                              _tocItem('9. Contact Us'),
                            ],
                          ),
                        ),
                      ),
                    ),

                  if (isWide) const SizedBox(width: 20),

                  // ───────── Right: Main content
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(26, 26, 26, 32),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header block
                              Text(
                                'Privacy Policy',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Last updated: 02 December 2025',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 18),
                              Container(
                                width: 60,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.primary.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 24),

                              _sectionTitle('1. Introduction'),
                              _sectionBody(
                                'We value your privacy and are committed to protecting your personal data. '
                                'This Privacy Policy explains how we collect, use, store, and protect your information '
                                'when you use our platform, website, and related services.',
                              ),

                              _sectionTitle('2. Information We Collect'),
                              _sectionBody(
                                'Depending on how you use our platform, we may collect the following types of information:',
                              ),
                              _bulletList([
                                'Contact information such as your name, email address, and phone number.',
                                'Profile details that you provide while creating or updating your account.',
                                'Usage data including pages visited, actions taken, and technical device information.',
                                'Communication data such as queries, feedback, and support interactions.',
                              ]),

                              _sectionTitle('3. How We Use Your Information'),
                              _sectionBody(
                                'Your personal data is used strictly for legitimate business purposes, including:',
                              ),
                              _numberedList([
                                'Creating and managing your account on our platform.',
                                'Providing, maintaining, and improving our products and services.',
                                'Communicating with you regarding updates, notifications, and support.',
                                'Monitoring usage, preventing fraud, and ensuring the security of our systems.',
                              ]),

                              _sectionTitle(
                                '4. Cookies & Tracking Technologies',
                              ),
                              _sectionBody(
                                'We may use cookies and similar technologies to remember your preferences, analyze '
                                'how our platform is used, and enhance your overall experience. You can manage or '
                                'disable cookies through your browser settings. However, some features may not function '
                                'properly if cookies are disabled.',
                              ),

                              _sectionTitle('5. Data Sharing & Third Parties'),
                              _sectionBody(
                                'We do not sell your personal information. We may, however, share data with:',
                              ),
                              _bulletList([
                                'Service providers who assist us in operating and improving our platform.',
                                'Regulatory or governmental authorities where required by applicable law.',
                                'Other parties, only where you have provided explicit consent.',
                              ]),

                              _sectionTitle('6. Data Retention & Security'),
                              _sectionBody(
                                'We retain your information only for as long as it is necessary to fulfill the purposes '
                                'outlined in this Policy or as required by law. We apply appropriate technical and '
                                'organizational safeguards to protect your data from unauthorized access, loss, or misuse.',
                              ),

                              _sectionTitle('7. Your Rights'),
                              _sectionBody(
                                'Subject to applicable laws, you may have the right to:',
                              ),
                              _bulletList([
                                'Request access to the personal data we hold about you.',
                                'Request correction of inaccurate or incomplete information.',
                                'Request deletion of your account and associated data, subject to legal obligations.',
                                'Withdraw consent where processing is based on your consent.',
                              ]),

                              _sectionTitle('8. Changes to This Policy'),
                              _sectionBody(
                                'We may update this Privacy Policy from time to time to reflect changes in our practices '
                                'or legal requirements. The updated version will be indicated by a revised “Last updated” '
                                'date and will be effective as soon as it is made available.',
                              ),

                              _sectionTitle('9. Contact Us'),
                              _sectionBody(
                                'If you have any questions or concerns about this Privacy Policy or our data practices, '
                                'you can reach us at:',
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'support@badhyata.com',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 32),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Thank you for trusting BADHYATA.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[700],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  // ───────── Helper widgets for clean sections / lists

  static Widget _tocItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 6),
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

  static Widget _sectionBody(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14.2, height: 1.6, color: Colors.grey[800]),
    );
  }

  static Widget _bulletList(List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(fontSize: 14.2, height: 1.6),
                    ),
                    Expanded(
                      child: Text(
                        e,
                        style: TextStyle(
                          fontSize: 14.2,
                          height: 1.6,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static Widget _numberedList(List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final text = entry.value;
          return Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$index. ',
                  style: const TextStyle(fontSize: 14.2, height: 1.6),
                ),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14.2,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
