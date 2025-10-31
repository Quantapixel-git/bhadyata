import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/drawer_dashboard/hr_sidebar.dart';
import 'package:jobshub/hr/views/hr_employer_detail.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return HrDashboardWrapper(
          child: Column(
            children: [
              // ✅ AppBar (same as AdminDashboard)
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading:
                    !isWeb, // ✅ hide drawer icon on wide layout
                title: const Text(
                  "Employers",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // ✅ Main body
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: employers.length,
                    itemBuilder: (context, index) {
                      final emp = employers[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.business_center,
                              color: AppColors.primary,
                              size: 26,
                            ),
                          ),
                          title: Text(
                            emp['name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Company: ${emp['company']}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  emp['email'] ?? '',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
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
                                  builder: (context) =>
                                      HrEmployerDetail(employer: emp),
                                ),
                              );
                            },
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
