import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/drawer_dashboard/hr_sidebar.dart';

class EmployeeToEmployerRatingsPage extends StatelessWidget {
  const EmployeeToEmployerRatingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ratings = [
      {
        "employeeName": "John Doe",
        "employerName": "TechNova Pvt Ltd",
        "rating": 4.5,
        "review": "Good work culture and supportive management.",
        "date": "2025-10-10",
      },
      {
        "employeeName": "Sara Khan",
        "employerName": "CodeSphere Inc",
        "rating": 3.8,
        "review": "Decent experience, but project deadlines were tough.",
        "date": "2025-09-25",
      },
      {
        "employeeName": "David Smith",
        "employerName": "BuildRight Solutions",
        "rating": 5.0,
        "review": "Amazing place to work, highly recommended!",
        "date": "2025-09-01",
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return HrDashboardWrapper(
          child: Column(
            children: [
              // ✅ AppBar (same style logic as AdminDashboard)
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // hide drawer icon on web
                title: const Text(
                  "Employee → Employer Ratings",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
                centerTitle: true,
              ),

              // ✅ Main content
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: ratings.length,
                    itemBuilder: (context, index) {
                      final rating = ratings[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primary
                                      .withOpacity(0.15),
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                                title: Text(
                                  rating["employerName"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text("By: ${rating["employeeName"]}"),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: AppColors.primary,
                                  ),
                                  tooltip: "View Details",
                                  onPressed: () {
                                    // TODO: Add detailed rating view navigation
                                  },
                                ),
                              ),
                              const SizedBox(height: 4),

                              // ⭐ Rating stars
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    i < rating["rating"].round()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),

                              // 💬 Review text
                              Text(
                                "\"${rating["review"]}\"",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // 🕓 Date
                              Text(
                                "Date: ${rating["date"]}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
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
