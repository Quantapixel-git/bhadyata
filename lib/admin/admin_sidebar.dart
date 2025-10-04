import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_contact_us.dart';
import 'package:jobshub/admin/admin_dashboard.dart';
import 'package:jobshub/admin/admin_job_status.dart';
import 'package:jobshub/admin/admin_stats.dart';
import 'package:jobshub/admin/admin_user.dart';
import 'package:jobshub/admin/admin_view_notification_screen.dart';
import 'package:jobshub/admin/assigened_work.dart';
import 'package:jobshub/admin/manage_kyc.dart';
import 'package:jobshub/admin/admin_report_page.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/utils/AppColor.dart';

class AdminSidebar extends StatelessWidget {
  final String selectedPage; // current active page
  final bool isWeb; // layout flag

  const AdminSidebar({
    super.key,
    this.selectedPage = "Dashboard",
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        children: [
          // ---------- Top Header ----------
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/job_bgr.png"),
                ),
                const SizedBox(width: 12),
                if (!isWeb)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      const SizedBox(height: 15),
                      Text(
                        "Admin Panel",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Mobile No: 9090909090",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // ---------- Drawer Items ----------
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(context, Icons.dashboard, "Dashboard",
                    const AdminDashboardPage()),
                _drawerItem(
                    context, Icons.pie_chart, "Chart", AdminStats()),
                _drawerItem(context, Icons.assignment, "Assign Work",
                    AdminAssignedWorkListScreen()),
                _drawerItem(
                    context, Icons.report, "Job Status", JobStatusScreen()),
                _drawerItem(
                    context, Icons.person_4_outlined, "Manage Users", AdminUser()),
                _drawerItem(
                    context, Icons.person_search, "Manage KYC", ManageKyc()),
                _drawerItem(context, Icons.report, "Reports",
                    AdminReportsPage(projects: dummyProjectsReports)),
                _drawerItem(
                    context, Icons.contact_page, "Contact Us", AdminContactUsPage()),
                _drawerItem(context, Icons.notifications, "View Notifications",
                    AdminViewNotificationScreen()),
                _drawerItem(context, Icons.logout, "Log out", LoginScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, Widget page) {
    final bool active = selectedPage == title;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ListTile(
        leading: Icon(icon, color: active ? AppColors.primary : null),
        title: Text(
          title,
          style: TextStyle(
            color: active ? AppColors.primary : Colors.black87,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        hoverColor: isWeb ? Colors.blue.shade50 : null,
        onTap: () {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (_) => page), (route) => false);
        },
      ),
    );
  }
}

// ---- Dummy Report List ----
final List<ProjectModelReport> dummyProjectsReports = [
  ProjectModelReport(
    title: "Website Development",
    category: "IT & Software",
    budget: 50000,
    paymentType: "Fixed",
    paymentValue: 50000,
    deadline: DateTime.now().add(const Duration(days: 30)),
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
    deadline: DateTime.now().add(const Duration(days: 10)),
    applicants: [
      {"name": "Charlie", "proposal": "Professional logo design"},
    ],
    assignedUser: "Charlie",
  ),
];
