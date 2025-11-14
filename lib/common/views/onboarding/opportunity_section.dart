
// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OpportunityCategoriesSection extends StatelessWidget {
  const OpportunityCategoriesSection({super.key});

  static final List<_CategoryInfo> _categories = [
    _CategoryInfo(
      title: 'Salary Jobs',
      asset: 'assets/test_one.jpg',
      color: Color(0xFF6FB6FF),
    ),
    _CategoryInfo(
      title: 'Commission Jobs',
      asset: 'assets/test_two.jpg',
      color: Color(0xFF6EE6A6),
    ),
    _CategoryInfo(
      title: 'One-Time Gigs',
      asset: 'assets/test_two.jpg',
      color: Color(0xFF7B62E6),
    ),
    _CategoryInfo(
      title: 'Projects & Freelance',
      asset: 'assets/test_two.jpg',
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
                          SizedBox(width: 18),
                          Expanded(child: _ReferPromo()),
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
                Text(
                  'Explore all',
                  style: TextStyle(
                    color: Color(0xFF1E63B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.open_in_new, size: 18, color: Color(0xFF1E63B8)),
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
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          Container(color: widget.info.color.withOpacity(0.6)),
    );
  }
}

class _DownloadPromo extends StatelessWidget {
  const _DownloadPromo();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14.0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7FF),
        borderRadius: radius,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Download',
                  style: TextStyle(
                    color: Color(0xFF1E63B8),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Badhyata App',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Connecting Talent, Colleges, Recruiters',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _storeBadge(icon: Icons.android, label: 'Google Play'),
                    const SizedBox(width: 12),
                    _storeBadge(icon: Icons.apple, label: 'App Store'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: AspectRatio(
                aspectRatio: 9 / 7,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.asset(
                    'assets/scan.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.white30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _storeBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ReferPromo extends StatelessWidget {
  const _ReferPromo();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14.0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E6),
        borderRadius: radius,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Refer & Win',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                const Text(
                  'MacBook, iPhone, Apple Watch, AirPods, Cash Rewards and more!',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: AspectRatio(
                aspectRatio: 9 / 7,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.asset(
                    'assets/scan.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.white30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
