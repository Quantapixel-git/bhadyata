import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/project_model.dart'; // for AdminDashboardWrapper

class HRSalaryPage extends StatefulWidget {
  const HRSalaryPage({super.key});

  @override
  State<HRSalaryPage> createState() => _HRSalaryPageState();
}

class _HRSalaryPageState extends State<HRSalaryPage> {
  // Demo HR salary data
  List<Map<String, dynamic>> hrSalaries = [
    {"name": "John Doe", "salary": 5000, "isPaid": false},
    {"name": "Alice Smith", "salary": 4500, "isPaid": true},
    {"name": "Mark Johnson", "salary": 6000, "isPaid": false},
  ];

  void togglePaid(int index) {
    setState(() {
      hrSalaries[index]["isPaid"] = !hrSalaries[index]["isPaid"];
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
              // ✅ AppBar (same structure as AdminDashboard)
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "HR Salary Management",
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
                    itemCount: hrSalaries.length,
                    itemBuilder: (context, index) {
                      final user = hrSalaries[index];
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
                              Icons.person,
                              color: Colors.blueAccent,
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
                          subtitle: Text(
                            "Salary: \$${user["salary"]}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: user["isPaid"]
                                  ? Colors.grey
                                  : AppColors.primary.withOpacity(0.9),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: user["isPaid"]
                                ? null
                                : () => togglePaid(index),
                            child: Text(
                              user["isPaid"] ? "Paid" : "Pay",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
