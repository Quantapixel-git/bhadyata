import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/view/drawer_dashboard/hr_sidebar.dart';
import 'package:jobshub/hr/view/hr_employer_detail.dart';

class HrEmployers extends StatelessWidget {
  HrEmployers({super.key});

  // Dummy employer data
  final List<Map<String, String>> employers = [
    {
      'name': 'John Doe',
      'company': 'TechNova Solutions',
      'email': 'john.doe@technova.com',
      'phone': '+1 555-123-4567',
    },
    {
      'name': 'Emma Brown',
      'company': 'GreenLeaf Enterprises',
      'email': 'emma.brown@greenleaf.com',
      'phone': '+1 555-789-1234',
    },
    {
      'name': 'David Miller',
      'company': 'NextGen Motors',
      'email': 'david.miller@nextgen.com',
      'phone': '+1 555-456-7890',
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
            "Employers",
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
                  emp['name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Company: ${emp['company']}"),
                    Text(emp['email'] ?? ''),
                  ],
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
                        builder: (context) => HrEmployerDetail(employer: emp),
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
