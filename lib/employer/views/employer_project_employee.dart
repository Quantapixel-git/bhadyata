import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';
import 'package:jobshub/employer/views/employer_employee_list_component.dart';

class ProjectEmployeesPage extends StatelessWidget {
  const ProjectEmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final employees = [
      {
        "name": "Manish Yadav",
        "joiningDate": "08 Oct 2025",
        "jobTitle": "Flutter Developer - Project Alpha",
      },
      {
        "name": "Kriti Mehra",
        "joiningDate": "05 Oct 2025",
        "jobTitle": "UI Designer - Project Beta",
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              // ✅ AppBar matches AdminDashboard style
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // hide drawer icon on web
                title: const Text(
                  "Project Employees",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // ✅ Main content
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: Center(
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
                            pageTitle: "Project Employees",
                            employees: employees,
                          ),
                        ),
                      ),
                    ),
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
