// ignore_for_file: deprecated_member_use

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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = isDesktop ? 80.0 : 16.0;
    final double verticalPadding = isDesktop ? 40.0 : 28.0;
    final double titleSize = isDesktop ? 38.0 : 26.0;
    final double subtitleSize = isDesktop ? 18.0 : 14.0;
    final double buttonWidth = isDesktop ? 260.0 : 180.0;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF4F6FF), // light background like screenshot
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -------- Title --------
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Your Career Journey Starts Here",
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // -------- Subtitle --------
          Text(
            'Access over 80,000 job opportunities for your career.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: subtitleSize,
              color: Colors.black54,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 32),

          // -------- Hero Image --------
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 760 : 360),
            child: AspectRatio(
              aspectRatio: 16 / 3, // wide banner feel
              child: Image.asset(
                'assets/hero.png', // 👈 your hero image path
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // -------- Buttons --------
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 12,
            children: [
              SizedBox(
                width: buttonWidth,
                height: 56,
                child: ElevatedButton(
                  onPressed: onHireNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Hire now',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                height: 56,
                child: ElevatedButton(
                  onPressed: onGetJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Get a job',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
