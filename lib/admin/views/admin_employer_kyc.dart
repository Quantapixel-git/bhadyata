import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/project_model.dart'; // for AdminDashboardWrapper

class EmployersKYCPage extends StatefulWidget {
  const EmployersKYCPage({super.key});

  @override
  State<EmployersKYCPage> createState() => _EmployersKYCPageState();
}

class _EmployersKYCPageState extends State<EmployersKYCPage> {
  List<Map<String, dynamic>> employers = [
    {"name": "Tech Corp", "status": "Pending"},
    {"name": "Business Ltd", "status": "Approved"},
    {"name": "Innovate LLC", "status": "Rejected"},
  ];

  void updateStatus(int index, String status) {
    setState(() {
      employers[index]["status"] = status;
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
              // ✅ Consistent AppBar (same as AdminDashboard)
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // Hide drawer icon on web
                title: const Text(
                  "Employers KYC",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
              ),

              // ✅ Main Content
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: employers.length,
                    itemBuilder: (context, index) {
                      final employer = employers[index];
                      Color statusColor;
                      switch (employer["status"]) {
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
                            backgroundColor:
                                AppColors.primary.withOpacity(0.1),
                            child: const Icon(Icons.business,
                                color: Colors.purple),
                          ),
                          title: Text(
                            employer["name"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            "Status: ${employer["status"]}",
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (employer["status"] != "Approved")
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
                              if (employer["status"] != "Rejected")
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
