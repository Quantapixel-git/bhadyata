import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/project_model.dart'; // for AdminDashboardWrapper

class UsersKYCPage extends StatefulWidget {
  const UsersKYCPage({super.key});

  @override
  State<UsersKYCPage> createState() => _UsersKYCPageState();
}

class _UsersKYCPageState extends State<UsersKYCPage> {
  // Demo data
  List<Map<String, dynamic>> users = [
    {"name": "Emma Watson", "status": "Pending"},
    {"name": "Liam Brown", "status": "Approved"},
    {"name": "Olivia Davis", "status": "Rejected"},
  ];

  void updateStatus(int index, String status) {
    setState(() {
      users[index]["status"] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return AdminDashboardWrapper(
          child: Column(
            children: [
              // ✅ Responsive AppBar
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading:
                    !isWeb, // hide drawer icon on web just like AdminDashboard
                title: const Text(
                  "Users / Employees KYC",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
              ),

              // ✅ Main Body
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      Color statusColor;
                      switch (user["status"]) {
                        case "Approved":
                          statusColor = Colors.green;
                          break;
                        case "Rejected":
                          statusColor = Colors.red;
                          break;
                        default:
                          statusColor = Colors.orange;
                      }

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
                            child: const Icon(Icons.person, color: Colors.blue),
                          ),
                          title: Text(
                            user["name"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            "Status: ${user["status"]}",
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (user["status"] != "Approved")
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Approve",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () =>
                                      updateStatus(index, "Approved"),
                                ),
                              const SizedBox(width: 8),
                              if (user["status"] != "Rejected")
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Reject",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () =>
                                      updateStatus(index, "Rejected"),
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
