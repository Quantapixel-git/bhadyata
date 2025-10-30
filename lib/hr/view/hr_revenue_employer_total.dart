import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/view/drawer_dashboard/hr_sidebar.dart';

class HrRevenueEmployerTotal extends StatelessWidget {
  HrRevenueEmployerTotal({super.key});

  // Dummy data for employers
  final List<Map<String, dynamic>> employers = [
    {
      'name': 'John Doe',
      'company': 'TechNova Solutions',
      'profit': 15000,
      'employeeSalarySum': 50000,
    },
    {
      'name': 'Emma Brown',
      'company': 'GreenLeaf Enterprises',
      'profit': 9800,
      'employeeSalarySum': 45000,
    },
    {
      'name': 'David Miller',
      'company': 'NextGen Motors',
      'profit': 12750,
      'employeeSalarySum': 60000,
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
            "Revenue from Employers (Total Amount)",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: employers.length,
          itemBuilder: (context, index) {
            final emp = employers[index];
            final total = emp['employeeSalarySum'] + emp['profit'];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Icon(Icons.business_rounded, color: AppColors.primary),
                ),
                title: Text(
                  emp['company'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Employer: ${emp['name']}"),
                    Text("Employee Salaries: ₹${emp['employeeSalarySum']}"),
                    Text("Profit: ₹${emp['profit']}"),
                  ],
                ),
                trailing: Text(
                  "₹$total",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
