import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/drawer_dashboard/hr_sidebar.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return HrDashboardWrapper(
          child: Column(
            children: [
              // ✅ Responsive AppBar (no Scaffold)
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // ✅ hide drawer icon on web
                title: const Text(
                  "Revenue from Employers (Total Amount)",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // ✅ Body (same structure style as AdminDashboard)
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: employers.length,
                    itemBuilder: (context, index) {
                      final emp = employers[index];
                      final total =
                          (emp['employeeSalarySum'] as num) +
                          (emp['profit'] as num);

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.1,
                                ),
                                child: Icon(
                                  Icons.business_rounded,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      emp['company'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text("Employer: ${emp['name']}"),
                                    Text(
                                      "Employee Salaries: ₹${emp['employeeSalarySum']}",
                                    ),
                                    Text("Profit: ₹${emp['profit']}"),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "₹$total",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
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
