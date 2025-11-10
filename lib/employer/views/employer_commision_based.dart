import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              // ✅ Responsive AppBar (same as AdminDashboard)
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // Hide drawer icon on web
                title: const Text(
                  "Commission-Based Lead Generators",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // ✅ Main content area
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: _buildEmployeeContent(isWeb, employees),
                ),
              ),
            ],
          ),
        );
      },
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
