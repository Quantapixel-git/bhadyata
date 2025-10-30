import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';

class CompaniesPage extends StatelessWidget {
  CompaniesPage({super.key});

  // Demo data for each tab
  final List<String> approved = ["ABC Ltd", "XYZ Corp"];
  final List<String> rejected = ["OldTech", "NextGen"];
  final List<String> pending = ["Future Solutions", "Innovate Ltd"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Companies"),
          backgroundColor: Colors.blueAccent,
          bottom: const TabBar(
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
    );
  }

  Widget buildCompanyList(List<String> companies, Color iconColor) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: Icon(Icons.business, color: iconColor),
            title: Text(company),
          ),
        );
      },
    );
  }
}
