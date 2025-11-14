
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class KnowHowSection extends StatefulWidget {
  final bool isDesktop;
  const KnowHowSection({Key? key, required this.isDesktop}) : super(key: key);

  @override
  State<KnowHowSection> createState() => _KnowHowSectionState();
}

class _KnowHowSectionState extends State<KnowHowSection>
    with TickerProviderStateMixin {
  bool _expanded = false;

  final List<_CardData> _cards = [
    _CardData(
      title: 'Job Seekers',
      subtitle:
          'Find Work That Fits You: Apply to Salary Jobs, Commission Roles, One-Time Tasks & Projects.',
      image: 'assets/two.jpg',
      bullets: [
        'Explore salary-based and commission-based jobs',
        'Apply to quick one-time tasks and short gigs',
        'Work on real, paid projects',
        'Instantly apply with one-tap “Find Job” feature',
      ],
    ),

    _CardData(
      title: 'Employers & Recruiters',
      subtitle:
          'Hire Faster Than Ever: Post Jobs, Get Instant Applicants, and Build Your Workforce.',
      image: 'assets/six.jpg',
      bullets: [
        'Post salary, commission, and one-time jobs',
        'Hire instantly using the “Hire Now” mode',
        'Access verified job seekers in minutes',
        'Manage applicants with easy hiring tools',
      ],
    ),

    _CardData(
      title: 'Project Creators & Businesses',
      subtitle:
          'Get Your Work Done: Hire Skilled People for Projects, Tasks, and Short-Term Work.',
      image: 'assets/five.jpg',
      bullets: [
        'Post freelance or part-time projects',
        'Hire experts for one-time or recurring work',
        'Get applications within minutes',
        'Manage work efficiently with built-in tools',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 28,
      ),
      child: Column(
        children: [
          // Heading
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Who's using Badhyata?",
              style: TextStyle(
                fontSize: widget.isDesktop ? 20 : 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final threeAcross = constraints.maxWidth > 1000;
              if (threeAcross) {
                // Desktop: show three cards in a row
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _cards
                      .map(
                        (c) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: _KnowHowCard(
                              data: c,
                              showDetails: _expanded,
                              compact: false,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              } else {
                // Mobile/tablet: stack cards vertically
                return Column(
                  children: _cards
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: _KnowHowCard(
                            data: c,
                            showDetails: _expanded,
                            compact: !widget.isDesktop,
                          ),
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),

          const SizedBox(height: 10),

          // Show more / less (toggle)
          TextButton.icon(
            onPressed: () => setState(() => _expanded = !_expanded),
            icon: Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.secondary,
            ),
            label: Text(
              _expanded ? 'View less' : 'Know How',
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KnowHowCard extends StatelessWidget {
  final _CardData data;
  final bool compact;
  final bool showDetails;

  const _KnowHowCard({
    Key? key,
    required this.data,
    this.compact = false,
    this.showDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // card container
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: titles + optional bullets
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),

                // Animated reveal of bullets using AnimatedSize for smooth height animation
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    // When collapsed, height is zero so bullets are hidden.
                    constraints: showDetails
                        ? const BoxConstraints()
                        : const BoxConstraints(maxHeight: 0),
                    child: Opacity(
                      opacity: showDetails ? 1 : 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.bullets
                            .map(
                              (b) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 18,
                                      color: AppColors.secondary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        b,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Right: small rounded image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 84,
              height: 84,
              color: Colors.grey.shade100,
              child: data.image != null
                  ? Image.asset(
                      data.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.black26),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardData {
  final String title;
  final String subtitle;
  final String? image;
  final List<String> bullets;
  _CardData({
    required this.title,
    required this.subtitle,
    this.image,
    required this.bullets,
  });
}
