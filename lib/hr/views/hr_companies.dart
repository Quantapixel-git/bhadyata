import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/hr_comapy_detail.dart';
import 'package:jobshub/hr/views/drawer_dashboard/hr_sidebar.dart';
// import 'package:jobshub/utils/app_colors.dart'; // ✅ ensure AppColors is imported

class HrCompanies extends StatelessWidget {
  HrCompanies({super.key});

  // Dummy list of companies
  final List<Map<String, String>> companies = [
    {
      'name': 'TechNova Solutions',
      'industry': 'Software Development',
      'location': 'New York, USA',
    },
    {
      'name': 'GreenLeaf Enterprises',
      'industry': 'Renewable Energy',
      'location': 'California, USA',
    },
    {
      'name': 'BlueOcean Analytics',
      'industry': 'Data Science & AI',
      'location': 'Texas, USA',
    },
    {
      'name': 'NextGen Motors',
      'industry': 'Automobile Manufacturing',
      'location': 'Detroit, USA',
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
            "Companies",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
        ),

        body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: companies.length,
          itemBuilder: (context, index) {
            final company = companies[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Icon(Icons.business, color: AppColors.primary),
                ),
                title: Text(
                  company['name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Industry: ${company['industry']}"),
                    Text("Location: ${company['location']}"),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: AppColors.primary, // ✅ consistent theme color
                  ),
                  tooltip: 'View Details',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HrCompanyDetail(company: company),
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
