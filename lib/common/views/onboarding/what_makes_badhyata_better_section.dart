import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class WhatMakesWorkIndiaBetterSection extends StatelessWidget {
  const WhatMakesWorkIndiaBetterSection({super.key});

  // Locations you want to show
  static final List<String> _locations = [
    'Ariyalur',
    'Chengalpattu',
    'Chennai',
    'Coimbatore',
    'Cuddalore',
    'Dharmapuri',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // light subtle background
      decoration: const BoxDecoration(
        color: Colors.white
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [Color(0xFFFCFCFF), Color(0xFFFDF7F0)],
        // ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ----- TITLE -----
              const Text(
                'Find Jobs By Location',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 90,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Discover opportunities in top cities across India.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 32),

              // ----- GRID -----
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;
                  late int crossAxisCount;

                  if (maxW >= 1000) {
                    crossAxisCount = 3;
                  } else if (maxW >= 650) {
                    crossAxisCount = 2;
                  } else {
                    crossAxisCount = 1;
                  }

                  final aspectRatio = crossAxisCount == 1
                      ? 3.0
                      : crossAxisCount == 2
                      ? 3.2
                      : 3.6;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _locations.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 18,
                      childAspectRatio: aspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      return _LocationCard(city: _locations[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- CARD WIDGET ----------------
class _LocationCard extends StatefulWidget {
  final String city;
  const _LocationCard({required this.city});

  @override
  State<_LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<_LocationCard> {
  bool _hover = false;

  bool get _enableHover =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFFFFF7EF); // soft cream
    final hoverColor = const Color(0xFFFFF1E3);

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: _hover ? hoverColor : baseColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_hover ? 0.16 : 0.04),
            blurRadius: _hover ? 16 : 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            // TODO: handle tap: open jobs for this city
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Row(
              children: [
                // Icon circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.location_on,
                    size: 22,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 18),

                // Text
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Jobs in ',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: widget.city,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.black.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return _enableHover
        ? MouseRegion(
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: card,
          )
        : card;
  }
}
