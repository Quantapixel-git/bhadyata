import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/drawer_dashboard/hr_sidebar.dart';
// import 'package:jobshub/hr/view/drawer_dashboard/hr_dashboard_wrapper.dart';

class ViewNotificationsPage extends StatelessWidget {
  const ViewNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data — replace with API data later
    final List<Map<String, String>> notifications = [
      {
        "title": "Salary Update",
        "message": "Your October salary has been processed.",
        "time": "10:30 AM, Oct 21, 2025",
      },
      {
        "title": "New Project Assigned",
        "message": "You’ve been assigned to Project Alpha.",
        "time": "5:45 PM, Oct 18, 2025",
      },
      {
        "title": "Policy Update",
        "message": "Please review the updated company HR policies.",
        "time": "9:00 AM, Oct 15, 2025",
      },
    ];

    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "View Notifications",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 2,
        ),
        drawer: HrSidebar(),
        body: ListView.builder(
          itemCount: notifications.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
                  notif["title"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      notif["message"]!,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif["time"]!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                trailing: Icon(Icons.chevron_right, color: AppColors.primary),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        notif["title"]!,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      content: Text(
                        notif["message"]!,
                        style: const TextStyle(fontSize: 15),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
