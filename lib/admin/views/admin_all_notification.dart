import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class AdminAllNotificationsPage extends StatelessWidget {
  const AdminAllNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return AdminDashboardWrapper(
          child: Column(
            children: [
              // ✅ Same style AppBar as AdminDashboard
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading:
                    !isWeb, // ✅ show drawer only on mobile
                title: const Text(
                  "All Notifications",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
              ),

              // ✅ Main Body (Expanded for full height)
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        shadowColor: AppColors.primary.withOpacity(0.2),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: const Icon(
                              Icons.notifications_active,
                              color: Colors.deepPurple,
                            ),
                          ),
                          title: Text(
                            item["title"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              item["message"]!,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                          trailing: Text(
                            item["date"]!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
