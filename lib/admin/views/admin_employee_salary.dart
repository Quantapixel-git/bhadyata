import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/project_model.dart'; // For AdminDashboardWrapper

class EmployeeSalaryPage extends StatefulWidget {
  const EmployeeSalaryPage({super.key});

  @override
  State<EmployeeSalaryPage> createState() => _EmployeeSalaryPageState();
}

class _EmployeeSalaryPageState extends State<EmployeeSalaryPage> {
  // Demo employee salary data
  List<Map<String, dynamic>> employeeSalaries = [
    {"name": "Emma Watson", "salary": 3000, "isPaid": false},
    {"name": "Liam Brown", "salary": 3500, "isPaid": true},
    {"name": "Olivia Davis", "salary": 3200, "isPaid": false},
  ];

  void togglePaid(int index) {
    setState(() {
      employeeSalaries[index]["isPaid"] = !employeeSalaries[index]["isPaid"];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          employeeSalaries[index]["isPaid"]
              ? "${employeeSalaries[index]["name"]} marked as paid."
              : "${employeeSalaries[index]["name"]} marked as unpaid.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return AdminDashboardWrapper(
          child: Column(
            children: [
              // ✅ Unified AppBar style (like AdminDashboard)
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading:
                    !isWeb, // hide drawer icon on wide screens
                title: const Text(
                  "Employee Salary Management",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
              ),

              // ✅ Page Body
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: employeeSalaries.length,
                    itemBuilder: (context, index) {
                      final user = employeeSalaries[index];
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
                              color: Colors.orange,
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
