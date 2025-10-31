import 'package:flutter/material.dart';
import 'package:jobshub/users/views/alltype_jobs_page.dart';
import 'package:jobshub/users/views/home_page.dart';
import 'package:jobshub/users/views/jobs_screen.dart';
import 'package:jobshub/users/views/reward_screen.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/user_sidedrawer.dart'; // contains AppDrawerWrapper

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const SearchPage(),
    const AllJobsPage(),
    const RewardScreen(),
  ];

  final List<String> _titles = ["Home", "Search", "Jobs", "Rewards"];
  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.work_outline,
    Icons.card_giftcard_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return AppDrawerWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
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
