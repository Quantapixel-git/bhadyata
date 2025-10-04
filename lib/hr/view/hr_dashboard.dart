import 'package:flutter/material.dart';
import 'package:jobshub/hr/view/hr_sidebar.dart';
import 'package:jobshub/hr/view/hr_work_assign_screen.dart';
import 'package:jobshub/clients/client_review_screen.dart';
import 'package:jobshub/clients/client_view_notification.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/users/project_model.dart';
import 'package:jobshub/utils/AppColor.dart';

class HrDashboard extends StatefulWidget {
  const HrDashboard({super.key});

  @override
  State<HrDashboard> createState() => _HrDashboardState();
}

class _HrDashboardState extends State<HrDashboard> {
  String _selectedPage = "dashboard";

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
        {'name': 'Alice Johnson', 'proposal': 'I can complete this in 3 days with high quality.'},
        {'name': 'Bob Smith', 'proposal': 'I will deliver in 2 days with responsive design.'},
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
        {'name': 'Charlie Brown', 'proposal': 'Experienced in sales, I’ll close deals in 4 days.'},
        {'name': 'Daisy Miller', 'proposal': 'I have a wide network, can boost sales quickly.'},
      ],
    ),
  ];

  void _onItemSelected(String key) {
    setState(() {
      _selectedPage = key;
    });

    Widget screen;
    switch (key) {
      case "assign":
        screen = const HrAssignedWorkListScreen();
        break;
      case "attendance":
        screen =  HrAssignedWorkListScreen();
        break;
      case "review":
        screen =  CandidateReviewsScreen();
        break;
      case "notifications":
        screen =  ClientViewNotification();
        break;
      case "logout":
        screen = const LoginScreen();
        break;
      default:
        screen = widget;
    }

    // Only navigate on mobile; on web we keep content in the main area
    if (MediaQuery.of(context).size.width < 900) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      // On web, update the main content if you want dynamic web content
      // For now, we just show dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        if (isWeb) {
          return Scaffold(
            body: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: HrSidebar(
                    selectedPage: _selectedPage,
                    onItemSelected: _onItemSelected,
                  ),
                ),
                Expanded(
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text(
                        "HR Dashboard",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                    ),
                    body: _buildDashboardContent(),
                    backgroundColor: Colors.grey[100],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "HR Dashboard",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: AppColors.primary,
            ),
            drawer: HrSidebar(
              selectedPage: _selectedPage,
              onItemSelected: _onItemSelected,
            ),
            body: _buildDashboardContent(),
          );
        }
      },
    );
  }

  Widget _buildDashboardContent() {
    return Padding(
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
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
          ],
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
