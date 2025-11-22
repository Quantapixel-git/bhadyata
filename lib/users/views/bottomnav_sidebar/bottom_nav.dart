import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/fetch_user_profile.dart';
import 'package:jobshub/users/views/main_pages/assigned_job/assigned_jobs_page.dart';
import 'package:jobshub/users/views/main_pages/jobs/all_type_jobs_screen.dart';
import 'package:jobshub/users/views/main_pages/home/home_screen.dart';
import 'package:jobshub/users/views/main_pages/search/search_bottom_nav_page.dart';
import 'package:jobshub/users/views/main_pages/reward/reward_screen.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart'; // contains AppDrawerWrapper

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  bool _profileLoading = true; // <-- wait flag
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    AllJobsPage(),
    RewardScreen(),
    const AssignedJobsPage(), // new page
  ];

  final List<String> _titles = [
    "Home",
    "Search",
    "Jobs",
    "Rewards",
    "Assigned",
  ];
  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.work_outline,
    Icons.card_giftcard_outlined,
    Icons.assignment_turned_in, // assigned icon
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileBeforeShow();
  }

  Future<void> _loadProfileBeforeShow() async {
    setState(() => _profileLoading = true);
    try {
      final ok = await fetchAndStoreUserProfile();
      if (!mounted) return;
      setState(() => _profileLoading = false);
      if (!ok) {
        debugPrint('MainBottomNav: profile fetch returned false');
      }
    } catch (e, st) {
      debugPrint('MainBottomNav: error fetching profile: $e\n$st');
      if (!mounted) return;
      setState(() => _profileLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDrawerWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // while profile is loading, show a centered loader (inside drawer wrapper)
          if (_profileLoading) {
            return const Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          final bool isWeb = constraints.maxWidth > 800;

          if (isWeb) {
            // 💻 Web Layout (Top Nav)
            return Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 1,
                  toolbarHeight: 70,
                  titleSpacing: 20,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: List.generate(_titles.length, (index) {
                          final isSelected = _currentIndex == index;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: InkWell(
                              onTap: () =>
                                  setState(() => _currentIndex = index),
                              hoverColor: Colors.transparent,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _titles[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    height: 2,
                                    width: isSelected ? 22 : 0,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _pages[_currentIndex]),
              ],
            );
          } else {
            // 📱 Mobile Layout (Bottom Nav)
            return Scaffold(
              body: _pages[_currentIndex],
              bottomNavigationBar: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_icons.length, (index) {
                    final isSelected = _currentIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _currentIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _icons[index],
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey,
                              size: 26,
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              Text(
                                _titles[index],
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
