import 'package:flutter/material.dart';

class HRSalaryPage extends StatefulWidget {
  const HRSalaryPage({super.key});

  @override
  State<HRSalaryPage> createState() => _HRSalaryPageState();
}

class _HRSalaryPageState extends State<HRSalaryPage> {
  // Demo HR salary data
  List<Map<String, dynamic>> hrSalaries = [
    {"name": "John Doe", "salary": 5000, "isPaid": false},
    {"name": "Alice Smith", "salary": 4500, "isPaid": true},
    {"name": "Mark Johnson", "salary": 6000, "isPaid": false},
  ];

  void togglePaid(int index) {
    setState(() {
      hrSalaries[index]["isPaid"] = !hrSalaries[index]["isPaid"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HR Salary Management"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: hrSalaries.length,
        itemBuilder: (context, index) {
          final user = hrSalaries[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(user["name"]),
              subtitle: Text("Salary: \$${user["salary"]}"),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: user["isPaid"] ? Colors.grey : Colors.green,
                ),
                child: Text(user["isPaid"] ? "Paid" : "Pay"),
                onPressed: user["isPaid"] ? null : () => togglePaid(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
