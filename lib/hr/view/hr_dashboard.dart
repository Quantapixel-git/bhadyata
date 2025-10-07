import 'package:flutter/material.dart';
import 'package:jobshub/hr/view/hr_attendance_dashboard_screen.dart';
import 'package:jobshub/hr/view/hr_candidate_review_screen.dart';
import 'package:jobshub/hr/view/hr_manage_projects.dart';
import 'package:jobshub/hr/view/hr_notification_view.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/users/project_model.dart';
import 'package:jobshub/utils/AppColor.dart';

class HrDashboard extends StatelessWidget {
  HrDashboard({super.key});

  final int totalWorks = 12;
  final int pendingApproval = 5;
  final int completedWorks = 7;
  final double walletBalance = 12500.50;

  final List<ProjectModel> projects = [
    ProjectModel(
      title: 'Website Design',
      description: 'Landing page project',
      budget: 5000,
      category: 'Design',
      paymentType: 'Salary',
      paymentValue: 5000,
      status: 'In Progress',
      deadline: DateTime.now().add(const Duration(days: 7)),
      applicants: [
        {'name': 'Alice Johnson', 'proposal': 'I can complete this in 3 days.'},
        {'name': 'Bob Smith', 'proposal': 'I’ll deliver responsive design fast.'},
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        if (isWeb) {
          return Scaffold(
            body: Row(
              children: [
                // Permanent Sidebar
                SizedBox(
                  width: 250,
                  child: _hrSidebar(context, isWeb: true),
                ),
                Expanded(
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text(
                        "HR Dashboard",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 22,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                    ),
                    body: _dashboardContent(isWeb),
                    backgroundColor: Colors.grey[100],
                  ),
                ),
              ],
            ),
          );
        } else {
          // Mobile layout with drawer
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "HR Dashboard",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: AppColors.primary,
            ),
            drawer: Drawer(child: _hrSidebar(context)),
            body: _dashboardContent(isWeb),
            backgroundColor: Colors.grey[50],
          );
        }
      },
    );
  }

  // ---------- Sidebar ----------
  Widget _hrSidebar(BuildContext context, {bool isWeb = false}) {
    return Container(
      color: Colors.pink.shade50,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/job_bgr.png"),
                ),
                SizedBox(height: 10),
                Text("Welcome, HR", style: TextStyle(color: Colors.white, fontSize: 18)),
                Text("Mobile No: 9090909090", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          _drawerItem(context, Icons.dashboard, "Dashboard", HrDashboard()),
          _drawerItem(context, Icons.work_outline, "Assign User Works", HrManageProjects(projects: [])),
          _drawerItem(context, Icons.calendar_today, "Manage Attendance", HrAttendanceDashboardScreen()),
          _drawerItem(context, Icons.rate_review, "Candidates Review", HrCandidateReviewScreen()),
          _drawerItem(context, Icons.notifications_active, "View Notifications", HrNotificationView()),
          const Divider(),
          _drawerItem(context, Icons.logout, "Logout", const LoginScreen()),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }

  // ---------- Dashboard Content ----------
  Widget _dashboardContent(bool isWeb) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final crossAxisCount = width > 900 ? 4 : 2;

                  final stats = [
                    _statCard("Total Works", totalWorks.toString(), AppColors.primary, Icons.work, isWeb),
                    _statCard("Pending Approval", pendingApproval.toString(), Colors.orange.shade400, Icons.pending_actions, isWeb),
                    _statCard("Completed Works", completedWorks.toString(), Colors.green.shade400, Icons.check_circle_outline, isWeb),
                    _statCard("Wallet Balance", "\$${walletBalance.toStringAsFixed(2)}", Colors.purple.shade400, Icons.account_balance_wallet, isWeb),
                  ];

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: width > 900 ? 24 : 16,
                      mainAxisSpacing: width > 900 ? 24 : 16,
                      childAspectRatio: width > 900 ? 1.9 : 1.5,
                    ),
                    itemCount: stats.length,
                    itemBuilder: (context, index) => stats[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Stat Card ----------
  Widget _statCard(String title, String value, Color color, IconData icon, bool isWeb) {
    final double iconSize = isWeb ? 38 : 30;
    final double valueFont = isWeb ? 24 : 20;
    final double titleFont = isWeb ? 16 : 14;
    final double padding = isWeb ? 20 : 16;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: iconSize),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: valueFont, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(title, style: TextStyle(color: Colors.white70, fontSize: titleFont, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
