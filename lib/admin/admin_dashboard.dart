import 'package:flutter/material.dart';
import 'package:jobshub/admin/manage_kyc.dart';
import 'package:jobshub/admin/manage_works.dart';
import 'package:jobshub/admin/payment_page.dart';
import 'package:jobshub/admin/reffereal_page.dart';
import 'package:jobshub/admin/report_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.blue.shade700,
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _dashboardStats(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: const Text(
              "Admin Panel",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          _drawerItem(context, Icons.dashboard, "Dashboard", AdminDashboardPage()),
          _drawerItem(context, Icons.person_search, "Approve KYC", const ManageKyc()),
          _drawerItem(context, Icons.work_outline, "Approve Works", const ManageWorks()),
          _drawerItem(context, Icons.report, "Reports", const ReportsPage()),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close drawer
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }

  Widget _dashboardStats(BuildContext context) {
    // Example dashboard stats
    return Column(
      children: [
        Row(
          children: [
            _dashboardCard("Pending KYC", "12", Colors.orange.shade400, Icons.person_search),
            _dashboardCard("Pending Works", "8", Colors.purple.shade400, Icons.work_outline),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _dashboardCard("Wallet Balance", "\$15230", Colors.green.shade400, Icons.account_balance_wallet),
            _dashboardCard("Users", "120", Colors.blue.shade400, Icons.people),
          ],
        ),
      ],
    );
  }

  Widget _dashboardCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
