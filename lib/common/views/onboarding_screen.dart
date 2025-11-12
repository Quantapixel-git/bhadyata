import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/auth/admin_login.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/auth/employer_login.dart';
import 'package:jobshub/hr/views/auth/hr_login_screen.dart';
import 'package:jobshub/users/views/auth/login_screen.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isDesktop ? 72 : 60),
        child: _buildStickyHeader(context, isDesktop),
      ),
      drawer: isDesktop
          ? null
          : const _MobileNavDrawer(), // 👈 burger on mobile
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroUnstopStyle(
              isDesktop: isDesktop,
              onHireNow: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployerLogin()),
                );
              },
              onGetJob: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            KnowHowSection(isDesktop: isDesktop),
            const SizedBox(height: 10),
            CompanyCarousel(
              companies: [
                'assets/companies/Amazon.png',
                'assets/companies/capgemini.png',
                'assets/companies/dell.png',
                'assets/companies/hcl.jpg',
                'assets/companies/maruti.png',
                'assets/companies/dell.png',
                'assets/companies/hcl.jpg',
                'assets/companies/maruti.png',
                'assets/companies/microsoft.jpg',
                'assets/companies/quanta.png',
              ],
              height: 40, // same height as before
              autoPlayInterval: const Duration(seconds: 3),
            ),
            const SizedBox(height: 20),
            AutoBannerSlider(
              images: [
                'assets/test.jpg',
                'assets/test2.jpg',
                'assets/test.jpg',
              ],
              desktopHeight: 290,
              mobileHeight: 180,
              autoPlayInterval: const Duration(seconds: 4),
            ),
            const SizedBox(height: 30),
            _buildStepsSection(context, isDesktop),
            const SizedBox(height: 20),
            FeaturedOpportunitiesSection(),
            const SizedBox(height: 40),
            ExpandableFeatureCards(),
            const SizedBox(height: 40),
            OpportunityCarouselSection(
              title: 'Jobs',
              subtitle:
                  'Explore the Jobs that are creating a buzz among your peers!',
              viewAllCallback: () {
                /* navigate to list */
              },
              items: sampleItems, // see below for item shape
            ),
            OpportunityCarouselSection(
              title: 'Projects',
              subtitle:
                  'Explore the Projects that are creating a buzz among your peers!',
              viewAllCallback: () {
                /* navigate to list */
              },
              items: sampleItems, // see below for item shape
            ),

            const SizedBox(height: 10),
            const CompanyMockTestsSection(),
            const SizedBox(height: 40),
            const WhatMakesWorkIndiaBetterSection(),
            const SizedBox(height: 20),
            const EmployerReviewsSection(),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, c) {
                final isNarrow = c.maxWidth < 900;
                return isNarrow
                    ? Column(
                        children: [
                          HireFromCategoriesSection(),
                          SizedBox(height: 12),
                          HireFromCitiesSection(),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: HireFromCategoriesSection()),
                          SizedBox(width: 10),
                          Expanded(child: HireFromCitiesSection()),
                        ],
                      );
              },
            ),

            // const SizedBox(height: 40),
            // const DownloadRecruiterAppSection(),
            const SizedBox(height: 40),
            OpportunityCategoriesSection(),
            const SizedBox(height: 40),
            const EmployerFaqSection(),
            OurNumbersSection(),
            const SizedBox(height: 0),
            const WorkIndiaFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader(BuildContext context, bool isDesktop) {
    return Material(
      color: Colors.white,
      elevation: 4,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 28 : 12,
            vertical: 10,
          ),
          child: Row(
            children: [
              // === MOBILE: BURGER ICON ===
              if (!isDesktop)
                Builder(
                  builder: (ctx) => IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 28,
                      color: AppColors.secondary,
                    ),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                    tooltip: "Open menu",
                  ),
                ),

              // === LOGO + BRAND ===
              InkWell(
                onTap: () {}, // navigate home
                child: Row(
                  children: [
                    Image.asset(
                      'assets/job_bgr.png',
                      height: 36,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Badhyata',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: isDesktop ? 20 : 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // === DESKTOP SEARCH BAR ===
              if (isDesktop)
                Expanded(
                  flex: 25,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black45),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search Opportunities',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              textInputAction: TextInputAction.search,
                              onSubmitted: (q) {},
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.tune, color: Colors.black45),
                            tooltip: 'Filters',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // === DESKTOP NAVIGATION ITEMS ===
              if (isDesktop)
                Row(
                  children: [
                    _HeaderTextButton(label: 'Company', onTap: () {}),
                    _HeaderTextButton(label: 'Team Lead', onTap: () {}),
                    _HeaderTextButton(
                      label: 'HR',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HrLoginPage(),
                          ),
                        );
                      },
                    ),
                    _HeaderTextButton(
                      label: 'Admin',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminLoginPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                  ],
                ),

              // === RIGHT SIDE ACTIONS (DESKTOP ONLY) ===
              if (isDesktop)
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.secondary.withOpacity(0.18),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Find a job',
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployerLogin(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Hire Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),

              // === MOBILE SEARCH ICON ONLY ===
              if (!isDesktop)
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: _DummySearchDelegate(),
                    );
                  },
                  icon: const Icon(Icons.search, size: 26),
                  tooltip: "Search",
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- COMPANIES SECTION ----------------

  // ---------------- 3 EASY STEPS SECTION ----------------
  Widget _buildStepsSection(BuildContext context, bool isDesktop) {
    final steps = [
      {
        "img": "assets/hire.jpg",
        "title": "Post a Job",
        "desc": "Tell us what you need in a candidate in just 5-minutes.",
      },
      {
        "img": "assets/verify.jpg",
        "title": "Get Verified",
        "desc": "Our team will call to verify your employer account",
      },
      {
        "img": "assets/calls.png",
        "title": "Get calls. Hire.",
        "desc":
            "You will get calls from relevant candidates within one hour or call them directly from our candidate database.",
      },
    ];

    return Column(
      children: [
        const Text(
          "Get started in 3 easy steps",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 3,
          color: const Color(0xFF1F267E),
        ), // underline accent
        const SizedBox(height: 50),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 60,
          runSpacing: 40,
          children: steps
              .asMap()
              .entries
              .map(
                (e) => Column(
                  children: [
                    Image.asset(e.value["img"]!, width: 180),
                    const SizedBox(height: 16),
                    Text(
                      "${e.key + 1}. ${e.value["title"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 220,
                      child: Text(
                        e.value["desc"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class WhatMakesWorkIndiaBetterSection extends StatelessWidget {
  const WhatMakesWorkIndiaBetterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      width: double.infinity,
      // color: AppColors.secondary, // deep indigo background
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          const Text(
            "What makes badhyata better ?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(width: 60, height: 3, color: Colors.amberAccent),

          const SizedBox(height: 60),

          // Cards layout (responsive)
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _featureCard(
                image: 'assets/hire.jpg',
                title: 'Simple Hiring',
                desc:
                    'Receive calls from qualified candidates in under an hour of posting a job',
                isDesktop: isDesktop,
              ),
              SizedBox(width: isDesktop ? 40 : 0, height: isDesktop ? 0 : 40),
              _featureCard(
                image: 'assets/verify.jpg',
                title: 'Intelligent Recommendations',
                desc:
                    'Only the best candidates are recommended by our ML as per your requirement',
                isDesktop: isDesktop,
              ),
              SizedBox(width: isDesktop ? 40 : 0, height: isDesktop ? 0 : 40),
              _featureCard(
                image: 'assets/calls.png',
                title: 'Priority customer support',
                desc: 'Prioritized customer support for the paid plan users',
                isDesktop: isDesktop,
              ),
            ],
          ),

          const SizedBox(height: 60),

          // Button
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Post your Job",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard({
    required String image,
    required String title,
    required String desc,
    required bool isDesktop,
  }) {
    return SizedBox(
      width: isDesktop ? 280 : double.infinity,
      child: Column(
        children: [
          Image.asset(image, width: 140, height: 140, fit: BoxFit.contain),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

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

/// ---------- DOWNLOAD APP BANNER ----------
class DownloadRecruiterAppSection extends StatelessWidget {
  const DownloadRecruiterAppSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      width: double.infinity,
      color: AppColors.secondary, // deep indigo background
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LEFT TEXT + QR + INPUT
            Expanded(
              flex: isWide ? 6 : 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _downloadHeading(),
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 28,
                    runSpacing: 24,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [_qrBox(), _qrBox()],
                  ),
                ],
              ),
            ),

            // RIGHT ILLUSTRATION
            if (isWide) ...[
              const SizedBox(width: 24),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/job_bgr.png', // add your mock/illustration
                    height: 320,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _downloadHeading() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text(
        'Download badhyata App',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
      SizedBox(height: 6),
      _AccentUnderline(),
    ],
  );

  Widget _qrBox() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Scan this QR code',
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
      const SizedBox(height: 10),
      Container(
        width: 160,
        height: 160,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset('assets/scan.png', fit: BoxFit.contain),
      ),
    ],
  );
}

class _AccentUnderline extends StatelessWidget {
  const _AccentUnderline();

  @override
  Widget build(BuildContext context) =>
      Container(width: 90, height: 4, color: const Color(0xFFFFC107));
}

/// ---------- FAQ ----------
class EmployerFaqSection extends StatelessWidget {
  const EmployerFaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = const [
      [
        'How do I create an employer account with badhaya?',
        'Click “Hire Now”, complete your company details, and verify your phone number to activate your recruiter account.',
      ],
      [
        'How do I start hiring from badhyata?',
        'Post a job with your requirements. After verification, candidates matching your criteria will call you or you can call them from the database.',
      ],
      [
        'How does badhyata ensure that only Candidates matching the job criteria contact me?',
        'We use skill tags, location, experience, and salary filters; only relevant candidates see your contact options.',
      ],
      [
        'When will I start receiving Candidate responses?',
        'Usually within an hour of posting, depending on city and role demand.',
      ],
      [
        'What types of payment do you accept?',
        'UPI, net banking, credit/debit cards, and approved corporate billing in select cases.',
      ],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeading('Frequently Asked Questions (Employer)'),
          const SizedBox(height: 8),
          const Divider(height: 24),
          ...faqs.map((q) => _faqTile(q[0], q[1])).toList(),
        ],
      ),
    );
  }

  Widget _faqTile(String q, String a) => Theme(
    data: ThemeData().copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 0),
      childrenPadding: const EdgeInsets.only(left: 0, right: 0, bottom: 12),
      iconColor: AppColors.secondary,
      collapsedIconColor: AppColors.secondary,
      title: Text(
        q,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        const SizedBox(height: 6),

        // ✅ Force left alignment
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            a,
            textAlign: TextAlign.left,
            style: const TextStyle(color: Colors.black54),
          ),
        ),

        const Divider(height: 28),
      ],
    ),
  );
}

