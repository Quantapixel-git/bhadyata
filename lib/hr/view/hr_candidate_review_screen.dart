import 'package:flutter/material.dart';
import 'package:jobshub/hr/view/hr_attendance_dashboard_screen.dart';
import 'package:jobshub/hr/view/hr_manage_projects.dart';
import 'package:jobshub/hr/view/hr_notification_view.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/users/project_model.dart';
import 'package:jobshub/utils/AppColor.dart';

class HrCandidateReviewScreen extends StatefulWidget {
  final bool embedded;

  const HrCandidateReviewScreen({
    super.key,
    this.embedded = false,
  });

  @override
  State<HrCandidateReviewScreen> createState() =>
      _HrCandidateReviewScreenState();
}

class _HrCandidateReviewScreenState extends State<HrCandidateReviewScreen> {
  String _selectedPage = "review";

  final List<Map<String, dynamic>> reviews = const [
    {
      "candidate": "John Doe",
      "job": "Mobile App Development",
      "rating": 4.5,
      "review": "Very professional and delivered on time.",
    },
    {
      "candidate": "Jane Smith",
      "job": "UI/UX Design",
      "rating": 5.0,
      "review": "Creative and detail-oriented designer!",
    },
    {
      "candidate": "Mike Johnson",
      "job": "Backend Developer",
      "rating": 4.0,
      "review": "Good work, but needs minor improvements.",
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

  void _onItemSelected(String key) {
    setState(() {
      _selectedPage = key;
    });

    if (MediaQuery.of(context).size.width < 900) {
      // Mobile: navigate to new screen
      switch (key) {
        case "assign":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HrManageProjects(projects: projects),
            ),
          );
          break;
        case "attendance":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HrAttendanceDashboardScreen(),
            ),
          );
          break;
        case "notifications":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HrNotificationScreen(),
            ),
          );
          break;
        case "logout":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          );
          break;
      }
    }
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: AppColors.primary, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review["candidate"],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Job: ${review["job"]}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < review["rating"].floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(review["review"], style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewContent() {
    return Container(
      color: Colors.pink.shade50,
      child: ListView(
        padding:
            widget.embedded ? EdgeInsets.zero : const EdgeInsets.all(16.0),
        children: reviews.map(_buildReviewCard).toList(),
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_selectedPage) {
      case "assign":
        return HrManageProjects(projects: projects);
      case "attendance":
        return HrAttendanceDashboardScreen();
      case "notifications":
        return HrNotificationScreen();
      case "logout":
        return const LoginScreen();
      case "review":
      default:
        return _buildReviewContent();
    }
  }

  // ---------------- Sidebar / Drawer ----------------
  Widget _buildSidebar(BuildContext context, bool isWeb) {
    Widget sidebarContent = Container(
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

    if (isWeb) {
      return sidebarContent; // Permanent sidebar for web
    } else {
      return Drawer(child: sidebarContent); // Drawer for mobile
    }
  }

  Widget _drawerItem(IconData icon, String title, String key) {
    final selected = _selectedPage == key;
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.primary : Colors.black54),
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
    final bool isWeb = MediaQuery.of(context).size.width > 900;

    if (widget.embedded) {
      _selectedPage = "review";
      return _buildReviewContent();
    }

    return Scaffold(
      appBar: isWeb
          ? null
          : AppBar(
              title: const Text(
                "Candidate Reviews",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: AppColors.primary,
            ),
      drawer: isWeb ? null : _buildSidebar(context, false),
      body: Row(
        children: [
          if (isWeb) _buildSidebar(context, true), // Permanent sidebar
          Expanded(child: _buildPageContent()),
        ],
      ),
    );
  }
}
