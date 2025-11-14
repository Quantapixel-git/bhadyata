
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
      companyLogo:
          'https://upload.wikimedia.org/wikipedia/commons/0/0f/Cars24_logo.png',
      companyName: 'Cars24',
      reviewer: 'Shivendra',
      rating: 5,
      title: 'Right candidate at an affordable price',
      text:
          'badhyata took away all our work of going through resumes, calling, and hiring temp staff at an affordable price. They source the right candidate for the job. Very happy with their diligence and hard work.',
    ),
    _Review(
      companyLogo:
          'https://upload.wikimedia.org/wikipedia/commons/2/26/Justdial_logo.png',
      companyName: 'Justdial',
      reviewer: 'Madhulika',
      rating: 5,
      title: 'Amazing hiring experience',
      text:
          'badhyata has been a major contributor to our hiring requirements & have been very professional in their approach. Looking forward to continued support.',
    ),
    _Review(
      companyLogo:
          'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
      companyName: 'Amazon',
      reviewer: 'Rahul Mehta',
      rating: 5,
      title: 'Fast turnaround time',
      text:
          'We started getting relevant calls within an hour. The dashboard made it easy to track progress and close positions quickly.',
    ),
    _Review(
      companyLogo:
          'https://upload.wikimedia.org/wikipedia/commons/1/19/Swiggy_logo.png',
      companyName: 'Swiggy',
      reviewer: 'Pooja Nair',
      rating: 4,
      title: 'Great pool of candidates',
      text:
          'The candidate database is vast and filters are useful. Support team is responsive and helpful.',
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

  int get _maxPage => _pageCount - 1;
  int _pageCount = 1;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    // Show 2 cards on desktop, 1 on mobile
    final cardsPerPage = isDesktop ? 2 : 1;
    _pageCount = (_reviews.length / cardsPerPage).ceil();

    return Container(
      width: double.infinity,
      color: const Color(0xFFF4F6FF),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Employer Reviews',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Container(width: 80, height: 3, color: AppColors.secondary),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Slider
          SizedBox(
            height: isDesktop ? 280 : 300,
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
                                padding: EdgeInsets.symmetric(
                                  horizontal: isDesktop ? 12 : 6,
                                ),
                                child: _ReviewCard(review: r),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    );
                  },
                ),

                // Left arrow
                Positioned(
                  left: 8,
                  child: _NavButton(
                    icon: Icons.chevron_left,
                    enabled: _page > 0,
                    onTap: _prev,
                  ),
                ),

                // Right arrow
                Positioned(
                  right: 8,
                  child: _NavButton(
                    icon: Icons.chevron_right,
                    enabled: _page < _maxPage,
                    onTap: _next,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pageCount,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _page == i ? 20 : 8,
                decoration: BoxDecoration(
                  color: _page == i
                      ? AppColors.secondary
                      : AppColors.secondary.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final _Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Logo column
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  review.companyLogo,
                  height: 34,
                  width: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.apartment,
                    size: 34,
                    color: Colors.black38,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                review.reviewer,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                review.companyName,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(width: 18),

          // Divider
          Container(width: 1, height: double.infinity, color: Colors.black12),

          const SizedBox(width: 18),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RatingStars(rating: review.rating),
                const SizedBox(height: 10),
                Text(
                  '“${review.title}“',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
                      height: 1.4,
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

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final int rating; // 0..5

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

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, this.enabled = true, this.onTap});

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? AppColors.secondary
          : AppColors.secondary.withOpacity(0.3),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: const SizedBox(
          height: 44,
          width: 44,
          child: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ), // icon overridden below
        ),
      ),
    );
  }
}

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
