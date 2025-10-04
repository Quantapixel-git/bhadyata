import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

class HrSidebar extends StatelessWidget {
  final Function(String) onItemSelected;
  final String selectedPage;

  const HrSidebar({
    super.key,
    required this.onItemSelected,
    required this.selectedPage,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child:  Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/job_bgr.png"),
                ),
                 const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                                "Admin Panel",
                                style: TextStyle(color: Colors.black, fontSize: 18),
                              ),
                                Text(
                            "Mobile No: 9090909090",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                  ],
                ),
              ],
            ),
          ),
          _menuItem(
            context,
            Icons.dashboard,
            "Dashboard",
            "dashboard",
            () => onItemSelected("dashboard"),
          ),
          _menuItem(
            context,
            Icons.assignment,
            "Assign User Works",
            "assign",
            () => onItemSelected("assign"),
          ),
          _menuItem(
            context,
            Icons.access_time,
            "Manage Attendance",
            "attendance",
            () => onItemSelected("attendance"),
          ),
          _menuItem(
            context,
            Icons.people,
            "Candidates Review",
            "review",
            () => onItemSelected("review"),
          ),
          _menuItem(
            context,
            Icons.notifications,
            "View Notifications",
            "notifications",
            () => onItemSelected("notifications"),
          ),
          const Divider(),
          _menuItem(
            context,
            Icons.logout,
            "Logout",
            "logout",
            () => onItemSelected("logout"),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    String key,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selectedPage == key,
      onTap: () {
        Navigator.pop(context); // Close the drawer
        onTap(); // Call the provided onTap function
      },
    );
  }
}
