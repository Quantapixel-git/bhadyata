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
        //  backgroundColor: AppColors.white,
        preferredSize: Size.fromHeight(isDesktop ? 72 : 60),
        child: _buildStickyHeader(context, isDesktop),
      ),
      drawer: isDesktop
          ? null
          : const _MobileNavDrawer(), // 👈 burger on mobile
      body: SingleChildScrollView(
        child: Column(
          children: [
            // REMOVE: _buildHeader(context, isDesktop),
            _buildHeroSection(context, isDesktop),
            const SizedBox(height: 40),
            // _buildSearchSection(context, isDesktop),
            // const SizedBox(height: 60),
            _buildCompaniesSection(context, isDesktop),
            const SizedBox(height: 60),
            _buildStatsSection(context, isDesktop),
            const SizedBox(height: 60),
            _buildStepsSection(context, isDesktop),
            const SizedBox(height: 80),
            const WhatMakesWorkIndiaBetterSection(),
            const SizedBox(height: 80),
            const EmployerReviewsSection(),
            const SizedBox(height: 60),
            const HireFromCategoriesSection(),
            const SizedBox(height: 40),
            const HireFromCitiesSection(),
            const SizedBox(height: 40),
            const DownloadRecruiterAppSection(),
            const SizedBox(height: 40),
            const EmployerFaqSection(),
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
      elevation: 2,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              if (!isDesktop)
                // 👇 burger button for mobile
                Builder(
                  builder: (ctx) => IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 40,
                      color: AppColors.secondary,
                    ),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                    tooltip: "Menu",
                  ),
                ),
              if (!isDesktop) const SizedBox(width: 4),

              // logo + brand
              Image.asset('assets/job_bgr.png', height: 36),
              const SizedBox(width: 8),
              Text(
                "Badhyata",
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: isDesktop ? 22 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

              // 👇 desktop nav actions only
              if (isDesktop)
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Team Lead",
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Company",
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HrLoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        "HR",
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AdminLoginPage()),
                        );
                      },
                      child: Text(
                        "Admin",
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                        side: BorderSide(color: AppColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Find a job",
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployerLogin(),
                          ),
                        );
                      },
                      child: const Text(
                        "Hire Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HERO SECTION ----------------
  Widget _buildHeroSection(BuildContext context, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      // color: const Color(0xFFF4F6FF),
      child: Column(
        children: [
          Text(
            "India’s Largest Job Portal",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 36 : 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Hire the Top 1% Skilled Staff from 4Cr+ Candidates",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 40),
          Image.asset(
            'assets/job-removebg.png',
            width: isDesktop ? 480 : 300,
          ), // handshake illustration
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _blueButton("Hire now", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EmployerLogin()),
                );
              }),
              _blueButton("Get a job", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- COMPANIES SECTION ----------------
  Widget _buildCompaniesSection(BuildContext context, bool isDesktop) {
    final companies = [
      'assets/companies/Amazon.png',
      'assets/companies/capgemini.png',
      'assets/companies/dell.png',
      'assets/companies/hcl.jpg',
      'assets/companies/maruti.png',
      'assets/companies/microsoft.jpg',
      'assets/companies/quanta.png',
    ];

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 24,
          runSpacing: 16,
          children: companies
              .map((path) => Image.asset(path, height: 40))
              .toList(),
        ),
        const SizedBox(height: 30),
        const Text(
          "38L+ top companies trust badhyata for their hiring needs",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // ---------------- STATS SECTION ----------------
  Widget _buildStatsSection(BuildContext context, bool isDesktop) {
    final items = [
      {
        "title": "4Cr+",
        "subtitle": "Qualified Candidates",
        "icon": Icons.person,
      },
      {
        "title": "38L+",
        "subtitle": "Interviews per month",
        "icon": Icons.phone,
      },
      {"title": "750+", "subtitle": "Cities in India", "icon": Icons.flag},
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 30,
      runSpacing: 20,
      children: items
          .map(
            (e) => Container(
              width: isDesktop ? 200 : 150,
              height: isDesktop ? 160 : 130,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    e["icon"] as IconData,
                    color: AppColors.secondary,
                    size: 30,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    e["title"] as String,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    e["subtitle"] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

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

  // ---------------- HELPERS ----------------
  Widget _blueButton(String text, VoidCallback onTap) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondary,
      padding: const EdgeInsets.symmetric(horizontal: 68, vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onPressed: onTap,
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, color: Colors.white),
    ),
  );

  Widget _searchField(String hint) => TextField(
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black26),
      ),
    ),
  );
}

// import 'package:flutter/material.dart';

class WhatMakesWorkIndiaBetterSection extends StatelessWidget {
  const WhatMakesWorkIndiaBetterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      width: double.infinity,
      color: AppColors.secondary, // deep indigo background
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          const Text(
            "What makes badhyata better ?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
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
              side: const BorderSide(color: Colors.white, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Post your Job",
              style: TextStyle(color: Colors.white, fontSize: 16),
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
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
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
      padding: const EdgeInsets.symmetric(vertical: 48),
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

/// ---------- CATEGORIES ----------
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
    'Data Entry',
    'Marketing',
    'Electrician',
    'Plumber',
    'Office Boy',
    'Cashier',
    'Housekeeping',
    'IT Support',
    'Mechanic',
    'Tailor',
    'Teacher',
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final visible = _showAll ? _categories : _categories.take(9).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _sectionHeading('Hire from 50+ Job Categories'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: visible.map((e) => _pillChip(e)).toList(),
          ),
          const SizedBox(height: 18),
          Center(
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

/// ---------- CITIES ----------
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
    'Vadodara',
    'Rajkot',
    'Coimbatore',
    'Kochi',
  ];

  @override
  Widget build(BuildContext context) {
    final chips = _showAll ? [..._topCities, ..._moreCities] : _topCities;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _sectionHeading('Hire from 750+ Cities'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [...chips.map(_cityChip)],
          ),
          const SizedBox(height: 18),
          Center(
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
                    children: [
                      // QR
                      _qrBox(),
                      _qrBox(),

                      // Vertical divider (hide on narrow)
                      // if (isWide)
                      //   Container(width: 1, height: 140, color: Colors.white24),
                      // // Phone input + buttons
                      // _phoneInputAndButtons(),
                    ],
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
        'Download the badhyata for Recruiters App',
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
    final isWide = width >= 900;
    final isTablet = width >= 600 && width < 900;
    final isMobile = width < 600;

    return Container(
      width: double.infinity,
      color: AppColors.secondary,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 28 : 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Follow Us
          Text(
            'Follow Us',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const _AccentUnderline(),
          SizedBox(height: isMobile ? 12 : 16),

          // Social icons
          Wrap(
            spacing: isMobile ? 14 : 22,
            runSpacing: isMobile ? 10 : 12,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: [
              _SocialIcon(icon: Icons.facebook, small: isMobile),
              _SocialIcon(icon: Icons.inbox, small: isMobile),
              _SocialIcon(icon: Icons.alternate_email, small: isMobile),
              _SocialIcon(icon: Icons.ondemand_video, small: isMobile),
              _SocialIcon(icon: Icons.camera_alt_outlined, small: isMobile),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),

          // Top links
          Wrap(
            spacing: isMobile ? 14 : 22,
            runSpacing: 10,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: [
              _footerLink('About'),
              _footerLink('Careers'),
              _footerLink('Culture'),
              _footerLink('Contact Us'),
              _footerLink('Interview Tips'),
              _footerLink('Sitemap'),
              _footerLink('Privacy'),
              _footerLink('Refund Policy'),
              _footerLink('Terms'),
              _footerLink('Free Job Alerts'),
            ],
          ),
          SizedBox(height: isMobile ? 20 : 28),

          // CTA cards (responsive)
          // Wrap(
          //   spacing: isMobile ? 12 : 24,
          //   runSpacing: 16,
          //   children: const [
          //     _CtaCard(
          //       title: 'I want to\nHire',
          //       subtitle: 'Post a New Job',
          //       icon: Icons.open_in_new,
          //     ),
          //     _CtaCard(
          //       title: 'I want a\nJob',
          //       subtitle: 'Download the App',
          //       icon: Icons.file_download,
          //     ),
          //   ],
          // ),
          SizedBox(height: isMobile ? 24 : 36),

          // Link columns (responsive)
          SizedBox(
            width: double.infinity,
            child: isWide
                ? _linksGridWide()
                : isTablet
                ? _linksGridTwoCols()
                : _linksGridNarrow(),
          ),
          SizedBox(height: isMobile ? 20 : 28),

          // Copyright
          Padding(
            padding: EdgeInsets.only(top: isMobile ? 4 : 0),
            child: const Center(
              child: Text(
                '© 2025 Badhyata Private Limited. All Rights Reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====== small helpers ======

Widget _footerLink(String t) => InkWell(
  onTap: () {},
  child: Text(
    t,
    style: const TextStyle(
      color: Colors.white,
      decoration: TextDecoration.underline,
    ),
  ),
);

// 4 columns (desktop)
Widget _linksGridWide() => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: const [
    Expanded(
      child: _LinkColumn(
        title: 'Find Jobs By Type',
        items: [
          'Accountant',
          'Articleship',
          'Back Office',
          'Engineer (Mech/Civil etc.)',
          'Finance',
          'Field Sales',
        ],
      ),
    ),
    Expanded(
      child: _LinkColumn(
        title: 'Find Jobs for Women',
        items: ['Women career opportunities'],
      ),
    ),
    Expanded(
      child: _LinkColumn(
        title: 'Post Jobs In City',
        items: [
          'Mumbai',
          'Delhi',
          'Pune',
          'Bangalore',
          'Kolkata',
          'Ahmedabad',
          'Chennai',
          'Hyderabad',
        ],
      ),
    ),
    Expanded(
      child: _LinkColumn(
        title: 'Post Jobs In Sector',
        items: ['Telecalling', 'Cook'],
      ),
    ),
  ],
);

// 2 columns (tablet)
Widget _linksGridTwoCols() => Wrap(
  spacing: 24,
  runSpacing: 24,
  children: const [
    SizedBox(
      width: 280,
      child: _LinkColumn(
        title: 'Find Jobs By Type',
        items: [
          'Accountant',
          'Articleship',
          'Back Office',
          'Engineer (Mech/Civil etc.)',
          'Finance',
          'Field Sales',
        ],
      ),
    ),
    SizedBox(
      width: 280,
      child: _LinkColumn(
        title: 'Find Jobs for Women',
        items: ['Women career opportunities'],
      ),
    ),
    SizedBox(
      width: 280,
      child: _LinkColumn(
        title: 'Post Jobs In City',
        items: [
          'Mumbai',
          'Delhi',
          'Pune',
          'Bangalore',
          'Kolkata',
          'Ahmedabad',
          'Chennai',
          'Hyderabad',
        ],
      ),
    ),
    SizedBox(
      width: 280,
      child: _LinkColumn(
        title: 'Post Jobs In Sector',
        items: ['Telecalling', 'Cook'],
      ),
    ),
  ],
);

// 1 column (mobile)
Widget _linksGridNarrow() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: const [
    _LinkColumn(
      title: 'Find Jobs By Type',
      items: [
        'Accountant',
        'Articleship',
        'Back Office',
        'Engineer (Mech/Civil etc.)',
        'Finance',
        'Field Sales',
      ],
    ),
    SizedBox(height: 20),
    _LinkColumn(
      title: 'Find Jobs for Women',
      items: ['Women career opportunities'],
    ),
    SizedBox(height: 20),
    _LinkColumn(
      title: 'Post Jobs In City',
      items: ['Mumbai', 'Delhi', 'Pune', 'Bangalore', 'Kolkata', 'Ahmedabad'],
    ),
    SizedBox(height: 20),
    _LinkColumn(title: 'Post Jobs In Sector', items: ['Telecalling', 'Cook']),
  ],
);

class _SocialIcon extends StatelessWidget {
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

class _CtaCard extends StatelessWidget {
  const _CtaCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 600;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: isMobile ? double.infinity : 320,
        maxWidth: isMobile ? double.infinity : 460,
      ),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.secondary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Row(
          children: [
            // left preview
            Expanded(
              child: Container(
                height: isMobile ? 90 : 120,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white54,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // right text
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(icon, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          subtitle,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_forward,
                          color: AppColors.secondary,
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

class _MobileNavDrawer extends StatelessWidget {
  const _MobileNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // header
            Container(
              color: AppColors.secondary.withOpacity(0.06),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Image.asset('assets/job_bgr.png', height: 36),
                  const SizedBox(width: 10),
                  Text(
                    "Badhyata",
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // links
            ListTile(
              leading: Icon(Icons.person_search, color: AppColors.secondary),
              title: const Text("Find a job"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),

            ListTile(
              leading: Icon(
                Icons.group_work_outlined,
                color: AppColors.secondary,
              ),
              title: const Text("Team Lead"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.domain, color: AppColors.secondary),
              title: const Text("Company"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.badge, color: AppColors.secondary),
              title: const Text("HR"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HrLoginPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.admin_panel_settings_outlined,
                color: AppColors.secondary,
              ),
              title: const Text("Admin"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminLoginPage()),
                );
              },
            ),
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EmployerLogin()),
                    );
                  },
                  child: const Text(
                    "Hire Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
