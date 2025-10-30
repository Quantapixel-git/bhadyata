import 'package:flutter/material.dart';

class RevenueTotalPage extends StatelessWidget {
  RevenueTotalPage({super.key});

  // Demo data
  final List<Map<String, dynamic>> revenueData = [
    {"employer": "Tech Corp", "salary": 20000, "profit": 5000},
    {"employer": "Business Ltd", "salary": 35000, "profit": 8000},
    {"employer": "Innovate LLC", "salary": 50000, "profit": 12000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revenue from Employer (Total)"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: revenueData.length,
        itemBuilder: (context, index) {
          final item = revenueData[index];
          final totalRevenue = (item["salary"] ?? 0) + (item["profit"] ?? 0);
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.orange),
              title: Text(item["employer"]),
              subtitle: Text(
                  "Salary: \$${item["salary"]} | Profit: \$${item["profit"]}"),
              trailing: Text(
                "\$${totalRevenue}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
            ),
          );
        },
      ),
    );
  }
}
