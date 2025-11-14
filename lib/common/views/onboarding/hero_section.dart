
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class HeroUnstopStyle extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback? onHireNow;
  final VoidCallback? onGetJob;

  const HeroUnstopStyle({
    required this.isDesktop,
    this.onHireNow,
    this.onGetJob,
    Key? key,
  }) : super(key: key);

  // Tile data — change asset paths to match your assets
  List<_TileData> get _tiles => [
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

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isDesktop ? 64.0 : 20.0;
    final topPadding = isDesktop ? 32.0 : 28.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ).copyWith(top: topPadding, bottom: 48),
      child: isDesktop ? _desktopLayout(context) : _mobileLayout(context),
    );
  }

  Widget _desktopLayout(BuildContext context) {
    final left = Expanded(
      flex: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // small badge
          const SizedBox(height: 22),

          // Headline with highlight on first word
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Unlock ',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
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

          // subtitle
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

          // CTAs
          Row(
            children: [
              ElevatedButton(
                onPressed: onHireNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
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
                onPressed: onGetJob,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.secondary),
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
                  style: TextStyle(fontSize: 18, color: AppColors.secondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // Right column with tiles + overlapping image
    final right = Expanded(
      flex: 10,
      child: SizedBox(
        height: 347,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // tiles grid
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 700,
                child: GridView.count(
                  crossAxisCount:
                      1, // use one column here and create rows of two items via Row in itemBuilder
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 12,
                  childAspectRatio:
                      6, // will be overridden by tile widget's height
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _buildTileRows(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Row(children: [left, const SizedBox(width: 0), right]);
  }

  // Build rows: each row contains two tiles side-by-side (right aligned like reference)
  List<Widget> _buildTileRows() {
    final rows = <Widget>[];
    for (int i = 0; i < _tiles.length; i += 2) {
      final leftTile = _tiles[i];
      final rightTile = (i + 1) < _tiles.length ? _tiles[i + 1] : null;

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              // left small spacer so tiles align to right side visually
              const SizedBox(width: 8),
              Expanded(child: _tileWidget(leftTile)),
              const SizedBox(width: 10),
              Expanded(
                child: rightTile != null
                    ? _tileWidget(rightTile)
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }
    return rows;
  }

  Widget _tileWidget(_TileData t) {
    return Container(
      // height: 500,
      // width: 200,
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
          // text block
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

          // small artwork on right (use your tile images)
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

  Widget _mobileLayout(BuildContext context) {
    return Column(
      children: [
        // Badge
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //   decoration: BoxDecoration(
        //     color: Colors.purple.shade50,
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child: const Text(
        //     'Aditya • Just Went Badhyata Pro!',
        //     style: TextStyle(fontSize: 13),
        //   ),
        // ),
        const SizedBox(height: 14),

        // Headline stacked
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Unlock ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
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

        // Illustration
        SizedBox(
          height: 160,
          child: Image.asset('assets/job-removebg.png', fit: BoxFit.contain),
        ),
        const SizedBox(height: 18),

        // CTAs
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: [
            ElevatedButton(
              onPressed: onHireNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
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
              onPressed: onGetJob,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black),
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
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // tiles stacked two-per-row
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
}

class _TileData {
  final String title;
  final String subtitle;
  final String? asset;
  final Color bg;
  _TileData(this.title, this.subtitle, this.asset, this.bg);
}
