import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jobshub/users/applicans_page.dart';
import 'package:jobshub/users/home_page.dart';
import 'package:jobshub/users/jobs_screen.dart';
import 'package:jobshub/users/referal_screen.dart';
import 'package:jobshub/utils/AppColor.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
     HomePage(),
    const JobsPage(),
  const MyApplicationsPage(),
    const InviteFriendsScreen(),
  ];

  final List<String> _titles = [
    "Home",
    "Jobs",
    "My Applications",
    "Rewards",
  ];

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _buildWebLayout() : _buildMobileLayout();
  }

  /// 📱 Mobile Layout with Bottom Navigation
  Widget _buildMobileLayout() {
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "My Applications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Rewards"),
        ],
      ),
    );
  }

  /// 💻 Web Layout with Top Navigation + Logo
  Widget _buildWebLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Image.asset(
              "assets/job.png",
              height: 40,
            ),
            const SizedBox(width: 20),
            ...List.generate(_titles.length, (index) {
              final isSelected = _currentIndex == index;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = index),
                  child: Text(
                    _titles[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}
