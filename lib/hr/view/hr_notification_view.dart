import 'package:flutter/material.dart';
import 'package:jobshub/hr/view/hr_attendance_dashboard_screen.dart';
import 'package:jobshub/hr/view/hr_candidate_review_screen.dart';
import 'package:jobshub/hr/view/hr_dashboard.dart';
import 'package:jobshub/hr/view/hr_manage_projects.dart';
import 'package:jobshub/hr/view/hr_work_assign_screen.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/users/project_model.dart';
import 'package:jobshub/utils/AppColor.dart';

class HrNotificationScreen extends StatefulWidget {
  final bool embedded;

  const HrNotificationScreen({super.key, this.embedded = false});

  @override
  State<HrNotificationScreen> createState() => _HrNotificationScreenState();
}

class _HrNotificationScreenState extends State<HrNotificationScreen> {
  String _selectedPage = "notifications";

  final List<Map<String, String>> notifications = [
    {
      "title": "New Job Posted",
      "message": "A new software developer job has been posted.",
      "date": "29 Sept 2025",
    },
    {
      "title": "Payment Reminder",
      "message": "Your subscription will expire soon. Renew now.",
      "date": "27 Sept 2025",
    },
    {
      "title": "System Update",
      "message": "Dashboard features updated for better performance.",
      "date": "25 Sept 2025",
    },
  ];

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
    ProjectModel(
      title: 'Sales Partner',
      description: 'Earn commission per sale',
      budget: 0,
      category: 'Marketing',
      paymentType: 'Commission',
      paymentValue: 15,
      status: 'In Progress',
      deadline: DateTime.now().add(const Duration(days: 15)),
      applicants: [
        {'name': 'Charlie Brown', 'proposal': 'Experienced in closing deals.'},
        {'name': 'Daisy Miller', 'proposal': 'Wide network to boost sales.'},
      ],
    ),
  ];

  // Handle menu item tap
  void _onItemSelected(String key) {
    setState(() => _selectedPage = key);

    if (MediaQuery.of(context).size.width < 900) {
      Widget screen;
      switch (key) {
        case "assign":
          screen = HrManageProjects(projects: projects);
          break;
        case "review":
          screen = const HrCandidateReviewScreen();
          break;
        case "attendance":
          screen = const HrAttendanceDashboardScreen();
          break;
        case "notifications":
          screen = const HrNotificationScreen();
          break;
        case "logout":
          screen = const LoginScreen();
          break;
        default:
          screen = HrDashboard();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    }
  }

  // Notification List
  Widget _buildNotificationsList() {
    return Container(
      color: Colors.pink.shade50,
      child: Padding(
        padding:
            widget.embedded ? EdgeInsets.zero : const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading:
                    const Icon(Icons.notifications, color: AppColors.primary),
                title: Text(
                  notif["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notif["message"]!),
                    const SizedBox(height: 4),
                    Text(
                      notif["date"]!,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Choose page content
  Widget _buildPageContent() {
    switch (_selectedPage) {
      case "assign":
        return const HrWorkAssignScreen();
      case "review":
        return const HrCandidateReviewScreen();
      case "attendance":
        return const HrAttendanceDashboardScreen();
      case "notifications":
      default:
        return _buildNotificationsList();
    }
  }

  // Drawer / Sidebar
  Widget _buildSidebar(BuildContext context, bool isWeb) {
    Widget sidebar = Container(
      width: 250,
      color: Colors.white,
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
                Text("Welcome, HR",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Text("Mobile No: 9090909090",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          _drawerItem(Icons.work_outline, "Assign User Works", "assign"),
          _drawerItem(Icons.calendar_today, "Manage Attendance", "attendance"),
          _drawerItem(Icons.rate_review, "Candidates Review", "review"),
          _drawerItem(Icons.notifications_active, "View Notifications", "notifications"),
          _drawerItem(Icons.logout, "Logout", "logout"),
        ],
      ),
    );

    return isWeb ? sidebar : Drawer(child: sidebar);
  }

  Widget _drawerItem(IconData icon, String title, String key) {
    final selected = _selectedPage == key;
    return ListTile(
      leading: Icon(icon,
          color: selected ? AppColors.primary : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? AppColors.primary : Colors.black87,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        if (MediaQuery.of(context).size.width < 900) Navigator.pop(context);
        _onItemSelected(key);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width >= 900;

    // Embedded (for web integration)
    if (widget.embedded) {
      _selectedPage = "notifications";
      return _buildNotificationsList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
      ),
      drawer: isWeb ? null : _buildSidebar(context, false),
      body: Row(
        children: [
          if (isWeb) _buildSidebar(context, true),
          Expanded(child: _buildPageContent()), // ✅ always show content
        ],
      ),
    );
  }
}
