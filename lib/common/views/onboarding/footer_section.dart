
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class WorkIndiaFooter extends StatelessWidget {
  const WorkIndiaFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;
    final isMobile = width < 600;

    return Container(
      width: double.infinity,
      color: AppColors.secondary,
      child: Column(
        children: [
          // TOP: main content area
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 40,
              vertical: isMobile ? 28 : 40,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isDesktop ? _desktopLayout() : _stackedLayout(isMobile),
            ),
          ),

          // BOTTOM: small copyright row
          Container(
            width: double.infinity,
            color: AppColors.secondary,
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 16 : 20,
              horizontal: isMobile ? 16 : 40,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '© 2025 Badhyata Private Limited. All Rights Reserved.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isMobile ? 12 : 14,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 12,
                    children: [
                      _footerLinkSmall('Privacy'),
                      _footerLinkSmall('Terms'),
                      _footerLinkSmall('Sitemap'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- desktop two-column layout ----------------
  Widget _desktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left narrow column (contact, newsletter, apps)
        SizedBox(width: 320, child: _leftContactColumn()),

        const SizedBox(width: 32),

        // Right wide column (links grid)
        Expanded(child: _rightLinksGrid(isMobile: false)),
      ],
    );
  }

  // ---------------- stacked layout for tablet/mobile ----------------
  Widget _stackedLayout(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _leftContactColumn(),
        const SizedBox(height: 24),
        _rightLinksGrid(isMobile: isMobile),
      ],
    );
  }

  // Left column content
  Widget _leftContactColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Badhyata',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        SizedBox(height: 20),
        // logo + tagline
        Row(
          children: [
            // Replace with your logo asset if you have one
            // Container(
            //   width: 48,
            //   height: 48,
            //   decoration: const BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.circle,
            //   ),
            //   child: Center(
            //     child: Text(
            //       'B',
            //       style: TextStyle(
            //         color: AppColors.secondary,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Built with ❤️ in India',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Stay Connected (sales/support)
        const Text(
          'Stay Connected',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text('Sales Inquiries', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        Row(
          children: const [
            Icon(Icons.mail_outline, size: 16, color: Colors.white70),
            SizedBox(width: 8),
            Text('sales@badhyata.com', style: TextStyle(color: Colors.white70)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.phone, size: 16, color: Colors.white70),
            SizedBox(width: 8),
            Text('+91-XXXXXXXXXX', style: TextStyle(color: Colors.white70)),
          ],
        ),

        const SizedBox(height: 18),
        const Text(
          'Support Inquiries',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 6),
        Row(
          children: const [
            Icon(Icons.mail_outline, size: 16, color: Colors.white70),
            SizedBox(width: 8),
            Text(
              'support@badhyata.com',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Social icons row
        Row(
          children: [
            _SocialIcon(icon: Icons.sensor_occupied),
            SizedBox(width: 10),
            _SocialIcon(icon: Icons.flight_takeoff_outlined),
            SizedBox(width: 10),
            _SocialIcon(icon: Icons.facebook),
            SizedBox(width: 10),
            _SocialIcon(icon: Icons.telegram),
            SizedBox(width: 10),
            _SocialIcon(icon: Icons.camera_alt),
          ],
        ),

        const SizedBox(height: 22),

        // Newsletter subscription
        const Text(
          'Stay Updated',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          "We'll send you updates on the latest opportunities to showcase your talent and get hired and rewarded regularly.",
          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Subscribe to our newsletter!',
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.send, color: Colors.blue),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // App badges (replace assets with your files)
        Row(
          children: [
            _appBadge('assets/google_play_badge.png', 'Play'),
            const SizedBox(width: 12),
            _appBadge('assets/app_store_badge.png', 'App'),
          ],
        ),
      ],
    );
  }

  // Right links grid (multi column)
  // ---------------- replace the _rightLinksGrid() method with this ----------------

  /// Right links grid — responsive: multi-column on wide screens, accordion on mobile.
  Widget _rightLinksGrid({required bool isMobile}) {
    // Define your columns here (same data as before)
    final columns = <Map<String, List<String>>>[
      {
        'For Employers': [
          'Post a Job (Salary)',
          'Post Commission Role',
          'Post a One-Time Job / Gig',
          'Post a Project / Contract',
          'Hire Now (Instant)',
          'Employer Dashboard',
        ],
      },
      {
        'For Job Seekers': [
          'Find Jobs',
          'Find Commission Roles',
          'Browse Gigs & Microtasks',
          'Explore Projects',
          'Upload Resume',
          'Saved Jobs',
        ],
      },
      // {
      //   'Products & Tools': [
      //     'Applicant Screening',
      //     'Skill Assessments',
      //     'Interview Scheduling',
      //     'Hiring Automation',
      //     'Talent Recommendations',
      //   ],
      // },
      {
        'Resources': [
          'Blog & Career Tips',
          'Interview Prep Guides',
          'Freelancer Pricing Guide',
          'Employer Best Practices',
        ],
      },
      {
        'Company': [
          'About Us',
          'Careers at Badhyata',
          'Press & Media',
          'Contact Sales',
        ],
      },
    ];

    // MOBILE: show as ExpansionTiles (accordion) for easier reading & taps
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use ExpansionTile per column for mobile
          ...columns.map((col) {
            final title = col.keys.first;
            final items = col.values.first;
            return Theme(
              // make the ExpansionTile header white text on colored background
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 6,
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                collapsedIconColor: Colors.white70,
                iconColor: Colors.white,
                childrenPadding: const EdgeInsets.only(
                  left: 6,
                  right: 6,
                  bottom: 12,
                ),
                children: items
                    .map(
                      (it) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            it,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          }).toList(),

          const SizedBox(height: 12),

          // Our Properties (compact mobile layout)
          const Text(
            'Our Properties',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _footerLinkSmall('Badhyata Blog'),
              _footerLinkSmall('Employer Help Center'),
              _footerLinkSmall('Pricing & Plans'),
              _footerLinkSmall('Affiliate Program'),
              _footerLinkSmall('Community Forum'),
            ],
          ),
        ],
      );
    }

    // DESKTOP / TABLET: multi-column grid (keeps original content but tuned spacing)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columns.map((col) {
            final title = col.keys.first;
            final items = col.values.first;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: _LinkColumn(title: title, items: items),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Our Properties row (smaller links)
        const Text(
          'Our Properties',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 20,
          runSpacing: 10,
          children: [
            _footerLinkSmall('Badhyata Blog'),
            _footerLinkSmall('Employer Help Center'),
            _footerLinkSmall('Pricing & Plans'),
            _footerLinkSmall('Affiliate Program'),
            _footerLinkSmall('Community Forum'),
          ],
        ),
      ],
    );
  }

  // small app badge helper
  Widget _appBadge(String assetPath, String alt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // try to load asset, fallback to icon
          SizedBox(
            height: 28,
            width: 28,
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.mobile_friendly, color: Colors.white70),
            ),
          ),
          const SizedBox(width: 8),
          Text(alt, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

// small footer inline link (white small)
Widget _footerLinkSmall(String t) => InkWell(
  onTap: () {},
  child: Text(
    t,
    style: const TextStyle(
      color: Colors.white70,
      fontSize: 13,
      decoration: TextDecoration.underline,
    ),
  ),
);

class _SocialIcon extends StatelessWidget {
  // ignore: unused_element_parameter
  const _SocialIcon({required this.icon, this.small = false});
  final IconData icon;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: small ? 18 : 22,
      backgroundColor: Colors.white24,
      child: Icon(icon, color: Colors.white, size: small ? 18 : 22),
    );
  }
}

class _LinkColumn extends StatelessWidget {
  const _LinkColumn({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const _AccentUnderline(),
        SizedBox(height: isMobile ? 8 : 10),
        ...items.map(
          (e) => Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 4 : 6),
            child: InkWell(
              onTap: () {},
              child: Text(
                e,
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontSize: isMobile ? 13 : 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class _AccentUnderline extends StatelessWidget {
  const _AccentUnderline();

  @override
  Widget build(BuildContext context) =>
      Container(width: 90, height: 4, color: const Color(0xFFFFC107));
}

