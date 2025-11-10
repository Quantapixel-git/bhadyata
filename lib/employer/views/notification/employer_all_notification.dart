import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class EmployerNotificationsPage extends StatelessWidget {
  const EmployerNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with your API payload (employees only)
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "New Job Post Alert",
        "message": "A new Flutter Developer position is open.",
        "time": "10:30 AM, Oct 21, 2025",
        "recipients": [
          {"name": "John Doe", "role": "Employee"},
          {"name": "Priya Sharma", "role": "Employee"},
        ],
      },
      {
        "title": "Profile Verification",
        "message": "Your company profile has been verified successfully.",
        "time": "5:10 PM, Oct 20, 2025",
        "recipients": [
          {"name": "Amit Verma", "role": "Employee"},
        ],
      },
      {
        "title": "Application Update",
        "message": "2 candidates have applied for your latest job post.",
        "time": "9:05 AM, Oct 18, 2025",
        "recipients": [
          {"name": "Sara Khan", "role": "Employee"},
          {"name": "David Roy", "role": "Employee"},
        ],
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Sent Notifications",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      final List recips = (notif["recipients"] as List?) ?? [];

                      // Only employees are considered
                      final employees = recips
                          .where(
                            (r) =>
                                (r["role"]?.toString().toLowerCase() ?? "") ==
                                "employee",
                          )
                          .toList();

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title row
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.15),
                                    child: Icon(
                                      Icons.notifications,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      (notif["title"] ?? "").toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    (notif["time"] ?? "").toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Message
                              if ((notif["message"] ?? "")
                                  .toString()
                                  .isNotEmpty) ...[
                                Text(
                                  (notif["message"] ?? "").toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 12),
                              ],

                              // Count + View Recipients (Employees only)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _CountPill(
                                    label: "Employees",
                                    count: employees.length,
                                    color: Colors.teal,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EmployerNotificationRecipientsPage(
                                                  title: (notif["title"] ?? "")
                                                      .toString(),
                                                  employees: employees
                                                      .cast<
                                                        Map<String, dynamic>
                                                      >(),
                                                ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.list_alt,
                                        size: 18,
                                      ),
                                      label: const Text("View Recipients"),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

class EmployerNotificationRecipientsPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> employees;

  const EmployerNotificationRecipientsPage({
    super.key,
    required this.title,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    return EmployerDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Recipients',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
        ),
        body: _RecipientList(
          items: employees,
          emptyText: "No employees received this notification.",
          icon: Icons.person,
          color: Colors.teal,
        ),
      ),
    );
  }
}

class _RecipientList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String emptyText;
  final IconData icon;
  final Color color;

  const _RecipientList({
    required this.items,
    required this.emptyText,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(emptyText, style: const TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (_, i) {
        final r = items[i];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            title: Text(
              (r["name"] ?? "").toString(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text("Employee"),
          ),
        );
      },
    );
  }
}

class _CountPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _CountPill({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$label: $count",
        style: TextStyle(fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
