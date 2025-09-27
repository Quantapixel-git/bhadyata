import 'package:flutter/material.dart';
import 'package:jobshub/clients/client_assign_user_screen.dart';
import 'package:jobshub/clients/client_create_project.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/users/project_model.dart';
import 'package:jobshub/utils/AppColor.dart';

class ClientDashboardPage extends StatelessWidget {
  ClientDashboardPage({super.key});

  // Mock data
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
        {
          'name': 'Alice Johnson',
          'proposal': 'I can complete this in 3 days with high quality.',
        },
        {
          'name': 'Bob Smith',
          'proposal': 'I will deliver in 2 days with responsive design.',
        },
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
        {
          'name': 'Charlie Brown',
          'proposal': 'Experienced in sales, I’ll close deals in 4 days.',
        },
        {
          'name': 'Daisy Miller',
          'proposal': 'I have a wide network, can boost sales quickly.',
        },
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Client Dashboard",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
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
                    "Mobile No: 9090909090",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text("Add Work"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ClientCreateProject()),
                );
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.work_outline),
            //   title: const Text("Assign User Works"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) =>
            //             ClientAssignUserScreen(project: projects[0]),
            //       ),
            //     );
            //   },
            // ),

             ListTile(
              leading: const Icon(Icons.contact_page, ),
              title: const Text("Contact Us"),
              onTap: () {
              },
            ),

             ListTile(
              leading: const Icon(Icons.terminal_sharp, ),
              title: const Text("Terms & Conditions"),
              onTap: () {
              },
            ),

             ListTile(
              leading: const Icon(Icons.notifications, ),
              title: const Text("Notifications"),
              onTap: () {
              },
            ),
             ListTile(
              leading: const Icon(Icons.notifications_active, ),
              title: const Text("View Notifications"),
              onTap: () {
              },
            ),
             ListTile(
              leading: const Icon(Icons.help, ),
              title: const Text("Help Support"),
              onTap: () {
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard(
                  title: "Total Works",
                  value: totalWorks.toString(),
                  color: AppColors.primary,
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
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
