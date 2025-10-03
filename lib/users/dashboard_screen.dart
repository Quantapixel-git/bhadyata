import 'package:flutter/material.dart';
import 'package:jobshub/users/applicans_page.dart';
import 'package:jobshub/users/home_page.dart';
import 'package:jobshub/users/jobs_screen.dart';
import 'package:jobshub/users/profile_screen.dart';
import 'package:jobshub/utils/AppColor.dart';

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
    const JobsPage(),
    const MyApplicationsPage(),
    const ProfileScreen(),
  ];

  final List<String> _titles = ["Home", "Jobs", "My Applications", "Rewards"];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 800;

        if (isWeb) {
          // 💻 Web Layout
          return Scaffold(
            body: Row(
              children: [
                // 👉 Sidebar only if toggled on
                if (_showSidebar) const AppDrawer(),

                Expanded(
                  child: Column(
                    children: [
                      // Web AppBar
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 16),
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

                      // Page content
                      Expanded(child: _pages[_currentIndex]),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          // 📱 Mobile Layout
          return Scaffold(
            body: _pages[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Jobs",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.work),
                  label: "My Applications",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Rewards",
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
