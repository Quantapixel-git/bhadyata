import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/project_model.dart'; // for AdminDashboardWrapper

class RevenueProfitPage extends StatelessWidget {
  RevenueProfitPage({super.key});

  // Demo data
  final List<Map<String, dynamic>> revenueData = [
    {"employer": "Tech Corp", "profit": 5000},
    {"employer": "Business Ltd", "profit": 8000},
    {"employer": "Innovate LLC", "profit": 12000},
  ];

  @override
  Widget build(BuildContext context) {
    return AdminDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Revenue from Employer (Profit)",
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
            itemCount: revenueData.length,
            itemBuilder: (context, index) {
              final item = revenueData[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                shadowColor: AppColors.primary.withOpacity(0.2),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.attach_money, color: Colors.green),
                  ),
                  title: Text(
                    item["employer"],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: Text(
                    "\$${item["profit"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
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
