import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/project_model.dart'; // for wrapper

class CompaniesPage extends StatelessWidget {
  CompaniesPage({super.key});

  // Demo data for each tab
  final List<String> approved = ["ABC Ltd", "XYZ Corp"];
  final List<String> rejected = ["OldTech", "NextGen"];
  final List<String> pending = ["Future Solutions", "Innovate Ltd"];

  @override
  Widget build(BuildContext context) {
    return AdminDashboardWrapper(
      child: DefaultTabController(
        length: 3, // ✅ Placed here so both TabBar & TabBarView share it
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Companies",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primary,
            bottom: const TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "Approved"),
                Tab(text: "Rejected"),
                Tab(text: "Pending"),
              ],
            ),
          ),
          drawer: AdminSidebar(),
          body: TabBarView(
            children: [
              buildCompanyList(approved, Colors.green),
              buildCompanyList(rejected, Colors.red),
              buildCompanyList(pending, Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCompanyList(List<String> companies, Color iconColor) {
    return Container(
      color: Colors.grey[100],
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            shadowColor: iconColor.withOpacity(0.2),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leading: CircleAvatar(
                backgroundColor: iconColor.withOpacity(0.1),
                child: Icon(Icons.business, color: iconColor),
              ),
              title: Text(
                company,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
