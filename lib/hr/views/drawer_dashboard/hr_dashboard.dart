import 'package:flutter/material.dart';
import 'package:jobshub/hr/views/drawer_dashboard/hr_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/project_model.dart';

class HrDashboard extends StatelessWidget {
  HrDashboard({super.key});

  // Example Data (Adapted for HR)
  final int totalWorks = 12;
  final int pendingApproval = 5;
  final int completedWorks = 7;
  final double walletBalance = 12500.50;
  final double totalRevenue = 50000.00; // Added for HR
  final int totalEmployees = 25; // Added for HR

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
    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "HR Dashboard",
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
        "title": "Total Works",
        "value": totalWorks.toString(),
        "color": Colors.blue.shade400,
        "icon": Icons.work,
      },
      {
        "title": "Pending Approval",
        "value": pendingApproval.toString(),
        "color": Colors.orange.shade400,
        "icon": Icons.pending_actions,
      },
      {
        "title": "Completed Works",
        "value": completedWorks.toString(),
        "color": Colors.green.shade400,
        "icon": Icons.check_circle_outline,
      },
      {
        "title": "Wallet Balance",
        "value": "₹${walletBalance.toStringAsFixed(2)}",
        "color": Colors.purple.shade400,
        "icon": Icons.account_balance_wallet,
      },
      {
        "title": "Total Revenue",
        "value": "₹${totalRevenue.toStringAsFixed(2)}",
        "color": Colors.teal.shade400,
        "icon": Icons.attach_money,
      },
      {
        "title": "Total Employees",
        "value": totalEmployees.toString(),
        "color": Colors.indigo.shade400,
        "icon": Icons.people_alt,
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
                      "Here’s an overview of your work and balance.",
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
