import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/auth/admin_login.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/employer/views/auth/employer_login.dart';
import 'package:jobshub/hr/views/auth/hr_login_screen.dart';
import 'package:jobshub/users/views/auth/login_screen.dart';

// This file is a redesigned, professional mobile-first onboarding screen.
// Features:
// - Three crisp onboarding pages (illustration, headline, short copy)
// - Smooth animated transitions and page indicator
// - Prominent primary CTA (Next / Get started)
// - Polished header with logo and a professional "More" dropdown for HR/Admin/Employer
// - Accessibility-friendly sizes and contrast

enum _MoreAction { hr, admin }

class MobileOnboardingPage extends StatefulWidget {
  const MobileOnboardingPage({super.key});

  @override
  State<MobileOnboardingPage> createState() => _MobileOnboardingPageState();
}

class _MobileOnboardingPageState extends State<MobileOnboardingPage> {
  final PageController _pageController = PageController();
  int _page = 0;
  bool _isAnimating = false;

  final _pages = <_OnboardItem>[
    _OnboardItem(
      image: 'assets/onboard/illustration_1.png',
      title: 'Find roles that fit you',
      subtitle:
          'Personalised job matches, interview tips, and application trackers — all in one place.',
    ),
    _OnboardItem(
      image: 'assets/onboard/illustration_2.png',
      title: 'Hire top talent fast',
      subtitle:
          'Post jobs, screen candidates and schedule interviews with a few taps.',
    ),
    _OnboardItem(
      image: 'assets/onboard/illustration_3.png',
      title: 'Grow your career & team',
      subtitle:
          'Upskill recommendations, verified employers and hiring analytics.',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNext() {
    if (_page < _pages.length - 1) {
      setState(() => _isAnimating = true);
      _pageController
          .animateToPage(
            _page + 1,
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOut,
          )
          .then((_) => setState(() => _isAnimating = false));
    } else {
      _openGetStarted();
    }
  }

  void _openGetStarted() {
    // show final choices: Get Job / Hire Now / Sign In
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Badhyata',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose how you’d like to start — find a job or hire talent.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Find a job',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmployerLogin(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      'Hire now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // optional sign-in link
           
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
          children: [
            Image.asset(
              'assets/job_bgr.png',
              height: 36,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
            const SizedBox(width: 10),
            Text(
              'Badhyata',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.secondary,
              ),
            ),
            const Spacer(),

            // Professional "More" dropdown (PopupMenu)
            Material(
              color: Colors.transparent,
              child: PopupMenuButton<_MoreAction>(
                tooltip: 'More options',
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // custom child to look like a small pill
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white10
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'More',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 20),
                    ],
                  ),
                ),
                onSelected: (_MoreAction value) {
                  switch (value) {
                    case _MoreAction.hr:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HrLoginPage()),
                      );
                      break;
                    case _MoreAction.admin:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AdminLoginPage()),
                      );
                      break;
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<_MoreAction>>[
                  PopupMenuItem<_MoreAction>(
                    value: _MoreAction.hr,
                    height: 52,
                    child: Row(
                      children: const [
                        Icon(Icons.people_alt_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('HR'),
                      ],
                    ),
                  ),
                  PopupMenuItem<_MoreAction>(
                    value: _MoreAction.admin,
                    height: 52,
                    child: Row(
                      children: const [
                        Icon(Icons.admin_panel_settings_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Admin'),
                      ],
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

  Widget _buildPage(_OnboardItem item, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        // subtle hero card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 22),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.06), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: width * 0.56,
                child: Image.asset(
                  item.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/job-removebg.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: Text(
            item.title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34.0),
          child: Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, index) => _buildPage(_pages[index], width),
            ),
          ),

          // page indicator + primary CTA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DotsIndicator(count: _pages.length, active: _page),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _goToNext,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _page == _pages.length - 1 ? 'Get started' : 'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // kept minimal footer; HR/Admin moved to More dropdown
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int active;
  const _DotsIndicator({required this.count, required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}

class _OnboardItem {
  final String image;
  final String title;
  final String subtitle;
  _OnboardItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
