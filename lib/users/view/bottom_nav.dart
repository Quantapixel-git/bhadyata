import 'package:flutter/material.dart';
import 'package:jobshub/users/view/alltype_jobs_page.dart';
import 'package:jobshub/users/view/home_page.dart';
import 'package:jobshub/users/view/jobs_screen.dart';
import 'package:jobshub/users/view/reward_screen.dart';
import 'package:jobshub/users/view/user_sidedrawer.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _currentIndex = 0;
  bool _showSidebar = false;

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
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 800;

        if (isWeb) {
          // 💻 Web Layout (same as before)
          return Scaffold(
            body: Row(
              children: [
                if (_showSidebar) const AppDrawer(),
                Expanded(
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.white,
                        elevation: 1,
                        toolbarHeight: 70,
                        titleSpacing: 20,
                        leading: IconButton(
                          icon: const Icon(Icons.menu, color: Colors.black87),
                          onPressed: () =>
                              setState(() => _showSidebar = !_showSidebar),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: List.generate(_titles.length, (index) {
                                final isSelected = _currentIndex == index;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
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
                                        if (isSelected)
                                          Container(
                                            height: 2,
                                            width: 20,
                                            color: AppColors.primary,
                                          )
                                        else
                                          const SizedBox(height: 2),
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
                  ),
                ),
              ],
            ),
          );
        } else {
          // 📱 Mobile Layout (Custom Bottom Navigation)
          return Scaffold(
            body: _pages[_currentIndex],
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                            color: isSelected ? AppColors.primary : Colors.grey,
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
    );
  }
}
