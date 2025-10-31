import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart'; // Import the AdminSidebar
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/project_model.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  // Example Data (Adapted for Admin)
  final int totalUsers = 120;
  final int activeProjects = 25;
  final int pendingKYC = 12;
  final int pendingWorks = 8;
  final int approvedWorks = 60;
  final int rejectedWorks = 15;
  final int kycVerified = 75;
  final double walletBalance = 15230.00;

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
        {
          'name': 'Bob Smith',
          'proposal': 'I’ll deliver responsive design fast.',
        },
      ],
    ),
    // Add more projects if needed
  ];

  @override
  Widget build(BuildContext context) {
    return AdminDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Admin Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.primary,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWeb = constraints.maxWidth >= 900;
            return _buildDashboardContent(isWeb);
          },
        ),
      ),
    );
  }

  // ---------- DASHBOARD CONTENT ----------
  Widget _buildDashboardContent(bool isWeb) {
    final stats = [
      {
        "title": "Users",
        "value": totalUsers.toString(),
        "color": AppColors.primary,
        "icon": Icons.people,
      },
      {
        "title": "Active Projects",
        "value": activeProjects.toString(),
        "color": Colors.indigo.shade400,
        "icon": Icons.assignment_turned_in,
      },
      {
        "title": "Pending KYC",
        "value": pendingKYC.toString(),
        "color": Colors.orange.shade400,
        "icon": Icons.person_search,
      },
      {
        "title": "Pending Works",
        "value": pendingWorks.toString(),
        "color": Colors.purple.shade400,
        "icon": Icons.work_outline,
      },
      {
        "title": "Approved Works",
        "value": approvedWorks.toString(),
        "color": Colors.teal.shade400,
        "icon": Icons.check_circle_outline,
      },
      {
        "title": "Rejected Works",
        "value": rejectedWorks.toString(),
        "color": Colors.red.shade400,
        "icon": Icons.cancel_outlined,
      },
      {
        "title": "KYC Verified",
        "value": kycVerified.toString(),
        "color": Colors.blue.shade400,
        "icon": Icons.verified,
      },
      {
        "title": "Wallet Balance",
        "value": "\$${walletBalance.toStringAsFixed(2)}",
        "color": Colors.green.shade400,
        "icon": Icons.account_balance_wallet,
      },
    ];

    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Greeting Section (Mobile Only)
            if (!isWeb)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Welcome Back 👋",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Here’s an overview of your admin panel.",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              ),

            // 📊 Stats Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = isWeb ? 4 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isWeb ? 1.8 : 1.4,
                  ),
                  itemCount: stats.length,
                  itemBuilder: (context, index) {
                    final stat = stats[index];
                    return _statCard(
                      stat['title'] as String,
                      stat['value'] as String,
                      stat['color'] as Color,
                      stat['icon'] as IconData,
                      isWeb,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------- STAT CARD ----------
  Widget _statCard(
    String title,
    String value,
    Color color,
    IconData icon,
    bool isWeb,
  ) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(isWeb ? 18 : 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: isWeb ? 36 : 30),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: isWeb ? 24 : 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: isWeb ? 15 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
