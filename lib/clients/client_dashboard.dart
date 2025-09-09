import 'package:flutter/material.dart';

class ClientDashboardPage extends StatelessWidget {
  const ClientDashboardPage({super.key});

  // Mock data
  final int totalWorks = 12;
  final int pendingApproval = 5;
  final int completedWorks = 7;
  final double walletBalance = 12500.50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Client Dashboard"),
  backgroundColor: Colors.blue.shade700,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/client.png"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome, Client",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "client@email.com",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text("Add Work"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text("View Works"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text("Payments / Wallet"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("Referrals"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Quick Stats Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard(
                  title: "Total Works",
                  value: totalWorks.toString(),
                  color: Colors.blue.shade400,
                  icon: Icons.work,
                ),
                _statCard(
                  title: "Pending Approval",
                  value: pendingApproval.toString(),
                  color: Colors.orange.shade400,
                  icon: Icons.pending_actions,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard(
                  title: "Completed Works",
                  value: completedWorks.toString(),
                  color: Colors.green.shade400,
                  icon: Icons.check_circle_outline,
                ),
                _statCard(
                  title: "Wallet Balance",
                  value: "\$${walletBalance.toStringAsFixed(2)}",
                  color: Colors.purple.shade400,
                  icon: Icons.account_balance_wallet,
                ),
              ],
            ),
            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
