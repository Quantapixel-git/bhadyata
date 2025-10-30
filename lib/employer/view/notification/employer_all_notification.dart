import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/view/drawer_dashboard/employer_side_bar.dart';

class AllNotificationsPage extends StatelessWidget {
  const AllNotificationsPage({super.key});

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

    return EmployerDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "All Notifications",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
        ),
        body: notifications.isEmpty
            ? const Center(
                child: Text(
                  "No notifications found.",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: Icon(
                          Icons.notifications_active,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        item["title"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.5,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          item["message"]!,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      ),
                      trailing: Text(
                        item["date"]!,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
