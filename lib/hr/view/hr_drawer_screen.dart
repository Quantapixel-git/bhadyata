// HrDrawer.dart (Web-specific adjustments)
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
  final Widget? content; // Web-specific content to display
   HrDrawer({super.key, this.content});

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
          _drawerItem(context, Icons.work_outline, "Assign User Works", HrManageProjects(projects: projects)),
          _drawerItem(context, Icons.calendar_today, "Manage Attendance", HrAttendanceDashboardScreen()),
          _drawerItem(context, Icons.rate_review, "Candidates Review", HrCandidateReviewScreen()),
          _drawerItem(context, Icons.notifications_active, "View Notifications", HrNotificationView()),
          const Divider(),
          _drawerItem(context, Icons.logout, "Logout", const LoginScreen()),
        ],
      ),
    );

    if (isWeb) {
      // Web layout with permanent sidebar and content area
      return Row(
        children: [
          sidebar,
          Expanded(
            child: content ?? Container(color: Colors.grey[100]), // Render content passed from page
          ),
        ],
      );
    } else {
      // Mobile layout unchanged
      return Drawer(child: sidebar);
    }
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, Widget screen) {
  final bool isWeb = MediaQuery.of(context).size.width >= 900;

  if (isWeb) {
    // On web, rebuild sidebar with new content instead of navigation
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Material(  // Add Material wrapper
              child: HrDrawer(content: screen),
            ),
          ),
        );
      },
    );
  } else {
    // Mobile: keep pushReplacement
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
    );
  }
}
}