/// ---------- FOOTER ----------
// import 'package:flutter/material.dart';
// import 'package:jobshub/common/utils/AppColor.dart';

class WorkIndiaFooter extends StatelessWidget {
  const WorkIndiaFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;
    final isMobile = width < 600;

    return Container(
      width: double.infinity,
      color: AppColors.secondary,
      child: Column(
        children: [
          // TOP: main content area
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 40,
              vertical: isMobile ? 28 : 40,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isDesktop ? _desktopLayout() : _stackedLayout(isMobile),
            ),
          ),

          // BOTTOM: small copyright row
          Container(
            width: double.infinity,
            color: AppColors.secondary,
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 16 : 20,
              horizontal: isMobile ? 16 : 40,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '© 2025 Badhyata Private Limited. All Rights Reserved.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isMobile ? 12 : 14,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 12,
                    children: [
                      _footerLinkSmall('Privacy'),
                      _footerLinkSmall('Terms'),
                      _footerLinkSmall('Sitemap'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- desktop two-column layout ----------------
  Widget _desktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left narrow column (contact, newsletter, apps)
        SizedBox(width: 320, child: _leftContactColumn()),

        const SizedBox(width: 32),

        // Right wide column (links grid)
        Expanded(child: _rightLinksGrid(isMobile: false)),
      ],
    );
  }

  // ---------------- stacked layout for tablet/mobile ----------------
  Widget _stackedLayout(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _leftContactColumn(),
        const SizedBox(height: 24),
        _rightLinksGrid(isMobile: isMobile),
      ],
    );
  }

  // Left column content
  Widget _leftContactColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Badhyata',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        SizedBox(height: 20),
        // logo + tagline
        Row(
          children: [
            // Replace with your logo asset if you have one
            // Container(
            //   width: 48,
            //   height: 48,
            //   decoration: const BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.circle,
            //   ),
            //   child: Center(
            //     child: Text(
            //       'B',
            //       style: TextStyle(
            //         color: AppColors.secondary,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Built with ❤️ in India',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Stay Connected (sales/support)
        const Text(
          'Stay Connected',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text('Sales Inquiries', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        Row(
          children: const [
            Icon(Icons.mail_outline, size: 16, color: Colors.white70),
            SizedBox(width: 8),
            Text('sales@badhyata.com', style: TextStyle(color: Colors.white70)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.phone, size: 16, color: Colors.white70),
            SizedBox(width: 8),
            Text('+91-XXXXXXXXXX', style: TextStyle(color: Colors.white70)),
          ],
        ),

        const SizedBox(height: 18),
        const Text(
          'Support Inquiries',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 6),
        Row(
          children: const [
            Icon(Icons.mail_outline, size: 16, color: Colors.white70),
            SizedBox(width: 8),
            Text(
              'support@badhyata.com',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Social icons row
        Row(
          children: [
            _SocialIcon(icon: Icons.sensor_occupied),
            SizedBox(width: 10),
            _SocialIcon(icon: Icons.flight_takeoff_outlined),
            SizedBox(width: 10),
            _SocialIcon(icon: Icons.facebook),
            SizedBox(width: 10),
            _SocialIcon(icon: Icons.telegram),
            SizedBox(width: 10),
            _SocialIcon(icon: Icons.camera_alt),
          ],
        ),

        const SizedBox(height: 22),

        // Newsletter subscription
        const Text(
          'Stay Updated',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          "We'll send you updates on the latest opportunities to showcase your talent and get hired and rewarded regularly.",
          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Subscribe to our newsletter!',
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.send, color: Colors.blue),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // App badges (replace assets with your files)
        Row(
          children: [
            _appBadge('assets/google_play_badge.png', 'Play'),
            const SizedBox(width: 12),
            _appBadge('assets/app_store_badge.png', 'App'),
          ],
        ),
      ],
    );
  }

  // Right links grid (multi column)
  // ---------------- replace the _rightLinksGrid() method with this ----------------

  /// Right links grid — responsive: multi-column on wide screens, accordion on mobile.
  Widget _rightLinksGrid({required bool isMobile}) {
    // Define your columns here (same data as before)
    final columns = <Map<String, List<String>>>[
      {
        'Products': [
          'Brand & Engage',
          'Source',
          'Screen',
          'Assess',
          'Interview',
          'Hiring Automation',
        ],
      },
      {
        'Participate': [
          'Competitions & Challenges',
          'Assessments',
          'Hackathons',
          'Workshops & Webinars',
          'Conferences',
          'Cultural Events',
        ],
      },
      {
        'Mentorship': [
          'Be a Mentor',
          'Explore Mentors',
          'Mentorship FAQs',
          'Mentorship Blogs',
        ],
      },
      {
        'Apply': ['Internships', 'Jobs', 'Scholarships'],
      },
      {
        'Practice': [
          '5 Days Interview Prep',
          'Code & Ace Hiring Assessments',
          '100-Day of Coding Sprint',
        ],
      },
    ];

    // MOBILE: show as ExpansionTiles (accordion) for easier reading & taps
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use ExpansionTile per column for mobile
          ...columns.map((col) {
            final title = col.keys.first;
            final items = col.values.first;
            return Theme(
              // make the ExpansionTile header white text on colored background
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 6,
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                collapsedIconColor: Colors.white70,
                iconColor: Colors.white,
                childrenPadding: const EdgeInsets.only(
                  left: 6,
                  right: 6,
                  bottom: 12,
                ),
                children: items
                    .map(
                      (it) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            it,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          }).toList(),

          const SizedBox(height: 12),

          // Our Properties (compact mobile layout)
          const Text(
            'Our Properties',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _footerLinkSmall('Unstop Talent Awards 2025'),
              _footerLinkSmall('Unstop Talent Meet 2025'),
              _footerLinkSmall('Unstop Talent Report 2025'),
              _footerLinkSmall('Education Loan EMI Calculator'),
              _footerLinkSmall('Unstop Igniters Club'),
              _footerLinkSmall('Online Quizzing Festival'),
            ],
          ),
        ],
      );
    }

    // DESKTOP / TABLET: multi-column grid (keeps original content but tuned spacing)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columns.map((col) {
            final title = col.keys.first;
            final items = col.values.first;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: _LinkColumn(title: title, items: items),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Our Properties row (smaller links)
        const Text(
          'Our Properties',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 20,
          runSpacing: 10,
          children: [
            _footerLinkSmall('Unstop Talent Awards 2025'),
            _footerLinkSmall('Unstop Talent Meet 2025'),
            _footerLinkSmall('Unstop Talent Report 2025'),
            _footerLinkSmall('Education Loan EMI Calculator'),
            _footerLinkSmall('Unstop Igniters Club'),
            _footerLinkSmall('Online Quizzing Festival'),
          ],
        ),
      ],
    );
  }

  // small app badge helper
  Widget _appBadge(String assetPath, String alt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // try to load asset, fallback to icon
          SizedBox(
            height: 28,
            width: 28,
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.mobile_friendly, color: Colors.white70),
            ),
          ),
          const SizedBox(width: 8),
          Text(alt, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

// small footer inline link (white small)
Widget _footerLinkSmall(String t) => InkWell(
  onTap: () {},
  child: Text(
    t,
    style: const TextStyle(
      color: Colors.white70,
      fontSize: 13,
      decoration: TextDecoration.underline,
    ),
  ),
);

class _SocialIcon extends StatelessWidget {
  // ignore: unused_element_parameter
  const _SocialIcon({required this.icon, this.small = false});
  final IconData icon;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: small ? 18 : 22,
      backgroundColor: Colors.white24,
      child: Icon(icon, color: Colors.white, size: small ? 18 : 22),
    );
  }
}

