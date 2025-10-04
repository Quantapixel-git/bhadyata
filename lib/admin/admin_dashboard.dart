import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

import 'admin_sidebar.dart'; // <-- import the common sidebar

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 900;

        return Scaffold(
          appBar: isWeb
              ? null
              : AppBar(
                  title: const Text(
                    "Admin Dashboard",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: AppColors.primary,
                ),
          drawer: isWeb
              ? null
              : const AdminSidebar(selectedPage: "Dashboard"),
          body: Row(
            children: [
              if (isWeb)
                Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        offset: const Offset(2, 0),
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: const AdminSidebar(
                    selectedPage: "Dashboard",
                    isWeb: true,
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    if (isWeb)
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Admin Dashboard",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                            const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/client.png"),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: _dashboardStats(context, isWeb),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- DASHBOARD STATS ----------------
  Widget _dashboardStats(BuildContext context, bool isWeb) {
    int crossAxisCount = isWeb ? 4 : 2;
    double childAspectRatio = isWeb ? 1.5 : 1.2;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: childAspectRatio,
      children: [
        _dashboardCard("Users", "120", AppColors.primary, Icons.people, isWeb),
        _dashboardCard("Active Projects", "25", Colors.indigo.shade400,
            Icons.assignment_turned_in, isWeb),
        _dashboardCard("Pending KYC", "12", Colors.orange.shade400,
            Icons.person_search, isWeb),
        _dashboardCard("Pending Works", "8", Colors.purple.shade400,
            Icons.work_outline, isWeb),
        _dashboardCard("Approved Works", "60", Colors.teal.shade400,
            Icons.check_circle_outline, isWeb),
        _dashboardCard("Rejected Works", "15", Colors.red.shade400,
            Icons.cancel_outlined, isWeb),
        _dashboardCard("KYC Verified", "75", Colors.blue.shade400,
            Icons.verified, isWeb),
        _dashboardCard("Wallet Balance", "\$15230", Colors.green.shade400,
            Icons.account_balance_wallet, isWeb),
      ],
    );
  }

  Widget _dashboardCard(
    String title, String value, Color color, IconData icon, bool isWeb) {
  if (isWeb) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Optional: handle card click for web
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } else {
    // Mobile version stays same
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

}
