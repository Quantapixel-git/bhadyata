import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

class ViewNotificationsPage extends StatelessWidget {
  const ViewNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with your API payload
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "Salary Update",
        "message": "Your October salary has been processed.",
        "time": "10:30 AM, Oct 21, 2025",
        "recipients": [
          {"name": "John Doe", "role": "Employee"},
          {"name": "Priya Sharma", "role": "Employee"},
        ],
      },
      {
        "title": "New Project Assigned",
        "message": "You’ve been assigned to Project Alpha.",
        "time": "5:45 PM, Oct 18, 2025",
        "recipients": [
          {"name": "Amit Verma", "role": "Employee"},
          {"name": "TechNova Pvt Ltd", "role": "Employer"},
          {"name": "CodeSphere Inc", "role": "Employer"},
          {"name": "Sara Khan", "role": "Employee"},
        ],
      },
      {
        "title": "Policy Update",
        "message": "Please review the updated company HR policies.",
        "time": "9:00 AM, Oct 15, 2025",
        "recipients": [
          {"name": "BuildRight Solutions", "role": "Employer"},
        ],
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return HrDashboardWrapper(
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

                      final employees = recips
                          .where(
                            (r) =>
                                (r["role"]?.toString().toLowerCase() ?? "") ==
                                "employee",
                          )
                          .toList();
                      final employers = recips
                          .where(
                            (r) =>
                                (r["role"]?.toString().toLowerCase() ?? "") ==
                                "employer",
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
                                      notif["title"] ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    notif["time"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Message (optional)
                              if ((notif["message"] ?? "")
                                  .toString()
                                  .isNotEmpty) ...[
                                Text(
                                  notif["message"],
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 12),
                              ],

                              // Counts only (segregated)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _CountPill(
                                        label: "Employees",
                                        count: employees.length,
                                        color: Colors.teal,
                                      ),
                                      _CountPill(
                                        label: "Employers",
                                        count: employers.length,
                                        color: Colors.indigo,
                                      ),
                                    
                                    ],
                                  ),
                                     Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            NotificationRecipientsPage(
                                              title:
                                                  notif["title"] ??
                                                  "Recipients",
                                              employees: employees
                                                  .cast<Map<String, dynamic>>(),
                                              employers: employers
                                                  .cast<Map<String, dynamic>>(),
                                            ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.list_alt, size: 18),
                                  label: const Text("View Recipients"),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                                ],
                              ),
                              // const SizedBox(height: 10),

                              // View details button -> navigates to segregated names page
                           
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

class NotificationRecipientsPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> employees;
  final List<Map<String, dynamic>> employers;

  const NotificationRecipientsPage({
    super.key,
    required this.title,
    required this.employees,
    required this.employers,
  });

  @override
  Widget build(BuildContext context) {
    return HrDashboardWrapper(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              'Recipients',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.primary,
            elevation: 2,
            bottom: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "Employees"),
                Tab(text: "Employers"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _RecipientList(
                items: employees,
                emptyText: "No employees received this notification.",
                icon: Icons.person,
                color: Colors.teal,
              ),
              _RecipientList(
                items: employers,
                emptyText: "No employers received this notification.",
                icon: Icons.apartment,
                color: Colors.indigo,
              ),
            ],
          ),
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
            subtitle: Text((r["role"] ?? "").toString()),
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