class _LinkColumn extends StatelessWidget {
  const _LinkColumn({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const _AccentUnderline(),
        SizedBox(height: isMobile ? 8 : 10),
        ...items.map(
          (e) => Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 4 : 6),
            child: InkWell(
              onTap: () {},
              child: Text(
                e,
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontSize: isMobile ? 13 : 14,
                ),
              ),
            ),
          ),
        ),
      ],
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

// REPLACE your _MobileNavDrawer class with this
class _MobileNavDrawer extends StatelessWidget {
  const _MobileNavDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // header: logo + quick CTAs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Image.asset(
                    'assets/job_bgr.png',
                    height: 36,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Badhyata',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Primary nav list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _drawerTile(
                    context,
                    Icons.lightbulb_outline,
                    'Company',
                    () {},
                  ),
                  _drawerTile(context, Icons.work_outline, 'Team Lead', () {}),
                  _drawerTile(context, Icons.emoji_events_outlined, 'HR', () {
                    //  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HrLoginPage()),
                    );
                    // },
                  }),
                  _drawerTile(context, Icons.school_outlined, 'Admin', () {
                    //  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminLoginPage()),
                    );
                    // },
                  }),

                  // const Divider(),
                ],
              ),
            ),

            // bottom CTAs
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Find a job'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployerLogin(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Hire Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _drawerTile(
    BuildContext ctx,
    IconData icon,
    String text,
    VoidCallback onTap,
  ) => ListTile(
    leading: Icon(icon, color: AppColors.secondary),
    title: Text(text),
    onTap: onTap,
  );
}

