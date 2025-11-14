
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

/// ---------- CATEGORIES (responsive) ----------
class HireFromCategoriesSection extends StatefulWidget {
  const HireFromCategoriesSection({super.key});

  @override
  State<HireFromCategoriesSection> createState() =>
      _HireFromCategoriesSectionState();
}

class _HireFromCategoriesSectionState extends State<HireFromCategoriesSection> {
  bool _showAll = false;

  final List<String> _categories = const [
    'Delivery',
    'Field Sales',
    'Telecalling',
    'Cook',
    'Accounts',
    'Retail',
    'Labourer',
    'Restaurant Staff',
    'Business Development',
    'Driver',
    'Back Office',
    'Security Guard',
    'Beautician',
    'Receptionist',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final isMobile = maxW < 700;

        // On mobile show a horizontal scroller by default (compact),
        // on larger screens show a centered multi-row wrap.
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeading('Hire from 50+ Job Categories'),
                const SizedBox(height: 12),
                if (isMobile && !_showAll)
                  // horizontal scroller with chips for mobile compact view
                  SizedBox(
                    height: 56,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        return _pillChip(_categories[i]);
                      },
                    ),
                  )
                else
                  // wrap for tablet/desktop or expanded mobile
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _categories.map((e) => _pillChip(e)).toList(),
                  ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _showAll = !_showAll),
                    icon: Icon(
                      _showAll ? Icons.expand_less : Icons.expand_more,
                      color: const Color(0xFF3949AB),
                    ),
                    label: Text(
                      _showAll ? 'Show less' : 'Show all',
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _pillChip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.secondary.withOpacity(0.12),
      borderRadius: BorderRadius.circular(100),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: AppColors.secondary,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

/// ---------- CITIES (responsive) ----------
class HireFromCitiesSection extends StatefulWidget {
  const HireFromCitiesSection({super.key});

  @override
  State<HireFromCitiesSection> createState() => _HireFromCitiesSectionState();
}

class _HireFromCitiesSectionState extends State<HireFromCitiesSection> {
  bool _showAll = false;

  final List<String> _topCities = const [
    'Mumbai',
    'Delhi / NCR',
    'Pune',
    'Ahmedabad',
    'Bengaluru',
    'Chennai',
    'Kolkata',
    'Lucknow',
    'Hyderabad',
    'Surat',
  ];

  final List<String> _moreCities = const [
    'Jaipur',
    'Indore',
    'Nagpur',
    'Chandigarh',
    'Patna',
    'Bhopal',
    'Noida',
    'Gurugram',
    'Thane',
    'Nashik',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final isMobile = maxW < 700;
        final chips = _showAll ? [..._topCities, ..._moreCities] : _topCities;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeading('Hire from 750+ Cities'),
                const SizedBox(height: 12),
                if (isMobile && !_showAll)
                  // compact horizontal scroller on mobile
                  SizedBox(
                    height: 56,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: chips.length,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        return _cityChip(chips[i]);
                      },
                    ),
                  )
                else
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: chips.map((c) => _cityChip(c)).toList(),
                  ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _showAll = !_showAll),
                    icon: Icon(
                      _showAll ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.secondary,
                    ),
                    label: Text(
                      _showAll ? 'Show less' : 'Show all',
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _cityChip(String text, {bool outlined = false, VoidCallback? onTap}) {
    final bg = outlined ? Colors.white : AppColors.secondary.withOpacity(0.12);
    final br = outlined ? AppColors.secondary : Colors.transparent;
    final fg = AppColors.secondary;

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: br, width: 1.2),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600),
      ),
    );

    return onTap == null
        ? chip
        : InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: onTap,
            child: chip,
          );
  }
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
