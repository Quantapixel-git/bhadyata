import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
// import 'package:jobshub/users/views/project_model.dart'; // wrapper

class CompaniesPage extends StatelessWidget {
  CompaniesPage({super.key});

  final List<String> approved = ["ABC Ltd", "XYZ Corp"];
  final List<String> rejected = ["OldTech", "NextGen"];
  final List<String> pending = ["Future Solutions", "Innovate Ltd"];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isWeb = width >= 900;

    return AdminDashboardWrapper(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            automaticallyImplyLeading: !isWeb,
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

          // ✅ Give TabBarView bounded height using Expanded
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    _buildCompanyList(approved, Colors.green),
                    _buildCompanyList(rejected, Colors.red),
                    _buildCompanyList(pending, Colors.orange),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyList(List<String> companies, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(Icons.business, color: color),
              ),
              title: Text(
                company,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
    );
  }
}