class _HeaderTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _HeaderTextButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// simple search delegate placeholder - replace with real search logic
class _DummySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, ''),
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) =>
      Center(child: Text('Search: $query'));

  @override
  Widget buildSuggestions(BuildContext context) => ListView(
    children: List.generate(
      6,
      (i) => ListTile(title: Text('$query suggestion $i')),
    ),
  );
}

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
      'Internships',
      'Gain Practical\nExperience',
      'assets/job-removebg.png',
      Color(0xFFBFEAD2),
    ),
    _TileData(
      'Mentorships',
      'Guidance From\nTop Mentors',
      'assets/job-removebg.png',
      Color(0xFFF9D7C6),
    ),
    _TileData(
      'Jobs',
      'Explore\nDiverse Careers',
      'assets/job-removebg.png',
      Color(0xFFD6E8FF),
    ),
    _TileData(
      'Practice',
      'Refine\nSkills Daily',
      'assets/job-removebg.png',
      Color(0xFFEBD7FF),
    ),
    _TileData(
      'Competitions',
      'Battle\nFor Excellence',
      'assets/job-removebg.png',
      Color(0xFFFDE7B5),
    ),
    _TileData(
      'More',
      'See all\nopportunities',
      'assets/job-removebg.png',
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
                onPressed: onGetJob,
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

class KnowHowSection extends StatefulWidget {
  final bool isDesktop;
  const KnowHowSection({Key? key, required this.isDesktop}) : super(key: key);

  @override
  State<KnowHowSection> createState() => _KnowHowSectionState();
}

class _KnowHowSectionState extends State<KnowHowSection>
    with TickerProviderStateMixin {
  bool _expanded = false;

  final List<_CardData> _cards = [
    _CardData(
      title: 'Students and Professionals',
      subtitle:
          'Unlock Your Potential: Compete, Build Resume, Grow and get Hired!',
      image: 'assets/job-removebg.png', // replace with your asset
      bullets: [
        'Access tailored jobs and internships',
        'Participate in exciting competitions',
        'Upskill with mentorships & workshops',
        'Showcase your profile to top recruiters',
      ],
    ),
    _CardData(
      title: 'Companies and Recruiters',
      subtitle:
          'Discover Right Talent: Hire, Engage, and Brand Like Never Before!',
      image: 'assets/job-removebg.png',
      bullets: [
        'Build employer brand with engagements',
        'Host jobs & internships to hire top talent',
        'Streamline hiring with AI-driven tools',
        'Connect with 24M GenZs based on skills',
      ],
    ),
    _CardData(
      title: 'Colleges',
      subtitle:
          'Bridge Academia and Industry: Empower Students with Real-World Opportunities!',
      image: 'assets/job-removebg.png',
      bullets: [
        'Offer top competition & job opportunities',
        'Partner with companies for placements',
        'Gain insights into student performance',
        'Foster industry-academic collaboration',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 28,
      ),
      child: Column(
        children: [
          // Heading
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Who's using Badhyata?",
              style: TextStyle(
                fontSize: widget.isDesktop ? 20 : 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final threeAcross = constraints.maxWidth > 1000;
              if (threeAcross) {
                // Desktop: show three cards in a row
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _cards
                      .map(
                        (c) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: _KnowHowCard(
                              data: c,
                              showDetails: _expanded,
                              compact: false,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              } else {
                // Mobile/tablet: stack cards vertically
                return Column(
                  children: _cards
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: _KnowHowCard(
                            data: c,
                            showDetails: _expanded,
                            compact: !widget.isDesktop,
                          ),
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),

          const SizedBox(height: 10),

          // Show more / less (toggle)
          TextButton.icon(
            onPressed: () => setState(() => _expanded = !_expanded),
            icon: Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.secondary,
            ),
            label: Text(
              _expanded ? 'View less' : 'Know How',
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KnowHowCard extends StatelessWidget {
  final _CardData data;
  final bool compact;
  final bool showDetails;

  const _KnowHowCard({
    Key? key,
    required this.data,
    this.compact = false,
    this.showDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // card container
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: titles + optional bullets
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),

                // Animated reveal of bullets using AnimatedSize for smooth height animation
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    // When collapsed, height is zero so bullets are hidden.
                    constraints: showDetails
                        ? const BoxConstraints()
                        : const BoxConstraints(maxHeight: 0),
                    child: Opacity(
                      opacity: showDetails ? 1 : 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.bullets
                            .map(
                              (b) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 18,
                                      color: AppColors.secondary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        b,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Right: small rounded image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 84,
              height: 84,
              color: Colors.grey.shade100,
              child: data.image != null
                  ? Image.asset(
                      data.image!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.black26),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardData {
  final String title;
  final String subtitle;
  final String? image;
  final List<String> bullets;
  _CardData({
    required this.title,
    required this.subtitle,
    this.image,
    required this.bullets,
  });
}

class CompanyCarousel extends StatefulWidget {
  final List<String> companies;
  final double height; // control image height
  final Duration autoPlayInterval;

  const CompanyCarousel({
    Key? key,
    required this.companies,
    this.height = 56,
    this.autoPlayInterval = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<CompanyCarousel> createState() => _CompanyCarouselState();
}

class _CompanyCarouselState extends State<CompanyCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  bool _userInteracting = false;

  // pick a large multiplier so we can scroll infinitely in both directions
  static const int _kLoopMultiplier = 1000;
  late final int _initialPage;

  @override
  void initState() {
    super.initState();
    // if no companies safe-guard
    final len = widget.companies.isEmpty ? 1 : widget.companies.length;
    _initialPage = len * _kLoopMultiplier;

    _pageController = PageController(
      viewportFraction: 0.22,
      initialPage: _initialPage,
    );

    // start auto-play after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoPlay());
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (widget.companies.isEmpty) return;
    _timer = Timer.periodic(widget.autoPlayInterval, (_) async {
      if (!mounted) return;
      if (_userInteracting) return;

      // get current page (may be fractional while animating)
      final currentPage = _pageController.hasClients
          ? (_pageController.page ?? _pageController.initialPage.toDouble())
          : _pageController.initialPage.toDouble();

      final nextPage = currentPage.toInt() + 1;

      try {
        await _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } catch (_) {
        // controller might be disposed between timer ticks — ignore.
      }
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  Widget _logoTile(String path, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Image.asset(
          path,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => SizedBox(
            height: height,
            child: const Icon(Icons.business, size: 28, color: Colors.black26),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companies = widget.companies;
    final len = companies.length;

    // If there are no logos, show nothing (or you can show a placeholder)
    if (len == 0) {
      return Column(
        children: const [
          SizedBox(height: 56),
          SizedBox(height: 18),
          Text(
            "No company logos",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(height: 25),
        const Text(
          "38L+ top companies trust badhyata for their hiring needs",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: widget.height,
          child: Listener(
            onPointerDown: (_) {
              // user pressed: pause autoplay
              _userInteracting = true;
              _stopAutoPlay();
            },
            onPointerUp: (_) {
              // user released: resume autoplay after small delay
              _userInteracting = false;
              Future.delayed(const Duration(milliseconds: 700), () {
                if (mounted && !_userInteracting) _startAutoPlay();
              });
            },
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                // map large index to actual company index using modulo
                final realIndex = index % len;
                final path = companies[realIndex];
                return _logoTile(path, widget.height);
              },
              // make itemCount null (infinite) by not setting it: builder will be infinite
              // but some Flutter versions require itemCount. We deliberately omit itemCount for infinite.
              onPageChanged: (_) {
                // nothing to do here; the mapping handles index->logo
              },
              padEnds: false,
            ),
          ),
        ),

        const SizedBox(height: 18),

        // caption under carousel
      ],
    );
  }
}

class AutoBannerSlider extends StatefulWidget {
  final List<String> images;
  final double desktopHeight;
  final double mobileHeight;
  final Duration autoPlayInterval;
  final double borderRadius;
  final double maxContentWidth; // 👈 NEW

  const AutoBannerSlider({
    Key? key,
    required this.images,
    this.desktopHeight = 290,
    this.mobileHeight = 200,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.borderRadius = 14.0,
    this.maxContentWidth = 1000, // 👈 controls max width of carousel
  }) : super(key: key);

  @override
  State<AutoBannerSlider> createState() => _AutoBannerSliderState();
}

class _AutoBannerSliderState extends State<AutoBannerSlider> {
  late final PageController _controller;
  Timer? _timer;
  int _currentIndex = 0;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1.0, initialPage: 0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted) return;
      if (_userInteracting) return;
      final next = (_currentIndex + 1) % widget.images.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _controller.dispose();
    super.dispose();
  }

  void _onUserPointerDown(_) {
    _userInteracting = true;
    _stopAutoPlay();
  }

  void _onUserPointerUp(_) {
    Future.delayed(const Duration(milliseconds: 700), () {
      _userInteracting = false;
      if (mounted) _startAutoPlay();
    });
  }

  void _prev() {
    final prev =
        (_currentIndex - 1 + widget.images.length) % widget.images.length;
    _controller.animateToPage(
      prev,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    final next = (_currentIndex + 1) % widget.images.length;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final height = isDesktop ? widget.desktopHeight : widget.mobileHeight;

    return Center(
      // 👈 centers entire slider in screen
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxContentWidth, // 👈 limits carousel width
        ),
        child: Column(
          children: [
            SizedBox(
              height: height,
              child: Listener(
                onPointerDown: _onUserPointerDown,
                onPointerUp: _onUserPointerUp,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                      controller: _controller,
                      itemCount: widget.images.length,
                      onPageChanged: (i) => setState(() => _currentIndex = i),
                      padEnds: false,
                      itemBuilder: (context, index) {
                        final img = widget.images[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _bannerCard(
                            img,
                            height,
                            widget.borderRadius,
                            width,
                          ),
                        );
                      },
                    ),

                    // left arrow
                    Positioned(
                      left: 0,
                      child: _arrowButton(
                        icon: Icons.chevron_left,
                        onTap: _prev,
                      ),
                    ),

                    // right arrow
                    Positioned(
                      right: 0,
                      child: _arrowButton(
                        icon: Icons.chevron_right,
                        onTap: _next,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // indicator dots centered
            SizedBox(
              height: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (i) {
                  final active = i == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: active ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.blue.shade700
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerCard(
    String imagePath,
    double height,
    double radius,
    double width,
  ) {
    return Center(
      child: Material(
        elevation: 5,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(radius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            height: height,
            width: double.infinity,
            color: Colors.grey.shade100,
            child: _buildImage(imagePath),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.broken_image, size: 36, color: Colors.black26),
      ),
    );
  }

  Widget _arrowButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.white,
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          onTap();
          _onUserPointerDown(null);
          _onUserPointerUp(null);
        },
        child: const SizedBox(
          height: 40,
          width: 40,
          child: Icon(Icons.chevron_left, color: Colors.black87),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'dart:math' as math;

/// Example usage:
/// Place inside your page:
/// OurNumbersSection();

class OurNumbersSection extends StatelessWidget {
  const OurNumbersSection({Key? key}) : super(key: key);

  final List<_NumberItem> _items = const [
    _NumberItem(value: 27000000, shortLabel: '27 M+', label: 'Active Users'),
    _NumberItem(value: 22300000, shortLabel: '22.3 M+', label: 'Assessments'),
    _NumberItem(value: 130000, shortLabel: '130 K+', label: 'Opportunities'),
    _NumberItem(value: 800, shortLabel: '800 +', label: 'Brands trust us'),
    _NumberItem(value: 42000, shortLabel: '42 K+', label: 'Organisations'),
    _NumberItem(value: 78, shortLabel: '78 +', label: 'Countries'),
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

/// Single rounded card with animated number
class _NumberCard extends StatefulWidget {
  final _NumberItem item;
  final Duration animateDuration;
  const _NumberCard({
    Key? key,
    required this.item,
    required this.animateDuration,
  }) : super(key: key);

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
    final theme = Theme.of(context);
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

class FeaturedOpportunitiesSection extends StatefulWidget {
  const FeaturedOpportunitiesSection({Key? key}) : super(key: key);

  @override
  State<FeaturedOpportunitiesSection> createState() =>
      _FeaturedOpportunitiesSectionState();
}

class _FeaturedOpportunitiesSectionState
    extends State<FeaturedOpportunitiesSection> {
  late PageController _controller;
  Timer? _timer;
  int _page = 0;
  bool _userInteracting = false;

  final List<_Opportunity> _items = [
    _Opportunity(
      image: 'assets/test.jpg',
      tag: 'Online | Free',
      title: 'Win prizes worth INR 26 Lakhs & Merchandise',
      registered: '12,497',
      daysLeft: '9 days left',
    ),
    _Opportunity(
      image: 'assets/test.jpg',
      tag: 'Online | Free',
      title: 'Pre-Placement Interviews & Cash Prize of INR 2 Lakhs',
      registered: '459',
      daysLeft: '11 days left',
    ),
    _Opportunity(
      image: 'assets/test.jpg',
      tag: 'Festival',
      title: 'Unstop Career League 2025',
      registered: '100',
      daysLeft: '—',
    ),
    _Opportunity(
      image: 'assets/test.jpg',
      tag: 'Festival',
      title: 'Unstop Tech Fair 2025',
      registered: '122,217',
      daysLeft: '—',
    ),
    _Opportunity(
      image: 'assets/test.jpg',
      tag: 'Festival',
      title: 'Unstop Career League 2025',
      registered: '100',
      daysLeft: '—',
    ),
    _Opportunity(
      image: 'assets/test.jpg',
      tag: 'Festival',
      title: 'Unstop Tech Fair 2025',
      registered: '122,217',
      daysLeft: '—',
    ),
    _Opportunity(
      image: 'assets/test.jpg',
      tag: 'Festival',
      title: 'Unstop Career League 2025',
      registered: '100',
      daysLeft: '—',
    ),
    _Opportunity(
      image: 'assets/test.jpg',
      tag: 'Festival',
      title: 'Unstop Tech Fair 2025',
      registered: '122,217',
      daysLeft: '—',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.9);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoPlay());
  }

  void _startAutoPlay({Duration interval = const Duration(seconds: 4)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) {
      if (!mounted) return;
      if (_userInteracting) return;
      final next = (_page + 1) % _items.length;
      _safeAnimateToPage(next);
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _controller.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent _) {
    _userInteracting = true;
    _stopAutoPlay();
  }

  void _onPointerUp(PointerUpEvent _) {
    Future.delayed(const Duration(milliseconds: 600), () {
      _userInteracting = false;
      if (mounted) _startAutoPlay();
    });
  }

  // Safely animate to a given page index — uses controller if attached.
  Future<void> _safeAnimateToPage(int targetPage) async {
    if (!mounted) return;
    if (!_controller.hasClients) {
      // controller not ready, just update the stored page (will take effect once controller builds)
      setState(() => _page = targetPage % _items.length);
      return;
    }

    final len = _items.length;
    final safeTarget = ((targetPage % len) + len) % len; // positive modulo

    // current page may be fractional; resolve to nearest integer page
    final currentPageDouble =
        _controller.page ?? _controller.initialPage.toDouble();
    final currentPage = currentPageDouble.round();

    // If target equals current, still animate a little to show motion
    final animateTo = safeTarget;

    try {
      await _controller.animateToPage(
        animateTo,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
      // onPageChanged will update _page
    } catch (_) {
      // ignore animation errors if controller disposed mid-animation
    }
  }

  // Arrow handlers compute page from the controller (not from _page) — more robust
  void _goPrev() {
    // pause autoplay while user interacts
    _userInteracting = true;
    _stopAutoPlay();

    final len = _items.length;
    if (!_controller.hasClients) {
      setState(() => _page = (_page - 1 + len) % len);
      Future.delayed(const Duration(milliseconds: 600), () {
        _userInteracting = false;
        if (mounted) _startAutoPlay();
      });
      return;
    }

    final curDouble = _controller.page ?? _controller.initialPage.toDouble();
    final cur = curDouble.round();
    final prev = (cur - 1 + len) % len;
    _safeAnimateToPage(prev);

    // resume autoplay after short delay
    Future.delayed(const Duration(milliseconds: 700), () {
      _userInteracting = false;
      if (mounted) _startAutoPlay();
    });
  }

  void _goNext() {
    _userInteracting = true;
    _stopAutoPlay();

    final len = _items.length;
    if (!_controller.hasClients) {
      setState(() => _page = (_page + 1) % len);
      Future.delayed(const Duration(milliseconds: 600), () {
        _userInteracting = false;
        if (mounted) _startAutoPlay();
      });
      return;
    }

    final curDouble = _controller.page ?? _controller.initialPage.toDouble();
    final cur = curDouble.round();
    final next = (cur + 1) % len;
    _safeAnimateToPage(next);

    Future.delayed(const Duration(milliseconds: 700), () {
      _userInteracting = false;
      if (mounted) _startAutoPlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1000;
    final isTablet = w >= 600 && w < 1000;

    final viewportFraction = isDesktop
        ? 0.24
        : isTablet
        ? 0.47
        : 0.92;

    if ((_controller.viewportFraction - viewportFraction).abs() > 0.01) {
      final page = _controller.hasClients
          ? _controller.page?.round() ?? _page
          : _page;
      _controller.dispose();
      _controller = PageController(
        initialPage: page,
        viewportFraction: viewportFraction,
      );
    }

    final height = isDesktop
        ? 320.0
        : isTablet
        ? 320.0
        : 300.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Featured Opportunities',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Check out the curated opportunities handpicked for you from top organizations.',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // arrows on the right — use the robust handlers
              Row(
                children: [
                  _smallIconButton(icon: Icons.chevron_left, onTap: _goPrev),
                  const SizedBox(width: 8),
                  _smallIconButton(
                    icon: Icons.chevron_right,
                    filled: true,
                    onTap: _goNext,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // carousel area
          SizedBox(
            height: height,
            child: Listener(
              onPointerDown: _onPointerDown,
              onPointerUp: _onPointerUp,
              child: PageView.builder(
                controller: _controller,
                itemCount: _items.length,
                onPageChanged: (i) => setState(() => _page = i),
                padEnds: false,
                itemBuilder: (context, index) {
                  final opp = _items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _OpportunityCard(opportunity: opp),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // dots indicator (centered)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _items.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _page == i ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _page == i
                      ? AppColors.secondary
                      : AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _smallIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return Material(
      color: filled ? AppColors.secondary : Colors.white,
      shape: const CircleBorder(),
      elevation: filled ? 2 : 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 42,
          width: 42,
          child: Icon(icon, color: filled ? Colors.white : AppColors.secondary),
        ),
      ),
    );
  }
}

// ---------------------------------------------------
// Opportunity data + card
// ---------------------------------------------------

class _Opportunity {
  final String image; // asset path (or change to network URL)
  final String tag;
  final String title;
  final String registered;
  final String daysLeft;

  _Opportunity({
    required this.image,
    required this.tag,
    required this.title,
    required this.registered,
    required this.daysLeft,
  });
}

class _OpportunityCard extends StatelessWidget {
  final _Opportunity opportunity;
  const _OpportunityCard({Key? key, required this.opportunity})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // card layout inspired by your reference
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 6,
      shadowColor: Colors.black12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // image area (top)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: opportunity.image.isNotEmpty
                          ? Image.asset(
                              opportunity.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: Colors.grey.shade200),
                            )
                          : Container(color: Colors.grey.shade200),
                    ),

                    // tag in top-left
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          opportunity.tag,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    // small heart icon top-right
                    Positioned(
                      right: 10,
                      top: 10,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white70,
                        child: Icon(
                          Icons.favorite_border,
                          size: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // content area
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Text(
                      opportunity.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // meta row: registered and days left
                    Row(
                      children: [
                        const Icon(
                          Icons.group,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          opportunity.registered,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.schedule,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            opportunity.daysLeft,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.open_in_new,
                          size: 18,
                          color: Colors.black38,
                        ),
                      ],
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

class OpportunityCarouselSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? viewAllCallback;
  final List<OpportunityCardData> items;
  final Duration autoPlayInterval;

  const OpportunityCarouselSection({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.items,
    this.viewAllCallback,
    this.autoPlayInterval = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  State<OpportunityCarouselSection> createState() =>
      _OpportunityCarouselSectionState();
}

class _OpportunityCarouselSectionState
    extends State<OpportunityCarouselSection> {
  late PageController _controller;
  Timer? _timer;
  int _page = 0;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.9);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted) return;
      if (_userInteracting) return;
      if (widget.items.isEmpty) return;
      final next = (_page + 1) % widget.items.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _controller.dispose();
    super.dispose();
  }

  void _onPointerDown(_) {
    _userInteracting = true;
    _stopAutoPlay();
  }

  void _onPointerUp(_) {
    Future.delayed(const Duration(milliseconds: 600), () {
      _userInteracting = false;
      if (mounted) _startAutoPlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1000;
    final isTablet = w >= 600 && w < 1000;
    final viewportFraction = isDesktop
        ? 0.24
        : isTablet
        ? 0.47
        : 0.92;

    // if viewportFraction changed, recreate controller preserving page
    if ((_controller.viewportFraction - viewportFraction).abs() > 0.01) {
      final page = _controller.hasClients
          ? _controller.page?.round() ?? _page
          : _page;
      _controller.dispose();
      _controller = PageController(
        initialPage: page,
        viewportFraction: viewportFraction,
      );
    }

    final height = isDesktop
        ? 320.0
        : isTablet
        ? 320.0
        : 320.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      color: Colors.white,
      child: Column(
        children: [
          // header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.viewAllCallback != null)
                TextButton.icon(
                  onPressed: widget.viewAllCallback,
                  icon: Icon(Icons.open_in_new, color: AppColors.secondary),
                  label: Text(
                    'View all',
                    style: TextStyle(color: AppColors.secondary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // carousel
          SizedBox(
            height: height,
            child: Listener(
              onPointerDown: _onPointerDown,
              onPointerUp: _onPointerUp,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: widget.items.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    padEnds: false,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 6,
                        ),
                        child: _SmallOpportunityCard(data: item),
                      );
                    },
                  ),

                  // left arrow
                  Positioned(
                    left: 6,
                    child: _navButton(
                      icon: Icons.chevron_left,
                      enabled: widget.items.isNotEmpty,
                      onTap: _prevPage,
                    ),
                  ),

                  // right arrow
                  Positioned(
                    right: 6,
                    child: _navButton(
                      icon: Icons.chevron_right,
                      enabled: widget.items.isNotEmpty,
                      onTap: _nextPage,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.items.length, (i) {
              final active = i == _page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 14 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.secondary
                      : AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _prevPage() {
    if (widget.items.isEmpty) return;
    final prev = (_page - 1 + widget.items.length) % widget.items.length;
    _controller.animateToPage(
      prev,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
    _pauseBriefly();
  }

  void _nextPage() {
    if (widget.items.isEmpty) return;
    final next = (_page + 1) % widget.items.length;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
    _pauseBriefly();
  }

  void _pauseBriefly() {
    _onPointerDown(null);
    _onPointerUp(null);
  }

  Widget _navButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: enabled ? Colors.white : Colors.white70,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          height: 42,
          width: 42,
          child: Icon(icon, color: AppColors.secondary),
        ),
      ),
    );
  }
}

/// small card used inside the carousel — similar to Unstop card style
class _SmallOpportunityCard extends StatelessWidget {
  final OpportunityCardData data;
  const _SmallOpportunityCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // card visuals: rounded corners, image top, meta + title + bottom row
    return Material(
      elevation: 6,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // image area
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child:
                          data.imagePath != null && data.imagePath!.isNotEmpty
                          ? Image.asset(
                              data.imagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: Colors.grey.shade200),
                            )
                          : Container(color: Colors.grey.shade200),
                    ),

                    // tiny badges top-left
                    if ((data.tag ?? '').isNotEmpty)
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data.tag!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                    // small logo square top-right (optional)
                    if ((data.logoPath ?? '').isNotEmpty)
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset(
                              data.logoPath!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // body
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.group,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          data.registered,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.schedule,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            data.metaRight,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.open_in_new,
                          size: 16,
                          color: Colors.black38,
                        ),
                      ],
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

/// Data model for small cards
class OpportunityCardData {
  final String title;
  final String? imagePath; // banner image
  final String? logoPath; // small square logo
  final String? tag; // e.g. "Online | Free" or "WFH" etc.
  final String registered; // e.g. "88 Applied"
  final String metaRight; // e.g. "3 days left" or "90 Opportunities"

  OpportunityCardData({
    required this.title,
    this.imagePath,
    this.logoPath,
    this.tag,
    this.registered = '',
    this.metaRight = '',
  });
}

final List<OpportunityCardData> sampleItems = [
  OpportunityCardData(
    title: 'UDAAN - A Social Empowerment Case Study Competition',
    imagePath: 'assets/test2.jpg',
    logoPath: 'assets/test2.jpg',
    tag: 'Online | Free',
    registered: '88 Applied',
    metaRight: '3 days left',
  ),
  OpportunityCardData(
    title: 'The Catalyst: Call for Articles – Inaugural Edition',
    imagePath: 'assets/test2.jpg',
    logoPath: 'assets/test2.jpg',
    tag: 'Online | Free',
    registered: '4 Applied',
    metaRight: '27 days left',
  ),
  OpportunityCardData(
    title: 'Carbon Credit Simulation Game – “The Race to Net Zero”',
    imagePath: 'assets/test2.jpg',
    logoPath: 'assets/test2.jpg',
    tag: 'Offline | Free',
    registered: '9 Applied',
    metaRight: '7 days left',
  ),
  OpportunityCardData(
    title: 'The Great Vault Heist',
    imagePath: 'assets/test2.jpg',
    logoPath: 'assets/test2.jpg',
    tag: 'Online | Free',
    registered: '26 Applied',
    metaRight: '28 days left',
  ),
  OpportunityCardData(
    title: 'TechnoVision 2025 - National Hackathon',
    imagePath: 'assets/test2.jpg',
    logoPath: 'assets/test2.jpg',
    tag: 'Online | Paid',
    registered: '150 Applied',
    metaRight: '5 days left',
  ),
  OpportunityCardData(
    title: 'MindSpark Innovation Challenge',
    imagePath: 'assets/test2.jpg',
    logoPath: 'assets/test2.jpg',
    tag: 'Online | Free',
    registered: '212 Applied',
    metaRight: '10 days left',
  ),
];

class CompanyMockTestsSection extends StatefulWidget {
  const CompanyMockTestsSection({Key? key}) : super(key: key);

  @override
  State<CompanyMockTestsSection> createState() =>
      _CompanyMockTestsSectionState();
}

class _CompanyMockTestsSectionState extends State<CompanyMockTestsSection> {
  final List<String> _categories = ['All', 'Tech', 'Management', 'General'];
  String _selectedCategory = 'All';

  // sample data (replace assets with your own)
  final List<_CompanyTest> _allTests = [
    _CompanyTest(
      title: 'AI Engineer',
      company: 'Google',
      logo: 'assets/test.jpg',
      category: 'Tech',
    ),
    _CompanyTest(
      title: 'Machine Learning Engineer',
      company: 'OpenAI',
      logo: 'assets/test.jpg',
      category: 'Tech',
    ),
    _CompanyTest(
      title: 'iOS Developer',
      company: 'Uber',
      logo: 'assets/test.jpg',
      category: 'Tech',
    ),
    _CompanyTest(
      title: 'Blockchain Engineer',
      company: 'StarkWare',
      logo: 'assets/test.jpg',
      category: 'Tech',
    ),
    _CompanyTest(
      title: 'Product Manager',
      company: 'Flipkart',
      logo: 'assets/test.jpg',
      category: 'Management',
    ),
    _CompanyTest(
      title: 'Business Analyst',
      company: 'McKinsey',
      logo: 'assets/test.jpg',
      category: 'Management',
    ),
    _CompanyTest(
      title: 'General Aptitude',
      company: 'Badhyata',
      logo: 'assets/test.jpg',
      category: 'General',
    ),
  ];

  // Page controller & autoplay
  late PageController _controller;
  Timer? _timer;
  bool _userInteracting = false;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.9);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      if (_userInteracting) return;
      final visible = _filteredTests;
      if (visible.isEmpty) return;
      final next = (_page + 1) % visible.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  List<_CompanyTest> get _filteredTests {
    if (_selectedCategory == 'All') return _allTests;
    return _allTests.where((t) => t.category == _selectedCategory).toList();
  }

  void _onPointerDown(_) {
    _userInteracting = true;
    _stopAutoPlay();
  }

  void _onPointerUp(_) {
    Future.delayed(const Duration(milliseconds: 600), () {
      _userInteracting = false;
      if (mounted) _startAutoPlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1000;
    final isTablet = w >= 600 && w < 1000;
    final viewportFraction = isDesktop
        ? 0.24
        : isTablet
        ? 0.47
        : 0.92;

    if ((_controller.viewportFraction - viewportFraction).abs() > 0.01) {
      final page = _controller.hasClients
          ? (_controller.page?.round() ?? _page)
          : _page;
      _controller.dispose();
      _controller = PageController(
        initialPage: page,
        viewportFraction: viewportFraction,
      );
    }

    final visible = _filteredTests;
    final height = isDesktop
        ? 260.0
        : isTablet
        ? 320.0
        : 320.0;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Company Mock Tests',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Master your concepts with AI-Powered full-length mock tests for 360° preparation!',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              // View all link
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.open_in_new, color: AppColors.secondary),
                label: Text(
                  'View all',
                  style: TextStyle(color: AppColors.secondary),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Filter pills
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final selected = cat == _selectedCategory;
                return Theme(
                  data: Theme.of(context).copyWith(
                    chipTheme: Theme.of(context).chipTheme.copyWith(
                      checkmarkColor: Colors.white, // <-- make checkmark white
                    ),
                  ),
                  child: ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: selected,
                    selectedColor: AppColors.secondary,
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = cat;
                        _page = 0;
                        // reset page controller to first page of filtered list
                        _controller.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          // Carousel
          SizedBox(
            height: height,
            child: Listener(
              onPointerDown: _onPointerDown,
              onPointerUp: _onPointerUp,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: visible.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (_, index) {
                      final t = visible[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6,
                        ),
                        child: _MockTestCard(
                          data: t,
                          onStart: () {
                            // handle start test
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Start test: ${t.title} - ${t.company}',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // Left arrow
                  Positioned(
                    left: 6,
                    child: _circleNavButton(
                      icon: Icons.chevron_left,
                      onTap: () {
                        if (visible.isEmpty) return;
                        final prev =
                            (_page - 1 + visible.length) % visible.length;
                        _controller.animateToPage(
                          prev,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                        _onPointerDown(null);
                        _onPointerUp(null);
                      },
                    ),
                  ),

                  // Right arrow
                  Positioned(
                    right: 6,
                    child: _circleNavButton(
                      icon: Icons.chevron_right,
                      onTap: () {
                        if (visible.isEmpty) return;
                        final next = (_page + 1) % visible.length;
                        _controller.animateToPage(
                          next,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                        _onPointerDown(null);
                        _onPointerUp(null);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(visible.length, (i) {
              final active = i == _page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: active ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.secondary
                      : AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _circleNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      shape: const CircleBorder(),
      elevation: 3,
      color: Colors.white,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 44,
          width: 44,
          child: Icon(icon, color: Colors.black87),
        ),
      ),
    );
  }
}

// -------------------- Mock Test Card --------------------
class _MockTestCard extends StatelessWidget {
  final _CompanyTest data;
  final VoidCallback? onStart;
  const _MockTestCard({Key? key, required this.data, this.onStart})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // logo banner area
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.grey.shade50,
                child: Center(
                  child: data.logo != null && data.logo!.isNotEmpty
                      ? Image.asset(
                          data.logo!,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox(),
                        )
                      : const SizedBox(),
                ),
              ),

              // content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.company,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 6),
                    const SizedBox(height: 8),

                    // CTA row
                    Row(
                      children: [
                        TextButton(
                          onPressed: onStart,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Start Test',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.open_in_new, size: 16),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // optional small meta or badge
                        if (data.badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              data.badge!,
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                      ],
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

// -------------------- Data model --------------------
class _CompanyTest {
  final String title;
  final String company;
  final String? logo; // asset path
  final String category;
  final String? badge;

  _CompanyTest({
    required this.title,
    required this.company,
    required this.category,
    this.logo,
    this.badge,
  });
}
// import 'package:flutter/material.dart';

/// Paste/replace your existing ExpandableFeatureCards with this class file.
/// Make sure your assets exist (assets/test.jpg used below as an example).

class ExpandableFeatureCards extends StatefulWidget {
  const ExpandableFeatureCards({Key? key}) : super(key: key);

  @override
  State<ExpandableFeatureCards> createState() => _ExpandableFeatureCardsState();
}

class _ExpandableFeatureCardsState extends State<ExpandableFeatureCards> {
  // Which card is expanded (centered by default)
  int _expandedIndex = 1;
  // optional "locked" index when tapping on mobile (not required)
  int _lockedIndex = -1;

  final List<_FeatureItem> items = const [
    _FeatureItem(
      title: 'Coding Practice',
      subtitle:
          'Level up your coding skills by practicing the hiring questions.',
      badge: '400+ Questions',
      imageAsset: 'assets/test.jpg',
      color: Color(0xFFE8F1FF),
      icon: Icons.code,
    ),
    _FeatureItem(
      title: 'Interview Preparation',
      subtitle: 'Crack top companies in just 5 days.',
      badge: 'Start Now',
      imageAsset: 'assets/test.jpg',
      color: Color(0xFFFFE1EB),
      icon: Icons.list,
    ),
    _FeatureItem(
      title: 'Projects',
      subtitle: 'Build projects that showcase impact & skills.',
      badge: '15+ Projects',
      imageAsset: 'assets/test.jpg',
      color: Color(0xFFF0E9FF),
      icon: Icons.work,
    ),
    _FeatureItem(
      title: 'Skill Based Assessments',
      subtitle: 'Assess your skills and gain recruiter readiness.',
      badge: '2000+ Questions',
      imageAsset: 'assets/test.jpg',
      color: Color(0xFFFEF3D6),
      icon: Icons.bar_chart,
    ),
  ];

  void _onHover(int idx, bool hovering) {
    // if tapped/locked on mobile ignore hover
    if (_lockedIndex != -1) return;
    setState(() => _expandedIndex = hovering ? idx : 1);
  }

  void _onTap(int idx) {
    // lock / unlock behaviour for mobile; desktop will just expand on hover
    setState(() {
      if (_lockedIndex == idx) {
        _lockedIndex = -1;
        _expandedIndex = 1;
      } else {
        _lockedIndex = idx;
        _expandedIndex = idx;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isNarrow = w < 820;

    if (isNarrow) {
      return _buildMobileCarousel(context);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Practice Coding & Ace Hiring Assessments',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Level up your coding skills by practicing the hiring assessments of your dream companies & ace your placement game!',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 18),

          // This box holds the animated cards; fixed height prevents vertical overflows
          SizedBox(
            height: 320,
            child: ClipRect(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final total = constraints.maxWidth;
                  const gap = 12.0;
                  final count = items.length;
                  final gapsTotal = gap * (count - 1);

                  // Minimum widths so cards never become tiny
                  const minCollapsed = 96.0;
                  const minExpanded = 180.0;
                  final idealExpanded = (total * 0.52).clamp(
                    minExpanded,
                    total - gapsTotal - (minCollapsed * (count - 1)),
                  );

                  // compute collapsed width initially
                  double remaining = total - idealExpanded - gapsTotal;
                  double collapsedWidth = (remaining / (count - 1)).clamp(
                    minCollapsed,
                    total,
                  );
                  double expandedWidth = idealExpanded;

                  // if collapsed is too small, reduce expanded to make room
                  if (collapsedWidth < minCollapsed) {
                    collapsedWidth = minCollapsed;
                    expandedWidth =
                        (total - gapsTotal - collapsedWidth * (count - 1))
                            .clamp(minExpanded, total - gapsTotal);
                  }

                  // Fallback to equal distribution if something is still invalid
                  if (expandedWidth <= 0 || collapsedWidth <= 0) {
                    final equal = (total - gapsTotal) / count;
                    expandedWidth = equal;
                    collapsedWidth = equal;
                  }

                  // Build children
                  final children = <Widget>[];
                  for (int i = 0; i < count; i++) {
                    final isExpanded = i == _expandedIndex;
                    final assigned = isExpanded
                        ? expandedWidth
                        : collapsedWidth;

                    children.add(
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 420),
                        curve: Curves.easeInOutCubic,
                        width: assigned,
                        margin: EdgeInsets.only(left: i == 0 ? 0 : gap),
                        child: MouseRegion(
                          onEnter: (_) => _onHover(i, true),
                          onExit: (_) => _onHover(i, false),
                          child: GestureDetector(
                            onTap: () => _onTap(i),
                            child: _FeatureCardResponsive(
                              data: items[i],
                              expanded: isExpanded,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCarousel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Practice Coding & Ace Hiring Assessments',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Level up your coding skills by practicing the hiring assessments of your dream companies & ace your placement game!',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 360,
            child: PageView.builder(
              itemCount: items.length,
              controller: PageController(viewportFraction: 0.94),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 6.0,
                  ),
                  child: GestureDetector(
                    onTap: () => _onTap(i),
                    child: _FeatureCardResponsive(
                      data: items[i],
                      expanded: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive card which constrains image and text to avoid forcing width/height.
class _FeatureCardResponsive extends StatelessWidget {
  final _FeatureItem data;
  final bool expanded;
  const _FeatureCardResponsive({
    Key? key,
    required this.data,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(14.0);
    final pad = expanded ? 18.0 : 12.0;
    final imageMax = expanded ? 160.0 : 110.0;

    return Material(
      color: Colors.white,
      elevation: expanded ? 10 : 3,
      borderRadius: borderRadius,
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            // left icon when collapsed
            // if (!expanded)
            //   Padding(
            //     padding: const EdgeInsets.only(right: 8.0),
            //     child: CircleAvatar(radius: 26, backgroundColor: data.color, child: Icon(data.icon, size: 26, color: Colors.black87)),
            //   ),

            // flexible text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: expanded
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: expanded ? 20 : 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    child: Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    opacity: expanded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      data.subtitle,
                      style: const TextStyle(color: Colors.black54),
                      maxLines: expanded ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // const SizedBox(height: 10),
                  // if (expanded)
                  //   ElevatedButton.icon(
                  //     onPressed: () {},
                  //     icon: const Icon(Icons.play_arrow, size: 18),
                  //     label: Text(data.badge),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.blue.shade800,
                  //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //     ),
                  //   )
                  // else
                  //   Text(data.badge, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // right image block — strongly constrained so it never forces parent's height
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: imageMax,
                maxHeight: imageMax,
                minWidth: 64,
                minHeight: 64,
              ),
              child: SizedBox(
                width: imageMax,
                height: imageMax,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: data.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      (data.imageAsset != null && data.imageAsset!.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            data.imageAsset!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.black26,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  final String title;
  final String subtitle;
  final String badge;
  final String? imageAsset;
  final Color color;
  final IconData icon;

  const _FeatureItem({
    required this.title,
    required this.subtitle,
    required this.badge,
    this.imageAsset,
    required this.color,
    required this.icon,
  });
}

// ---------- OPPORTUNITY CATEGORIES (responsive) ----------
class OpportunityCategoriesSection extends StatelessWidget {
  const OpportunityCategoriesSection({Key? key}) : super(key: key);

  static final List<_CategoryInfo> _categories = [
    _CategoryInfo(
      title: 'Quizzes',
      asset: 'assets/test.jpg',
      color: Color(0xFF6FB6FF),
    ),
    _CategoryInfo(
      title: 'Hackathons',
      asset: 'assets/test.jpg',
      color: Color(0xFF6EE6A6),
    ),
    _CategoryInfo(
      title: 'Scholarships',
      asset: 'assets/test.jpg',
      color: Color(0xFF7B62E6),
    ),
    _CategoryInfo(
      title: 'Conferences',
      asset: 'assets/test.jpg',
      color: Color(0xFFF6D8C6),
    ),
    _CategoryInfo(
      title: 'College Festivals',
      asset: 'assets/test.jpg',
      color: Color(0xFFF6C941),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            // header row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Pick The Right Opportunity!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Explore opportunities that best suits your skills and interests!',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Explore all',
                        style: TextStyle(
                          color: Color(0xFF1E63B8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.open_in_new,
                        size: 18,
                        color: Color(0xFF1E63B8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // responsive grid / list for category tiles
            LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth;
                // decide layout: 4 cols on wide, 3 on medium, 2 on small, 1 on very small (mobile)
                int cols;
                if (maxW >= 1100) {
                  cols = 4;
                } else if (maxW >= 800) {
                  cols = 3;
                } else if (maxW >= 520) {
                  cols = 2;
                } else {
                  cols = 1;
                }

                final spacing = 18.0;
                final tileWidth = (maxW - spacing * (cols - 1)) / cols;
                // clamp tile size to a reasonable range
                final tileSize = tileWidth.clamp(140.0, 260.0);

                // if cols == 1 show vertical list with full width tiles for a mobile friendly experience
                if (cols == 1) {
                  return Column(
                    children: _categories.map((c) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: _CategoryTile(
                          info: c,
                          size: tileSize,
                          fullWidth: true,
                        ),
                      );
                    }).toList(),
                  );
                }

                // grid-like wrap for 2..4 columns
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: _categories
                      .map((c) => _CategoryTile(info: c, size: tileSize))
                      .toList(),
                );
              },
            ),

            const SizedBox(height: 28),

            // promo row (keeps original responsive idea)
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 800;
                return isNarrow
                    ? Column(
                        children: const [
                          _DownloadPromo(),
                          SizedBox(height: 16),
                          _ReferPromo(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Expanded(child: _DownloadPromo()),
                          SizedBox(width: 18),
                          Expanded(child: _ReferPromo()),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------- Category Tile -------------------- */

class _CategoryInfo {
  final String title;
  final String asset;
  final Color color;
  const _CategoryInfo({
    required this.title,
    required this.asset,
    required this.color,
  });
}

class _CategoryTile extends StatefulWidget {
  final _CategoryInfo info;
  final double size;
  final bool fullWidth;
  const _CategoryTile({
    Key? key,
    required this.info,
    required this.size,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14.0);
    final tile = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: widget.fullWidth ? double.infinity : widget.size,
      // height slightly responsive to size
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.info.color,
        borderRadius: radius,
        boxShadow: _hover
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.info.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    height: widget.size * 0.45,
                    child: _loadAsset(widget.info.asset),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // enable hover only when pointer device is available
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: tile,
    );
  }

  Widget _loadAsset(String path) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/* -------------------- Promo Cards -------------------- */

class _DownloadPromo extends StatelessWidget {
  const _DownloadPromo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16.0);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9F4FF),
        borderRadius: radius,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Download',
                  style: TextStyle(color: Color(0xFF1E63B8), fontSize: 18),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Badhyata App',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Connecting Talent, Colleges, Recruiters',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 18),
                Column(
                  children: [
                    _storeBadge(icon: Icons.android, label: 'Google Play'),
                    const SizedBox(height: 12),
                    _storeBadge(icon: Icons.apple, label: 'App Store'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: AspectRatio(
                aspectRatio: 9 / 7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/scan.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.white30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferPromo extends StatelessWidget {
  const _ReferPromo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16.0);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DA),
        borderRadius: radius,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Refer & Win',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'MacBook, iPhone, Apple Watch, AirPods, Cash Rewards and more!',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: AspectRatio(
                aspectRatio: 9 / 7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/scan.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.white30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _storeBadge({required IconData icon, required String label}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
