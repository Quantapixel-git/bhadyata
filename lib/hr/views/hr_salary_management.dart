import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_side_bar.dart';

class HrSalaryManagement extends StatelessWidget {
  HrSalaryManagement({super.key});

  // Dummy data for HRs and their salary details
  final List<Map<String, dynamic>> hrList = [
    {
      'name': 'Priya Sharma',
      'email': 'priya.hr@example.com',
      'month': 'September 2025',
      'salary': 45000,
      'status': 'Pending',
    },
    {
      'name': 'Rajesh Kumar',
      'email': 'rajesh.hr@example.com',
      'month': 'September 2025',
      'salary': 48000,
      'status': 'Paid',
    },
    {
      'name': 'Neha Verma',
      'email': 'neha.hr@example.com',
      'month': 'September 2025',
      'salary': 47000,
      'status': 'Pending',
    },
  ];

  Color _getStatusColor(String status) {
    return status == 'Paid' ? Colors.green : Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return HrDashboardWrapper(
          child: Column(
            children: [
              // ✅ AppBar same style as AdminDashboard
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // hide drawer icon on web
                title: const Text(
                  "HR Salary Management",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // ✅ Main content
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: hrList.length,
                    itemBuilder: (context, index) {
                      final hr = hrList[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(
                              0.15,
                            ),
                            child: Icon(Icons.person, color: AppColors.primary),
                          ),
                          title: Text(
                            hr['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(hr['email']),
                              Text("Month: ${hr['month']}"),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "₹${hr['salary']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                hr['status'],
                                style: TextStyle(
                                  color: _getStatusColor(hr['status']),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
