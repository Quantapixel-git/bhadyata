import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/drawer_dashboard/employer_side_bar.dart';
import 'package:jobshub/employer/views/employer_employee_list_component.dart';

class CommissionBasedEmployeesPage extends StatelessWidget {
  const CommissionBasedEmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final employees = [
      {
        "name": "Ravi Kumar",
        "joiningDate": "01 Oct 2025",
        "jobTitle": "Lead Generator - Marketing Campaign",
      },
      {
        "name": "Anjali Sharma",
        "joiningDate": "03 Oct 2025",
        "jobTitle": "Commission Sales Partner",
      },
    ];

    return EmployerDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Commission-Based Lead Generators",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWeb = constraints.maxWidth >= 900;
            return _buildEmployeeContent(isWeb, employees);
          },
        ),
      ),
    );
  }

  // ---------- EMPLOYEE CONTENT ----------
  Widget _buildEmployeeContent(
    bool isWeb,
    List<Map<String, String>> employees,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: EmployeeListPage(
              pageTitle: "Commission-Based Lead Generators",
              employees: employees,
            ),
          ),
        ),
      ),
    );
  }
}
