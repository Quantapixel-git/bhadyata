import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_side_bar.dart';
import 'package:jobshub/users/views/project_model.dart';

class EmployerDashboardPage extends StatelessWidget {
  EmployerDashboardPage({super.key});

  // Example Data
  final int totalSalaryJobs = 5;
  final int totalCommissionJobs = 3;
  final int assignedEmployees = 7;
  final double totalDeposits = 25000.75;
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
        {'name': 'Bob Smith', 'proposal': 'I’ll deliver in 2 days.'},
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
        {'name': 'Charlie Brown', 'proposal': 'Experienced in sales.'},
        {'name': 'Daisy Miller', 'proposal': 'Wide network, quick results.'},
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              // ✅ AppBar (same as AdminDashboard)
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // hide drawer icon on web
                title: const Text(
                  "Employer Dashboard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
              ),

              // ✅ Dashboard Content
              Expanded(child: _buildDashboardContent(isWeb)),
            ],
          ),
        );
      },
    );
  }

  // ---------- DASHBOARD CONTENT ----------
  Widget _buildDashboardContent(bool isWeb) {
    final stats = [
      {
        "title": "Salary-Based Jobs",
        "value": totalSalaryJobs.toString(),
        "color": Colors.blue.shade400,
        "icon": Icons.attach_money,
      },
      {
        "title": "Commission Jobs",
        "value": totalCommissionJobs.toString(),
        "color": Colors.orange.shade400,
        "icon": Icons.bar_chart,
      },
      {
        "title": "Employees",
        "value": assignedEmployees.toString(),
        "color": Colors.green.shade400,
        "icon": Icons.people_alt,
      },
      {
        "title": "Wallet Balance",
        "value": "₹${walletBalance.toStringAsFixed(2)}",
        "color": Colors.purple.shade400,
        "icon": Icons.account_balance_wallet,
      },
      {
        "title": "Deposits",
        "value": "₹${totalDeposits.toStringAsFixed(2)}",
        "color": Colors.teal.shade400,
        "icon": Icons.payments_outlined,
      },
      {
        "title": "Projects",
        "value": projects.length.toString(),
        "color": Colors.indigo.shade400,
        "icon": Icons.work_outline,
      },
    ];

    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Greeting (Mobile only)
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

            // 💼 Projects Section (shown only on web)
            if (isWeb) _buildProjectsSection(),
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

  // ---------- PROJECTS SECTION (Web only) ----------
  Widget _buildProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Active Projects",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...projects.map(
          (p) => Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo.shade50,
                child: const Icon(Icons.work_outline, color: Colors.indigo),
              ),
              title: Text(p.title),
              subtitle: Text(p.description),
              trailing: Text(
                p.status,
                style: TextStyle(
                  color: p.status == 'In Progress'
                      ? Colors.orange
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
