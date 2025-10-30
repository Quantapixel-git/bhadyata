import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';

class ApprovedCompaniesPage extends StatelessWidget {
  ApprovedCompaniesPage({super.key});

  // Demo data
  final List<Map<String, String>> approvedCompanies = [
    {"name": "ABC Ltd", "approvedBy": "HR John"},
    {"name": "XYZ Corp", "approvedBy": "Admin Mary"},
    {"name": "Tech Solutions", "approvedBy": "HR Alice"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approved Companies"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: AdminSidebar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: approvedCompanies.length,
        itemBuilder: (context, index) {
          final company = approvedCompanies[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.business, color: Colors.green),
              title: Text(company['name'] ?? ''),
              subtitle: Text("Approved by: ${company['approvedBy'] ?? ''}"),
            ),
          );
        },
      ),
    );
  }
}
