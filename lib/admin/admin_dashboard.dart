import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_approved_screen.dart';
import 'package:jobshub/admin/admin_contact_us.dart';
import 'package:jobshub/admin/admin_job_status.dart';
import 'package:jobshub/admin/admin_user.dart';
import 'package:jobshub/admin/admin_view_notification_screen.dart';
import 'package:jobshub/admin/manage_kyc.dart';
import 'package:jobshub/admin/admin_report_page.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/utils/AppColor.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [_dashboardStats(context), const SizedBox(height: 24)],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/client.png"),
                ),
                SizedBox(height: 10),
                Text(
                  "Admin Panel",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "Mobile No: 9090909090",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          _drawerItem(
            context,
            Icons.dashboard,
            "Dashboard",
            AdminDashboardPage(),
          ),
          _drawerItem(
            context,
            Icons.dashboard,
            "Job Status",
            JobStatusScreen(),
          ),
          _drawerItem(context, Icons.dashboard, "Manage Users", AdminUser()),
          _drawerItem(context, Icons.person_search, "Manage KYC", ManageKyc()),
          _drawerItem(
            context,
            Icons.work_outline,
            "Manage Works",
            AdminApprovalScreen(projects: dummyProjects),
          ),
          _drawerItem(
            context,
            Icons.report,
            "Reports",
            AdminReportsPage(projects: dummyProjectsReports),
          ),

          _drawerItem(
            context,
            Icons.contact_page,
            "Contact Us",
            AdminContactUsPage(),
          ),

          _drawerItem(
            context,
            Icons.notifications,
            "View Notifications",
            AdminViewNotificationScreen(),
          ),
          _drawerItem(context, Icons.logout, "Log out", LoginScreen()),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close drawer
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }

  Widget _dashboardStats(BuildContext context) {
    // Example dashboard stats
    return Column(
      children: [
        Row(
          children: [
            _dashboardCard(
              "Pending KYC",
              "12",
              Colors.orange.shade400,
              Icons.person_search,
            ),
            _dashboardCard(
              "Pending Works",
              "8",
              Colors.purple.shade400,
              Icons.work_outline,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _dashboardCard(
              "Wallet Balance",
              "\$15230",
              Colors.green.shade400,
              Icons.account_balance_wallet,
            ),
            _dashboardCard("Users", "120", AppColors.primary, Icons.people),
          ],
        ),
      ],
    );
  }

  Widget _dashboardCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

final List<ProjectModelReport> dummyProjectsReports = [
  ProjectModelReport(
    title: "Website Development",
    category: "IT & Software",
    budget: 50000,
    paymentType: "Fixed",
    paymentValue: 50000,
    deadline: DateTime.now().add(Duration(days: 30)),
    applicants: [
      {"name": "Alice", "proposal": "I will build your website in Flutter"},
      {"name": "Bob", "proposal": "I can do it with ReactJS"},
    ],
    assignedUser: "Alice",
  ),
  ProjectModelReport(
    title: "Logo Design",
    category: "Design",
    budget: 5000,
    paymentType: "Fixed",
    paymentValue: 5000,
    deadline: DateTime.now().add(Duration(days: 10)),
    applicants: [
      {"name": "Charlie", "proposal": "Professional logo design"},
    ],
    assignedUser: "Charlie",
  ),
];
