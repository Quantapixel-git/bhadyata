import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

class AdminContactUsPage extends StatelessWidget {
  const AdminContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> queries = [
      {
        "name": "John Doe",
        "role": "User",
        "message": "I am facing login issues.",
        "date": "28 Sept 2025"
      },
      {
        "name": "ABC Pvt Ltd",
        "role": "Client",
        "message": "Need help with candidate assignment process.",
        "date": "27 Sept 2025"
      },
      {
        "name": "Neha Sharma",
        "role": "User",
        "message": "Payment not showing in my dashboard.",
        "date": "25 Sept 2025"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
         title: const Text(
          "Contact Queries",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: queries.length,
        itemBuilder: (context, index) {
          final query = queries[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(query["name"]![0]), // first letter
              ),
              title: Text(query["name"]!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Role: ${query["role"]}"),
                  Text("Message: ${query["message"]}"),
                  Text("Date: ${query["date"]}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
