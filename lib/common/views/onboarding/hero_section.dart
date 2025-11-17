// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class HeroUnstopStyle extends StatefulWidget {
  final bool isDesktop;
  final VoidCallback? onHireNow;
  final VoidCallback? onGetJob;

  const HeroUnstopStyle({
    required this.isDesktop,
    this.onHireNow,
    this.onGetJob,
    super.key,
  });

  @override
  State<HeroUnstopStyle> createState() => _HeroUnstopStyleState();
}

class _HeroUnstopStyleState extends State<HeroUnstopStyle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final List<_TileData> _tiles = [
    _TileData(
      'Salary Jobs',
      'Fixed Pay\nOpportunities',
      'assets/one.png',
      Color(0xFFBFEAD2),
    ),
    _TileData(
      'Commission Jobs',
      'Earn Based\nOn Performance',
      'assets/two.jpg',
      Color(0xFFF9D7C6),
    ),
    _TileData(
      'One-Time Jobs',
      'Quick\nShort Tasks',
      'assets/three.png',
      Color(0xFFD6E8FF),
    ),
    _TileData(
      'Projects',
      'Work On\nReal Projects',
      'assets/four.png',
      Color(0xFFEBD7FF),
    ),
    _TileData(
      'Hire Now',
      'Find Talent\nInstantly',
      'assets/five.jpg',
      Color(0xFFFDE7B5),
    ),
    _TileData(
      'Find Jobs',
      'Explore\nAll Openings',
      'assets/six.jpg',
      Color(0xFFFFD7E0),
    ),
  ];

  final Set<int> _hovered = {};

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // start the staggered entrance
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = widget.isDesktop ? 64.0 : 20.0;
    final topPadding = widget.isDesktop ? 32.0 : 28.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ).copyWith(top: topPadding, bottom: 48),
      child: widget.isDesktop
          ? _desktopLayout(context)
          : _mobileLayout(context),
    );
  }

  Widget _desktopLayout(BuildContext context) {
    final left = Expanded(
      flex: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 22),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Unlock ',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1.0,
                  ),
                ),
                TextSpan(
                  text: 'Your Career',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const SizedBox(
            width: 560,
            child: Text(
              'Explore opportunities from across the globe to grow, showcase skills, gain CV points & get hired by your dream company.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: widget.onHireNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Hire now',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(width: 14),
              OutlinedButton(
                onPressed: widget.onGetJob,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Get a job',
                  style: TextStyle(fontSize: 18, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final right = Expanded(
      flex: 10,
      child: SizedBox(
        height: 360,
        child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 720,
            child: _AnimatedTileGrid(
              tiles: _tiles,
              controller: _ctrl,
              hoveredSet: _hovered,
              onHoverChanged: (index, hover) {
                setState(() {
                  if (hover) {
                    _hovered.add(index);
                  } else {
                    _hovered.remove(index);
                  }
                });
              },
            ),
          ),
        ),
      ),
    );

    return Row(children: [left, const SizedBox(width: 0), right]);
  }

  Widget _mobileLayout(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Unlock ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const TextSpan(
                text: 'Your Career',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Explore opportunities from across the globe to grow, showcase skills, gain CV points & get hired by your dream company.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 160,
          child: Image.asset('assets/job-removebg.png', fit: BoxFit.contain),
        ),
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: [
            ElevatedButton(
              onPressed: widget.onHireNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Hire now',
                style: TextStyle(color: Colors.white),
              ),
            ),
            OutlinedButton(
              onPressed: widget.onGetJob,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Get a job',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: _tiles
              .map(
                (t) => SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: _tileWidget(t),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _tileWidget(_TileData t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: t.bg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 76,
            height: 76,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: t.asset != null
                  ? Image.asset(
                      t.asset!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedTileGrid extends StatelessWidget {
  final List<_TileData> tiles;
  final AnimationController controller;
  final Set<int> hoveredSet;
  final void Function(int index, bool hover) onHoverChanged;

  const _AnimatedTileGrid({
    required this.tiles,
    required this.controller,
    required this.hoveredSet,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3.2,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        final start = (index * 0.08).clamp(0.0, 1.0);
        final end = (start + 0.5).clamp(0.0, 1.0);
        final anim = CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        );

        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final opacity = anim.value;
            final translateY = (1 - anim.value) * 18;
            final scale = hoveredSet.contains(index) ? 1.03 : 1.0;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, translateY),
                child: MouseRegion(
                  onEnter: (_) => onHoverChanged(index, true),
                  onExit: (_) => onHoverChanged(index, false),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 180),
                    scale: scale,
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: tiles[index].bg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tiles[index].title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tiles[index].subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 76,
                  height: 76,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: tiles[index].asset != null
                        ? Image.asset(
                            tiles[index].asset!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const SizedBox(),
                          )
                        : const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TileData {
  final String title;
  final String subtitle;
  final String? asset;
  final Color bg;
  _TileData(this.title, this.subtitle, this.asset, this.bg);
}
