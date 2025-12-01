import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class EmployerReviewsSection extends StatefulWidget {
  const EmployerReviewsSection({super.key});

  @override
  State<EmployerReviewsSection> createState() => _EmployerReviewsSectionState();
}

class _EmployerReviewsSectionState extends State<EmployerReviewsSection> {
  late final PageController _controller;
  int _page = 0;

  final _reviews = <_Review>[
    _Review(
      companyLogo: 'assets/hero.png',
      companyName: 'Cars24',
      reviewer: 'Shivendra',
      rating: 5,
      title: 'Right candidate at an affordable price',
      text:
          'badhyata handled resume screening, calling, and hiring temp staff at an affordable price. Proper diligence and effort.',
    ),
    _Review(
      companyLogo: 'assets/hero.png',
      companyName: 'Justdial',
      reviewer: 'Madhulika',
      rating: 5,
      title: 'Amazing hiring experience',
      text:
          'Professional team & smooth hiring. They consistently support our bulk requirements.',
    ),
    _Review(
      companyLogo: 'assets/hero.png',
      companyName: 'Amazon',
      reviewer: 'Rahul Mehta',
      rating: 5,
      title: 'Fast turnaround time',
      text:
          'We got relevant candidates within an hour. Dashboard tracking made closing positions quick.',
    ),
    _Review(
      companyLogo: 'assets/hero.png',
      companyName: 'Swiggy',
      reviewer: 'Pooja Nair',
      rating: 4,
      title: 'Great pool of candidates',
      text:
          'Huge database, easy filters, and helpful support team. Good experience overall.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _maxPage => _pageCount - 1;
  int _pageCount = 1;

  void _prev() {
    if (_page > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _next() {
    if (_page < _maxPage) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final cardsPerPage = isDesktop ? 2 : 1;
    _pageCount = (_reviews.length / cardsPerPage).ceil();

    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F7FF),
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          // ------------------- CENTER HEADING -------------------
          Column(
            children: [
              const Text(
                "Employer Reviews",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Container(width: 80, height: 4, color: AppColors.secondary),
            ],
          ),

          const SizedBox(height: 38),

          // ------------------- SLIDER -------------------
          SizedBox(
            height: isDesktop ? 280 : 320,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemCount: _pageCount,
                  itemBuilder: (_, pageIndex) {
                    final start = pageIndex * cardsPerPage;
                    final end = (start + cardsPerPage).clamp(
                      0,
                      _reviews.length,
                    );
                    final slice = _reviews.sublist(start, end);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: slice
                          .map(
                            (r) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                child: _ReviewCard(review: r),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),

                // left arrow
                Positioned(
                  left: 20,
                  child: _NavButton(
                    icon: Icons.chevron_left,
                    enabled: _page > 0,
                    onTap: _prev,
                  ),
                ),

                // right arrow
                Positioned(
                  right: 20,
                  child: _NavButton(
                    icon: Icons.chevron_right,
                    enabled: _page < _maxPage,
                    onTap: _next,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ------------------- DOTS -------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pageCount,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 8,
                width: _page == i ? 22 : 10,
                decoration: BoxDecoration(
                  color: _page == i
                      ? AppColors.secondary
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- CARD -------------------
class _ReviewCard extends StatelessWidget {
  final _Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------- LOGO + NAME -------------------
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  review.companyLogo,
                  height: 36,
                  width: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                review.reviewer,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                review.companyName,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(width: 20),

          // Divider
          Container(width: 1, height: double.maxFinite, color: Colors.black12),
          const SizedBox(width: 20),

          // ------------------- REVIEW CONTENT -------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RatingStars(rating: review.rating),
                const SizedBox(height: 12),
                Text(
                  "“${review.title}“",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    review.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- STARS -------------------
class _RatingStars extends StatelessWidget {
  final int rating;
  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (i) => Icon(
          i < rating ? Icons.star : Icons.star_border,
          size: 18,
          color: const Color(0xFFFFB400),
        ),
      ),
    );
  }
}

// ------------------- ARROW BUTTON -------------------
class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const _NavButton({required this.icon, required this.enabled, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: enabled
          ? AppColors.secondary
          : AppColors.secondary.withOpacity(0.3),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          height: 46,
          width: 46,
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

// ------------------- MODEL -------------------
class _Review {
  final String companyLogo;
  final String companyName;
  final String reviewer;
  final int rating;
  final String title;
  final String text;

  _Review({
    required this.companyLogo,
    required this.companyName,
    required this.reviewer,
    required this.rating,
    required this.title,
    required this.text,
  });
}
