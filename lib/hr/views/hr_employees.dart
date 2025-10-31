import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/drawer_dashboard/hr_sidebar.dart';
import 'package:jobshub/hr/views/hr_employee_detail.dart';

class HrEmployees extends StatelessWidget {
  HrEmployees({super.key});

  // Dummy list of employees/users
  final List<Map<String, String>> employees = [
    {
      'name': 'Alice Johnson',
      'role': 'Software Engineer',
      'email': 'alice.johnson@example.com',
      'phone': '+1 555-234-5678',
    },
    {
      'name': 'Michael Smith',
      'role': 'UI/UX Designer',
      'email': 'michael.smith@example.com',
      'phone': '+1 555-987-6543',
    },
    {
      'name': 'Sophia Williams',
      'role': 'Project Manager',
      'email': 'sophia.williams@example.com',
      'phone': '+1 555-321-0987',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Employees / Users",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final emp = employees[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
                title: Text(
                  emp['name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(emp['role'] ?? ''), Text(emp['email'] ?? '')],
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: AppColors.primary,
                  ),
                  tooltip: 'View Details',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HrEmployeeDetail(employee: emp),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
