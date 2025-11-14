
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class WhatMakesWorkIndiaBetterSection extends StatelessWidget {
  const WhatMakesWorkIndiaBetterSection({super.key});

  static final List<FeatureItemNew> _items = [
    FeatureItemNew(
      image: 'assets/hire.jpg',
      title: 'Multiple Job Types',
      desc:
          'Explore salary-based, commission-based, one-time jobs and real project opportunities—all in one place.',
    ),
    FeatureItemNew(
      image: 'assets/verify.jpg',
      title: 'Instant Apply & Quick Hiring',
      desc:
          'Apply instantly for jobs or hire talent within minutes using our fast “Hire Now” system.',
    ),
    FeatureItemNew(
      image: 'assets/calls.png',
      title: 'Smart Matching',
      desc:
          'Our system connects job seekers and employers based on skills, experience, and job type automatically.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "What makes badhyata better?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(width: 60, height: 4, color: Colors.amberAccent),
          const SizedBox(height: 36),

          /// Desktop Layout
          if (isDesktop)
            Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 24,
              spacing: 40,
              children: _items
                  .map(
                    (item) => _featureCardDesktop(
                      image: item.image,
                      title: item.title,
                      desc: item.desc,
                      width: 300,
                    ),
                  )
                  .toList(),
            )
          else
            /// Mobile Layout → Horizontal PageView with peeking cards
            SizedBox(
              height: 320,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.82),
                itemCount: _items.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final cardWidth = (width * 0.78)
                      .clamp(250.0, 340.0)
                      .toDouble();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: _featureCardMobile(
                        image: item.image,
                        title: item.title,
                        desc: item.desc,
                        width: cardWidth,
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 36),

          SizedBox(
            width: 220,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Post your Job",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Desktop Card
  Widget _featureCardDesktop({
    required String image,
    required String title,
    required String desc,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
        child: Column(
          children: [
            _assetImage(image, 120, 120),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mobile Card
  Widget _featureCardMobile({
    required String image,
    required String title,
    required String desc,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        child: Column(
          children: [
            _assetImage(image, 110, 110),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Image Loader with fallback
  Widget _assetImage(String path, double w, double h) {
    return Image.asset(
      path,
      width: w,
      height: h,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.image_not_supported,
          size: w * 0.5,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}

/// Your custom model class (as requested)
class FeatureItemNew {
  final String image;
  final String title;
  final String desc;

  const FeatureItemNew({
    required this.image,
    required this.title,
    required this.desc,
  });
}