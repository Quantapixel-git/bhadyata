import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/project_model.dart'; // for AdminDashboardWrapper

class AdminEmployeeToEmployerRatingsPage extends StatelessWidget {
  AdminEmployeeToEmployerRatingsPage({super.key});

  // Demo data
  final List<Map<String, dynamic>> ratings = [
    {
      "employee": "Emma Watson",
      "employer": "Tech Corp",
      "rating": 4.5,
      "review": "Great management!",
    },
    {
      "employee": "Liam Brown",
      "employer": "Business Ltd",
      "rating": 3.8,
      "review": "Good support but tight deadlines.",
    },
    {
      "employee": "Olivia Davis",
      "employer": "Innovate LLC",
      "rating": 5.0,
      "review": "Excellent experience!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AdminDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Employee → Employer Ratings",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.primary,
        ),
        drawer: AdminSidebar(),
        body: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: ratings.length,
            itemBuilder: (context, index) {
              final item = ratings[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                shadowColor: AppColors.primary.withOpacity(0.2),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(Icons.person, color: Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${item["employee"]} → ${item["employer"]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < item["rating"].floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 18,
                                  color: Colors.orange,
                                );
                              }),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item["review"],
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
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
    );
  }
}
