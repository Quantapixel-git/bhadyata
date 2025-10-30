import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_create_notification_screen.dart';
import 'package:jobshub/admin/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class AdminViewNotificationScreen extends StatelessWidget {
  const AdminViewNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        "title": "New Job Posted",
        "message": "A new software developer job has been posted.",
        "date": "29 Sept 2025",
      },
      {
        "title": "Premium Feature Update",
        "message": "Check out the new premium features in your dashboard.",
        "date": "28 Sept 2025",
      },
      {
        "title": "Payment Reminder",
        "message": "Your subscription is about to expire. Renew now.",
        "date": "27 Sept 2025",
      },
    ];

    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: const Text(
                "Notifications",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: AppColors.primary,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminCreateNotificationScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Create",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            )
          : null,
      drawer: isMobile ? const AdminSidebar(selectedPage: "View Notifications") : null,
      body: Row(
        children: [
          if (!isMobile)
            const SizedBox(
              width: 260,
              child: AdminSidebar(selectedPage: "View Notifications", isWeb: true),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      notif["title"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notif["message"]!),
                        const SizedBox(height: 4),
                        Text(
                          notif["date"]!,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
