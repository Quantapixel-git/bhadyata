import 'package:flutter/material.dart';
import 'package:jobshub/clients/client_assigned_work_list_screen.dart';
import 'package:jobshub/clients/client_candi_review_screen.dart';
import 'package:jobshub/clients/client_dashboard.dart';
import 'package:jobshub/clients/client_project_screen.dart';
import 'package:jobshub/clients/client_view_notification.dart';
import 'package:jobshub/hr/view/hr_candidate_review_screen.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/users/project_model.dart';
import 'package:jobshub/utils/AppColor.dart';

class ClientSidebar extends StatelessWidget {
  final bool isWeb;
  final List<ProjectModel> projects;

  const ClientSidebar({super.key, required this.projects, this.isWeb = false});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/client.png"),
                ),
                SizedBox(height: 10),
                Text("Welcome, Client", style: TextStyle(color: Colors.black87, fontSize: 18)),
                Text("Mobile No: 9090909090", style: TextStyle(color: Colors.black54, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                 _sidebarItem(context, Icons.add_box, "Dashboard", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ClientDashboardPage()),
                  );
                }),
                _sidebarItem(context, Icons.add_box, "Manage Project", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProjectListScreen(projects: projects)),
                  );
                }),
                _sidebarItem(context, Icons.work_outline, "Assign User Works", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ClientAssignedWorkListScreen()),
                  );
                }),
                _sidebarItem(context, Icons.reviews, "Client Review", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ClientCandiReviewScreen()),
                  );
                }),
                _sidebarItem(context, Icons.notifications_active, "View Notifications", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ClientViewNotification()),
                  );
                }),
                _sidebarItem(context, Icons.logout, "Logout", () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(color: Colors.black87)),
      onTap: onTap,
    );
  }
}
