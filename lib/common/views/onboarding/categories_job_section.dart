import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class HireFromCategoriesSection extends StatefulWidget {
  const HireFromCategoriesSection({super.key});

  @override
  State<HireFromCategoriesSection> createState() =>
      _HireFromCategoriesSectionState();
}

class _HireFromCategoriesSectionState extends State<HireFromCategoriesSection> {
  bool _showAll = false;

  // 👇 update image paths to your real assets
  final List<_CategoryItem> _categories = const [
    _CategoryItem('Delivery', 'assets/three.png'),
    _CategoryItem('Field Sales', 'assets/three.png'),
    _CategoryItem('Telecalling', 'assets/three.png'),
    _CategoryItem('Cook', 'assets/three.png'),
    _CategoryItem('Accounts', 'assets/three.png'),
    _CategoryItem('Retail', 'assets/three.png'),
    _CategoryItem('Labourer', 'assets/three.png'),
    _CategoryItem('Restaurant Staff', 'assets/three.png'),
    _CategoryItem('Business Development', 'assets/three.png'),
    _CategoryItem('Driver', 'assets/three.png'),
    _CategoryItem('Back Office', 'assets/three.png'),
    _CategoryItem('Security Guard', 'assets/three.png'),
    _CategoryItem('Beautician', 'assets/three.png'),
    _CategoryItem('Receptionist', 'assets/three.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final isMobile = maxW < 700;
        final isTablet = maxW >= 700 && maxW < 1100;

        final crossAxisCount = isMobile
            ? 1
            : isTablet
            ? 2
            : 3;

        // wider, pill-like cards (similar to your reference UI)
        final cardAspectRatio = isMobile
            ? 3.0
            : isTablet
            ? 3.4
            : 3.8;

        // show first 6 by default, all when expanded
        final visibleCategories = _showAll
            ? _categories
            : _categories.take(6).toList();

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _sectionHeading('Hire from 50+ Job Categories'),
                  const SizedBox(height: 24),

                  // grid of wide cards
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visibleCategories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: cardAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final item = visibleCategories[index];
                      return _categoryCard(item, isMobile);
                    },
                  ),

                  const SizedBox(height: 20),

                  if (_categories.length > 6)
                    TextButton.icon(
                      onPressed: () => setState(() => _showAll = !_showAll),
                      icon: Icon(
                        _showAll ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.secondary,
                      ),
                      label: Text(
                        _showAll
                            ? 'Show fewer categories'
                            : 'Show all categories',
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _categoryCard(_CategoryItem item, bool isMobile) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // TODO: handle tap
        },
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFFFEF8F2), // soft cream like reference UI
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withOpacity(0.03)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              // icon circle
              Container(
                height: isMobile ? 42 : 46,
                width: isMobile ? 42 : 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: ClipOval(
                  child: Image.asset(
                    item.assetPath,
                    fit: BoxFit.contain,
                    width: isMobile ? 26 : 28,
                    height: isMobile ? 26 : 28,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.category,
                      size: isMobile ? 22 : 24,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   'Hire for',
                    //   style: TextStyle(
                    //     fontSize: isMobile ? 12 : 13,
                    //     color: Colors.black54,
                    //   ),
                    // ),
                    const SizedBox(height: 2),
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// simple model for category
class _CategoryItem {
  final String name;
  final String assetPath;

  const _CategoryItem(this.name, this.assetPath);
}

// ---------- centered heading like your location component ----------
Widget _sectionHeading(String text) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    ),
    const SizedBox(height: 8),
    Container(
      width: 80,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
    ),
  ],
);
