import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/drawer_dashboard/hr_sidebar.dart';

class HrRevenueEmployerProfit extends StatelessWidget {
  HrRevenueEmployerProfit({super.key});

  // Dummy data for employers and profit
  final List<Map<String, dynamic>> employers = [
    {'name': 'John Doe', 'company': 'TechNova Solutions', 'profit': 15000},
    {'name': 'Emma Brown', 'company': 'GreenLeaf Enterprises', 'profit': 9800},
    {'name': 'David Miller', 'company': 'NextGen Motors', 'profit': 12750},
  ];

  @override
  Widget build(BuildContext context) {
    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Revenue from Employers (Profit Only)",
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
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Icon(Icons.business_center, color: AppColors.primary),
                ),
                title: Text(
                  emp['company'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text("Employer: ${emp['name']}"),
                trailing: Text(
                  "₹${emp['profit']}",
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
