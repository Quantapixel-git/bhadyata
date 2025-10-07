import 'package:flutter/material.dart';
import 'package:jobshub/hr/view/hr_attendance_dashboard_screen.dart';
import 'package:jobshub/hr/view/hr_candidate_review_screen.dart';
import 'package:jobshub/hr/view/hr_dashboard.dart';
import 'package:jobshub/hr/view/hr_manage_projects.dart';
import 'package:jobshub/hr/view/hr_notification_view.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/users/project_model.dart';
import 'package:jobshub/utils/AppColor.dart';

class HrDrawer extends StatelessWidget {
  HrDrawer({super.key});

  // Mock data
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
    final bool isWeb = MediaQuery.of(context).size.width >= 900;

    Widget sidebar = Container(
      width: 250,
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
          _drawerItem(context, Icons.notifications_active, "View Notifications", HrNotificationScreen()),
          const Divider(),
          _drawerItem(context, Icons.logout, "Logout", const LoginScreen()),
        ],
      ),
    );

    if (isWeb) {
      // Permanent sidebar layout for web
      return Row(
        children: [
          sidebar,
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: const Text("HR Dashboard", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statCard("Total Works", totalWorks.toString(), AppColors.primary, Icons.work),
                        _statCard("Pending Approval", pendingApproval.toString(), Colors.orange.shade400, Icons.pending_actions),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statCard("Completed Works", completedWorks.toString(), Colors.green.shade400, Icons.check_circle_outline),
                        _statCard("Wallet Balance", "\$${walletBalance.toStringAsFixed(2)}", Colors.purple.shade400, Icons.account_balance_wallet),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Mobile layout with drawer
      return Scaffold(
        appBar: AppBar(
          title: const Text("HR Dashboard", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: AppColors.primary,
        ),
        drawer: Drawer(child: sidebar),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statCard("Total Works", totalWorks.toString(), AppColors.primary, Icons.work),
                  _statCard("Pending Approval", pendingApproval.toString(), Colors.orange.shade400, Icons.pending_actions),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statCard("Completed Works", completedWorks.toString(), Colors.green.shade400, Icons.check_circle_outline),
                  _statCard("Wallet Balance", "\$${walletBalance.toStringAsFixed(2)}", Colors.purple.shade400, Icons.account_balance_wallet),
                ],
              ),
            ],
          ),
        ),
      );
    }
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

  Widget _statCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const Spacer(),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
