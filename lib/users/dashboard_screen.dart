import 'package:flutter/material.dart';
import 'package:jobshub/users/applicans_page.dart';
import 'package:jobshub/users/home_page.dart';
import 'package:jobshub/users/jobs_screen.dart';
import 'package:jobshub/users/referal_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
   HomePage(),
   JobsPage(),
   MyApplicationsPage(),
   InviteFriendsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // show selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "My Appliances",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Rewards",
          ),
        ],
      ),
    );
  }
}
