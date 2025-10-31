import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/project_model.dart'; // for AdminDashboardWrapper

class EmployersPage extends StatefulWidget {
  const EmployersPage({super.key});

  @override
  State<EmployersPage> createState() => _EmployersPageState();
}

class _EmployersPageState extends State<EmployersPage> {
  List<Map<String, dynamic>> employers = [
    {"name": "Tech Corp", "isBlocked": false},
    {"name": "Business Ltd", "isBlocked": true},
    {"name": "Innovate LLC", "isBlocked": false},
  ];

  void toggleBlock(int index) {
    setState(() {
      employers[index]["isBlocked"] = !employers[index]["isBlocked"];
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
              // ✅ AppBar (no internal Scaffold)
              AppBar(
                automaticallyImplyLeading: !isWeb, // ✅ Hide drawer icon on web
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Employers",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
              ),

              // ✅ Body content
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: employers.length,
                    itemBuilder: (context, index) {
                      final user = employers[index];
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
                              Icons.business,
                              color: Colors.purple,
                            ),
                          ),
                          title: Text(
                            user["name"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: user["isBlocked"]
                                  ? Colors.red
                                  : Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                            ),
                            onPressed: () => toggleBlock(index),
                            child: Text(
                              user["isBlocked"] ? "Unblock" : "Block",
                              style: const TextStyle(color: Colors.white),
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
