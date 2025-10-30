import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';

class adminEmployerToEmployeeRatingsPage extends StatelessWidget {
  adminEmployerToEmployeeRatingsPage({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employer → Employee Ratings"),
        backgroundColor: Colors.blueAccent,
      ),

      drawer: AdminSidebar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: ratings.length,
        itemBuilder: (context, index) {
          final item = ratings[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.business, color: Colors.purple),
              title: Text("${item["employer"]} → ${item["employee"]}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < item["rating"].floor()
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: Colors.orange,
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(item["review"]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
