

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class OurNumbersSection extends StatelessWidget {
  const OurNumbersSection({super.key});

  final List<_NumberItem> _items = const [
    _NumberItem(value: 27000000, shortLabel: '27 M+', label: 'Job Seekers'),
    _NumberItem(
      value: 22300000,
      shortLabel: '22.3 M+',
      label: 'Applications Submitted',
    ),
    _NumberItem(
      value: 130000,
      shortLabel: '130 K+',
      label: 'Live Job Listings',
    ),
    _NumberItem(value: 800, shortLabel: '800+', label: 'Companies Hiring'),
    _NumberItem(
      value: 42000,
      shortLabel: '42 K+',
      label: 'Verified Recruiters',
    ),
    _NumberItem(value: 78, shortLabel: '78+', label: 'Cities Covered'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 1000;
    final isTablet = width > 700 && width <= 1000;
    final itemWidth = isWide
        ? 180.0
        : isTablet
        ? 150.0
        : double.infinity;
    final spacing = isWide ? 20.0 : 14.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
      child: Column(
        children: [
          // Optional heading
          Text(
            "Our Numbers",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 14),
          // Cards row
          Wrap(
            alignment: WrapAlignment.center,
            spacing: spacing,
            runSpacing: spacing,
            children: _items.map((i) {
              return SizedBox(
                width: itemWidth,
                child: _NumberCard(
                  item: i,
                  animateDuration: const Duration(milliseconds: 1600),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _NumberItem {
  final int value;
  final String shortLabel;
  final String label;
  const _NumberItem({
    required this.value,
    required this.shortLabel,
    required this.label,
  });
}
class _NumberCard extends StatefulWidget {
  final _NumberItem item;
  final Duration animateDuration;
  const _NumberCard({
    required this.item,
    required this.animateDuration,
  });

  @override
  State<_NumberCard> createState() => _NumberCardState();
}

class _NumberCardState extends State<_NumberCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  // We'll animate a double from 0 -> value
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animateDuration,
      vsync: this,
    );
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    // start animation on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(num value) {
    // Format to human readable with K/M and keep trailing decimals if needed
    if (value >= 1000000) {
      final v = value / 1000000;
      final str = v.toStringAsFixed(v >= 10 ? 0 : (v >= 1 ? 1 : 2));
      return '$str M+';
    } else if (value >= 1000) {
      final v = value / 1000;
      final str = v.toStringAsFixed(v >= 10 ? 0 : (v >= 1 ? 1 : 2));
      return '$str K+';
    } else {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
   
    final accent =
        Colors.blue.shade700; // change to AppColors.secondary if you prefer

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        final value = (widget.item.value * _anim.value).round();
        // For short large-number visual we will prefer shortLabel if animation close to final
        final display = _anim.value > 0.98
            ? widget.item.shortLabel
            : _formatNumber(value);
        return childWithValue(context, display, accent);
      },
      child: childWithValue(
        context,
        _formatNumber(0),
        Colors.blue.shade700,
      ), // initial child (unused)
    );
  }

  Widget childWithValue(BuildContext context, String display, Color accent) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // number row (big + colored suffix)
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _buildNumberParts(display, accent, context),
          ),
          const SizedBox(height: 8),
          Text(
            widget.item.label,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // Make the big number by splitting numeric part and suffix for color accent
  List<Widget> _buildNumberParts(
    String display,
    Color accent,
    BuildContext context,
  ) {
    // examples: "27 M+" or "22.3 M+" or "800 +" or "78 +"
    final rx = RegExp(r'^([0-9,.]+)\s*([A-Za-z\+\s]*)$');
    final m = rx.firstMatch(display);
    String main = display;
    String suffix = '';
    if (m != null) {
      main = m.group(1) ?? display;
      suffix = (m.group(2) ?? '').trim();
    }

    return [
      Text(
        main,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      if (suffix.isNotEmpty) const SizedBox(width: 6),
      if (suffix.isNotEmpty)
        Transform.translate(
          offset: const Offset(0, -2),
          child: Text(
            suffix,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
        ),
    ];
  }
}
