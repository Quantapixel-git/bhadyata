import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';
import 'package:jobshub/employer/view/drawer_dashboard/employer_side_bar.dart';

class adminAllNotificationsPage extends StatelessWidget {
  const adminAllNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo notifications
    final List<Map<String, String>> notifications = [
      {
        "title": "New Job Post Alert",
        "message": "A new Flutter Developer position is open.",
        "date": "21 Oct 2025",
      },
      {
        "title": "Profile Verification",
        "message": "Your company profile has been verified successfully.",
        "date": "20 Oct 2025",
      },
      {
        "title": "Application Update",
        "message": "2 candidates have applied for your latest job post.",
        "date": "18 Oct 2025",
      },
      {
        "title": "Maintenance Notice",
        "message": "System maintenance scheduled for 25 Oct, 2 AM - 5 AM.",
        "date": "17 Oct 2025",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Notifications"),
        backgroundColor: Colors.blueAccent,
      ),
            drawer: AdminSidebar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.blueAccent),
              title: Text(
                item["title"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                item["message"]!,
                style: const TextStyle(color: Colors.black87),
              ),
              trailing: Text(
                item["date"]!,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
