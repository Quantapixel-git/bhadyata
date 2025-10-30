import 'package:flutter/material.dart';
import 'package:jobshub/extra/views/clients/client_sidebar.dart';
import 'package:jobshub/extra/views/clients/client_create_notification.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class ClientViewNotification extends StatelessWidget {
  ClientViewNotification({super.key});

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth > 800;

        Widget content;

        if (isWeb) {
          // ---- Web Layout with GridView ----
          content = GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // adjust number of columns as needed
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2, // width/height ratio for card
            ),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.notifications,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              notif["title"]!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(notif["message"]!),
                      const Spacer(),
                      Text(
                        notif["date"]!,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          return Scaffold(
            body: Row(
              children: [
                ClientSidebar(projects: []), // permanent sidebar
                Expanded(
                  child: Column(
                    children: [
                      AppBar(
                        title: const Text(
                          "Notifications",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        backgroundColor: AppColors.primary,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ClientCreateNotification()),
                              );
                            },
                            child: const Text(
                              "Create",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: content),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          // ---- Mobile Layout with ListView ----
          content = ListView.builder(
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
          );

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Notifications",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: AppColors.primary,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ClientCreateNotification()),
                    );
                  },
                  child: const Text(
                    "Create",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
            drawer: ClientSidebar(projects: []), // drawer for mobile
            body: content,
          );
        }
      },
    );
  }
}
