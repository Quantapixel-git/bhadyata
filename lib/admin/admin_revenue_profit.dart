import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revenue from Employer (Profit)"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: revenueData.length,
        itemBuilder: (context, index) {
          final item = revenueData[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.green),
              title: Text(item["employer"]),
              trailing: Text(
                "\$${item["profit"]}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
