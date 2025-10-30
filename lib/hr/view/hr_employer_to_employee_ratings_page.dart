import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/view/drawer_dashboard/hr_sidebar.dart';
// import 'package:jobshub/hr/view/drawer_dashboard/hr_dashboard_wrapper.dart';

class EmployerToEmployeeRatingsPage extends StatelessWidget {
  const EmployerToEmployeeRatingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ratings = [
      {
        "employerName": "TechNova Pvt Ltd",
        "employeeName": "Alice Johnson",
        "rating": 4.8,
        "review": "Excellent performer and team player.",
        "project": "Mobile App Revamp",
        "date": "2025-10-15",
      },
      {
        "employerName": "CodeSphere Inc",
        "employeeName": "Ravi Kumar",
        "rating": 4.2,
        "review": "Good work overall, communication can improve.",
        "project": "E-commerce API Integration",
        "date": "2025-09-29",
      },
      {
        "employerName": "BuildRight Solutions",
        "employeeName": "Fatima Noor",
        "rating": 5.0,
        "review": "Delivered everything on time with high quality!",
        "project": "Website Redesign",
        "date": "2025-09-12",
      },
    ];

    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Employer → Employee Ratings",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 2,
        ),
        drawer: HrSidebar(),
        body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: ratings.length,
          itemBuilder: (context, index) {
            final rating = ratings[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: Icon(
                          Icons.business_center,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        rating["employeeName"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text("By: ${rating["employerName"]}"),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                        ),
                        tooltip: "View Details",
                        onPressed: () {
                          // TODO: Add detailed rating page navigation
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Project: ${rating["project"]}",
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
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
                    Text(
                      "\"${rating["review"]}\"",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Date: ${rating["date"]}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
