// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OpportunityCategoriesSection extends StatelessWidget {
  const OpportunityCategoriesSection({super.key});

  static final List<_CategoryInfo> _categories = [
    _CategoryInfo(
      title: 'Salary Jobs',
      asset: 'assets/crslthree.jpg',
      color: Color(0xFFF6D8C6),
    ),
    _CategoryInfo(
      title: 'Commission Jobs',
      asset: 'assets/test_two.jpg',
      color: Color(0xFFF6D8C6),
    ),
    _CategoryInfo(
      title: 'One-Time Gigs',
      asset: 'assets/crslone.jpg',
      color: Color(0xFFF6D8C6),
    ),
    _CategoryInfo(
      title: 'Projects & Freelance',
      asset: 'assets/crsltwo.jpg',
      color: Color(0xFFF6D8C6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // final horizontalPadding = _responsiveHorizontalPadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: horizontalPadding,
        vertical: 20.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              const SizedBox(height: 18),

              // Responsive grid/list
              // Website-only promo section
              if (kIsWeb)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final maxW = constraints.maxWidth;
                    final cols = _columnsForWidth(maxW);
                    final spacing = 16.0;

                    // Mobile: single column list with larger touch area
                    if (cols == 1) {
                      return Column(
                        children: _categories
                            .map(
                              (c) => Padding(
                                padding: const EdgeInsets.only(bottom: 14.0),
                                child: _CategoryTile(
                                  info: c,
                                  fullWidth: true,
                                  tileHeight: 140,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }

                    // Web/tablet: grid
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, idx) => _CategoryTile(
                        info: _categories[idx],
                        fullWidth: false,
                      ),
                    );
                  },
                ),

              // const SizedBox(height: 28),

              // Promo cards already responsive; keep that behavior
              // web-only promo
              LayoutBuilder(
                builder: (context, c) {
                  final showForWidth = c.maxWidth >= 800;
                  if (!showForWidth) return const SizedBox.shrink();

                  // wide layout
                  return Column(
                    children: [
                      SizedBox(height: 28),
                      Row(
                        children: const [
                          Expanded(child: _DownloadPromo()),
                          // SizedBox(width: 18),
                          // Expanded(child: _ReferPromo()),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _columnsForWidth(double w) {
    if (w >= 1100) return 4;
    if (w >= 800) return 3;
    if (w >= 520) return 2;
    return 1;
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 420;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your Work Category',
                style: TextStyle(
                  fontSize: isSmall ? 20 : 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Explore job types that fit your goals — full-time, commission roles, quick gigs, or project-based work.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // Text(
                //   'Explore all',
                //   style: TextStyle(
                //     color: Color(0xFF1E63B8),
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                // SizedBox(width: 6),
                // Icon(Icons.open_in_new, size: 18, color: Color(0xFF1E63B8)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryInfo {
  final String title;
  final String asset;
  final Color color;
  const _CategoryInfo({
    required this.title,
    required this.asset,
    required this.color,
  });
}

class _CategoryTile extends StatefulWidget {
  final _CategoryInfo info;
  final bool fullWidth;
  final double? tileHeight;
  const _CategoryTile({
    required this.info,
    this.fullWidth = false,
    this.tileHeight,
  });

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _hover = false;

  bool get _enableHover =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14.0);

    final card = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: () => _onTapCategory(context, widget.info),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: widget.fullWidth ? widget.tileHeight ?? 140 : null,
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hover ? 0.10 : 0.04),
                blurRadius: _hover ? 16 : 8,
                offset: const Offset(0, 6),
              ),
            ],
            color: widget.info.color,
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // image layer (covers tile on larger screens; low visual priority on mobile)
              Positioned.fill(child: _buildImage(widget.info.asset)),

              // gradient overlay for text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.18),
                    ],
                  ),
                ),
              ),

              // content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.info.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'View',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Wrap with hover only on pointer-capable platforms
    return _enableHover
        ? MouseRegion(
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: card,
          )
        : card;
  }

  void _onTapCategory(BuildContext context, _CategoryInfo info) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Open "${info.title}"')));
  }

  Widget _buildImage(String path) {
    // On mobile small tiles, the background image could be low priority; we keep asset fallback
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Container(color: widget.info.color.withOpacity(0.6)),
    );
  }
}

