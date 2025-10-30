import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/view/drawer_dashboard/hr_sidebar.dart';

class EmployeeSalaryManagement extends StatelessWidget {
  EmployeeSalaryManagement({super.key});

  // Dummy data for employee salary info
  final List<Map<String, dynamic>> employees = [
    {
      'name': 'Alice Johnson',
      'role': 'Flutter Developer',
      'month': 'September 2025',
      'salary': 35000,
      'status': 'Paid',
    },
    {
      'name': 'Michael Smith',
      'role': 'Backend Engineer',
      'month': 'September 2025',
      'salary': 40000,
      'status': 'Pending',
    },
    {
      'name': 'Sophia Williams',
      'role': 'UI/UX Designer',
      'month': 'September 2025',
      'salary': 37000,
      'status': 'Paid',
    },
  ];

  Color _getStatusColor(String status) {
    if (status == 'Paid') return Colors.green;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Employee Salary Management",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
                  child: Icon(Icons.work_outline, color: AppColors.primary),
                ),
                title: Text(
                  emp['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(emp['role']), Text("Month: ${emp['month']}")],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${emp['salary']}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      emp['status'],
                      style: TextStyle(
                        color: _getStatusColor(emp['status']),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
