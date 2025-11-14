
import 'package:flutter/material.dart';

class ExpandableFeatureCards extends StatefulWidget {
  const ExpandableFeatureCards({Key? key}) : super(key: key);

  @override
  State<ExpandableFeatureCards> createState() => _ExpandableFeatureCardsState();
}

class _ExpandableFeatureCardsState extends State<ExpandableFeatureCards> {
  // Which card is expanded (centered by default)
  int _expandedIndex = 1;
  // optional "locked" index when tapping on mobile (not required)
  int _lockedIndex = -1;

  final List<_FeatureItem> items = const [
    _FeatureItem(
      title: 'Salary Jobs',
      subtitle: 'Stable roles with fixed monthly or annual pay.',
      badge: 'Fixed Pay',
      imageAsset: 'assets/one.png',
      color: Color(0xFFE8F1FF),
      icon: Icons.attach_money,
    ),
    _FeatureItem(
      title: 'Commission Roles',
      subtitle: 'Performance-driven roles — earn based on sales or targets.',
      badge: 'Earn by Performance',
      imageAsset: 'assets/two.jpg',
      color: Color(0xFFFFE1EB),
      icon: Icons.percent,
    ),
    _FeatureItem(
      title: 'One-Time Jobs (Gigs)',
      subtitle: 'Short tasks and one-off gigs — quick payouts, flexible hours.',
      badge: 'Quick Gigs',
      imageAsset: 'assets/three.png',
      color: Color(0xFFF0E9FF),
      icon: Icons.flash_on,
    ),
    _FeatureItem(
      title: 'Projects & Contracts',
      subtitle: 'Project-based work — hire freelancers or offer your services.',
      badge: 'Post a Project',
      imageAsset: 'assets/four.png',
      color: Color(0xFFFEF3D6),
      icon: Icons.work,
    ),
  ];

  void _onHover(int idx, bool hovering) {
    // if tapped/locked on mobile ignore hover
    if (_lockedIndex != -1) return;
    setState(() => _expandedIndex = hovering ? idx : 1);
  }

  void _onTap(int idx) {
    // lock / unlock behaviour for mobile; desktop will just expand on hover
    setState(() {
      if (_lockedIndex == idx) {
        _lockedIndex = -1;
        _expandedIndex = 1;
      } else {
        _lockedIndex = idx;
        _expandedIndex = idx;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isNarrow = w < 820;

    if (isNarrow) {
      return _buildMobileCarousel(context);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Find Work: Salary, Commission, Gigs & Projects',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore salary jobs, commission roles, one-time gigs and project contracts — apply, get hired or post work instantly.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 18),

          // This box holds the animated cards; fixed height prevents vertical overflows
          SizedBox(
            height: 320,
            child: ClipRect(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final total = constraints.maxWidth;
                  const gap = 12.0;
                  final count = items.length;
                  final gapsTotal = gap * (count - 1);

                  // Minimum widths so cards never become tiny
                  const minCollapsed = 96.0;
                  const minExpanded = 180.0;
                  final idealExpanded = (total * 0.52).clamp(
                    minExpanded,
                    total - gapsTotal - (minCollapsed * (count - 1)),
                  );

                  // compute collapsed width initially
                  double remaining = total - idealExpanded - gapsTotal;
                  double collapsedWidth = (remaining / (count - 1)).clamp(
                    minCollapsed,
                    total,
                  );
                  double expandedWidth = idealExpanded;

                  // if collapsed is too small, reduce expanded to make room
                  if (collapsedWidth < minCollapsed) {
                    collapsedWidth = minCollapsed;
                    expandedWidth =
                        (total - gapsTotal - collapsedWidth * (count - 1))
                            .clamp(minExpanded, total - gapsTotal);
                  }

                  // Fallback to equal distribution if something is still invalid
                  if (expandedWidth <= 0 || collapsedWidth <= 0) {
                    final equal = (total - gapsTotal) / count;
                    expandedWidth = equal;
                    collapsedWidth = equal;
                  }

                  // Build children
                  final children = <Widget>[];
                  for (int i = 0; i < count; i++) {
                    final isExpanded = i == _expandedIndex;
                    final assigned = isExpanded
                        ? expandedWidth
                        : collapsedWidth;

                    children.add(
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 420),
                        curve: Curves.easeInOutCubic,
                        width: assigned,
                        margin: EdgeInsets.only(left: i == 0 ? 0 : gap),
                        child: MouseRegion(
                          onEnter: (_) => _onHover(i, true),
                          onExit: (_) => _onHover(i, false),
                          child: GestureDetector(
                            onTap: () => _onTap(i),
                            child: _FeatureCardResponsive(
                              data: items[i],
                              expanded: isExpanded,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCarousel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Find Work: Salary, Commission, Gigs & Projects',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Explore salary jobs, commission roles, one-time gigs and project contracts — apply, get hired or post work instantly.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 360,
            child: PageView.builder(
              itemCount: items.length,
              controller: PageController(viewportFraction: 0.94),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 6.0,
                  ),
                  child: GestureDetector(
                    onTap: () => _onTap(i),
                    child: _FeatureCardResponsive(
                      data: items[i],
                      expanded: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive card which constrains image and text to avoid forcing width/height.
class _FeatureCardResponsive extends StatelessWidget {
  final _FeatureItem data;
  final bool expanded;
  const _FeatureCardResponsive({
    Key? key,
    required this.data,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(14.0);
    final pad = expanded ? 18.0 : 12.0;
    final imageMax = expanded ? 160.0 : 110.0;

    return Material(
      color: Colors.white,
      elevation: expanded ? 10 : 3,
      borderRadius: borderRadius,
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            // left icon when collapsed
            // if (!expanded)
            //   Padding(
            //     padding: const EdgeInsets.only(right: 8.0),
            //     child: CircleAvatar(radius: 26, backgroundColor: data.color, child: Icon(data.icon, size: 26, color: Colors.black87)),
            //   ),

            // flexible text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: expanded
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: expanded ? 20 : 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    child: Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    opacity: expanded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      data.subtitle,
                      style: const TextStyle(color: Colors.black54),
                      maxLines: expanded ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // const SizedBox(height: 10),
                  // if (expanded)
                  //   ElevatedButton.icon(
                  //     onPressed: () {},
                  //     icon: const Icon(Icons.play_arrow, size: 18),
                  //     label: Text(data.badge),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.blue.shade800,
                  //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //     ),
                  //   )
                  // else
                  //   Text(data.badge, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // right image block — strongly constrained so it never forces parent's height
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: imageMax,
                maxHeight: imageMax,
                minWidth: 64,
                minHeight: 64,
              ),
              child: SizedBox(
                width: imageMax,
                height: imageMax,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: data.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      (data.imageAsset != null && data.imageAsset!.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            data.imageAsset!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.black26,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  final String title;
  final String subtitle;
  final String badge;
  final String? imageAsset;
  final Color color;
  final IconData icon;

  const _FeatureItem({
    required this.title,
    required this.subtitle,
    required this.badge,
    this.imageAsset,
    required this.color,
    required this.icon,
  });
}