class _DownloadPromo extends StatelessWidget {
  const _DownloadPromo();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18.0);
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 980;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF4FB), // soft pink
            Color(0xFFEAF5FF), // soft blue
          ],
        ),
      ),
      child: isNarrow
          ? Column(
              children: [
                _DownloadTextBlock(),
                const SizedBox(height: 22),
                _PhonePreviewStack(),
              ],
            )
          : Row(
              children: const [
                // LEFT: text
                Expanded(flex: 5, child: _DownloadTextBlock()),
                SizedBox(width: 24),
                // RIGHT: phones
                Expanded(flex: 5, child: _PhonePreviewStack()),
              ],
            ),
    );
  }

  // -------- store badge used below --------
  static Widget _storeBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ), // bigger
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14), // more rounded
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: Colors.black87), // bigger icon
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w900, // bolder
              fontSize: 16, // bigger text
            ),
          ),
        ],
      ),
    );
  }
}

/// LEFT SIDE: Heading + points + badges
class _DownloadTextBlock extends StatelessWidget {
  const _DownloadTextBlock();

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;

    return Column(
      crossAxisAlignment: isSmall
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (!isSmall) const SizedBox(height: 4),
        Text(
          'Download the Badhyata App',
          textAlign: isSmall ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isSmall ? 22 : 26,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Apply to jobs 3x faster, track applications,\n'
          'and get instant alerts right on your phone.',
          textAlign: isSmall ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),

        // bullet points
        Column(
          crossAxisAlignment: isSmall
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: const [],
        ),

        const SizedBox(height: 18),

        // store badges
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: isSmall ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _DownloadPromo._storeBadge(
              icon: Icons.android,
              label: 'Get it on Google Play',
            ),
            _DownloadPromo._storeBadge(
              icon: Icons.apple,
              label: 'Download on App Store',
            ),
          ],
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, size: 15, color: const Color(0xFFE91E63)),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}

/// RIGHT SIDE: stacked phone mockups using your screenshots
class _PhonePreviewStack extends StatelessWidget {
  const _PhonePreviewStack();

  @override
  Widget build(BuildContext context) {
    const String screenHome = 'assets/mobileone.png';
    const String screenJobs = 'assets/mobiletwo.png';
    const String screenSplash = 'assets/mobilethree.png';

    final w = MediaQuery.of(context).size.width;

    // Increased scale
    final scale = w < 1100 ? 1.1 : 1.25;

    // Increased phone sizes
    final sideWidth = 120.0 * scale;
    final centerWidth = 160.0 * scale;

    return SizedBox(
      height: 320 * scale, // increased
      child: Center(
        child: SizedBox(
          width: 360 * scale, // increased
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                bottom: 0,
                child: _phoneMockup(
                  imagePath: screenJobs,
                  angle: -0.12,
                  verticalPadding: 20 * scale,
                  width: sideWidth,
                  blur: 8,
                ),
              ),
              Positioned(
                left: 90 * scale,
                bottom: -20 * scale,
                child: _phoneMockup(
                  imagePath: screenHome,
                  angle: 0,
                  verticalPadding: 0,
                  width: centerWidth,
                  blur: 12,
                  highlight: true,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: _phoneMockup(
                  imagePath: screenSplash,
                  angle: 0.12,
                  verticalPadding: 20 * scale,
                  width: sideWidth,
                  blur: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _phoneMockup({
    required String imagePath,
    required double angle,
    required double verticalPadding,
    required double width,
    double blur = 8,
    bool highlight = false,
  }) {
    final borderRadius = BorderRadius.circular(26);

    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            // BoxShadow(
            //   color: Colors.black.withOpacity(highlight ? 0.25 : 0.18),
            //   blurRadius: blur,
            //   offset: const Offset(0, 10),
            // ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.white,
              child: const Icon(Icons.phone_iphone),
            ),
          ),
        ),
      ),
    );
  }
}
