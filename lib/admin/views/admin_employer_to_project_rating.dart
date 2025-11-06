import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/side_bar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class AdminEmployerToEmployeeRatingsPage extends StatelessWidget {
  AdminEmployerToEmployeeRatingsPage({super.key});

  // Demo data
  final List<Map<String, dynamic>> ratings = [
    {
      "employer": "Tech Corp",
      "employee": "Emma Watson",
      "rating": 5.0,
      "review": "Excellent work!",
    },
    {
      "employer": "Business Ltd",
      "employee": "Liam Brown",
      "rating": 4.2,
      "review": "Good communication skills.",
    },
    {
      "employer": "Innovate LLC",
      "employee": "Olivia Davis",
      "rating": 3.9,
      "review": "Needs improvement on deadlines.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return AdminDashboardWrapper(
          child: Column(
            children: [
              // ✅ Consistent AppBar
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // Hide drawer icon on web
                title: const Text(
                  "Employer → Employee Ratings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
              ),

              // ✅ Main Content
              Expanded(
                child: Container(
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
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.1),
                                child: const Icon(
                                  Icons.business,
                                  color: Colors.purple,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item["employer"]} → ${item["employee"]}",
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
            ],
          ),
        );
      },
    );
  }
}
