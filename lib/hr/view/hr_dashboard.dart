import 'package:flutter/material.dart';
import 'package:jobshub/hr/view/hr_drawer_screen.dart';
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
                  child: HrDrawer(),
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
                    body: _buildDashboardContent(isWeb),
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
                "Hr Dashboard",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: AppColors.primary,
            ),
            drawer: HrDrawer(),
            body: _buildDashboardContent(isWeb),
            backgroundColor: Colors.grey[50],
          );
        }
      },
    );
  }

  Widget _buildDashboardContent(bool isWeb) {
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
    final double width = constraints.maxWidth;
    final bool isWide = width > 900; // desktop
    final crossAxisCount = isWide ? 4 : 2; // ✅ Always 2 on mobile/tablet

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
        crossAxisSpacing: isWide ? 24 : 16,
        mainAxisSpacing: isWide ? 24 : 16,
        childAspectRatio: isWide ? 1.9 : 1.5, // ✅ Equal height balance
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
        BoxShadow(
          color: color.withOpacity(0.25),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ Equal spacing
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: iconSize),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: valueFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: titleFont,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

}
