import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';

class adminEmployeeToEmployerRatingsPage extends StatelessWidget {
  adminEmployeeToEmployerRatingsPage({super.key});

  // Demo data
  final List<Map<String, dynamic>> ratings = [
    {"employee": "Emma Watson", "employer": "Tech Corp", "rating": 4.5, "review": "Great management!"},
    {"employee": "Liam Brown", "employer": "Business Ltd", "rating": 3.8, "review": "Good support but tight deadlines."},
    {"employee": "Olivia Davis", "employer": "Innovate LLC", "rating": 5.0, "review": "Excellent experience!"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee → Employer Ratings"),
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
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text("${item["employee"]} → ${item["employer"]}"),
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
