import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/auth/admin_login.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/views/onboarding/banner_crousel_section.dart';
import 'package:jobshub/common/views/onboarding/city_categories_job_section.dart';
import 'package:jobshub/common/views/onboarding/company_crousel_section.dart';
import 'package:jobshub/common/views/onboarding/expandable_feature_section.dart';
import 'package:jobshub/common/views/onboarding/faq_section.dart';
import 'package:jobshub/common/views/onboarding/footer_section.dart';
import 'package:jobshub/common/views/onboarding/hero_section.dart';
import 'package:jobshub/common/views/onboarding/opportunity_section.dart';
import 'package:jobshub/common/views/onboarding/over_number_section.dart';
import 'package:jobshub/common/views/onboarding/review_section.dart';
import 'package:jobshub/common/views/onboarding/what_makes_badhyata_better_section.dart';
import 'package:jobshub/common/views/onboarding/who_using_badhyata_section.dart';
import 'package:jobshub/employer/views/auth/employer_login.dart';
import 'package:jobshub/hr/views/auth/hr_login_screen.dart';
import 'package:jobshub/users/views/auth/login_screen.dart';

class WebOnboardingPage extends StatelessWidget {
  const WebOnboardingPage({super.key});

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
            SizedBox(height: 10),
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
            SizedBox(height: 20),
            AutoBannerSlider(
              images: [
                'assets/test_two.jpg',
                'assets/test_two.jpg',
                'assets/test_two.jpg',
              ],
              desktopHeight: 290,
              mobileHeight: 180,
              autoPlayInterval: const Duration(seconds: 4),
            ),
            SizedBox(height: 30),
            ExpandableFeatureCards(),
            SizedBox(height: 10),
            WhatMakesWorkIndiaBetterSection(),
            EmployerReviewsSection(),
            SizedBox(height: 20),
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
            OpportunityCategoriesSection(),
            EmployerFaqSection(),
            OurNumbersSection(),
            SizedBox(height: 0),
            WorkIndiaFooter(),
          ],
        ),
      ),
    );
  }


  // ---------------- show roles popup ----------------
  Future<void> _showRolesMenu(BuildContext ctx) async {
    // Ensure ctx is the RenderObject of the button by calling this from a Builder
    final RenderBox button = ctx.findRenderObject() as RenderBox;
    final Offset topLeft = button.localToGlobal(Offset.zero);
    final RelativeRect position = RelativeRect.fromLTRB(
      topLeft.dx,
      topLeft.dy + button.size.height,
      topLeft.dx + button.size.width,
      0,
    );

    final selected = await showMenu<String>(
      context: ctx,
      position: position,
      items: [
        const PopupMenuItem(value: 'company', child: Text('Company')),
        const PopupMenuItem(value: 'teamlead', child: Text('Team Lead')),
        const PopupMenuItem(value: 'hr', child: Text('HR')),
        const PopupMenuItem(value: 'admin', child: Text('Admin')),
      ],
    );

    if (selected == null) return;

    switch (selected) {
      case 'company':
        // Navigate to company page if you have one
        // Navigator.push(ctx, MaterialPageRoute(builder: (_) => CompanyPage()));
        break;
      case 'teamlead':
        // Navigator.push(ctx, MaterialPageRoute(builder: (_) => TeamLeadPage()));
        break;
      case 'hr':
        Navigator.push(ctx, MaterialPageRoute(builder: (c) => HrLoginPage()));
        break;
      case 'admin':
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (c) => AdminLoginPage()),
        );
        break;
    }
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

              // const Spacer(),

              // === DESKTOP SEARCH BAR ===
              if (isDesktop)
                Expanded(
                  // flex: 25,
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
                    SizedBox(width: 200),

                    // ---- MORE DROPDOWN (hover or click) ----
                    Builder(
                      builder: (ctx) {
                        return MouseRegion(
                          onEnter: (_) {
                            // open on hover for desktop/web
                            _showRolesMenu(ctx);
                          },
                          child: GestureDetector(
                            onTap: () =>
                                _showRolesMenu(ctx), // open on click/tap
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'More',
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'Find a job',
                          style: TextStyle(color: AppColors.secondary),
                        ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: const Text(
                          'Hire Now',
                          style: TextStyle(color: Colors.white),
                        ),
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
}

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
