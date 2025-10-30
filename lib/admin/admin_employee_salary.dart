import 'package:flutter/material.dart';

class EmployeeSalaryPage extends StatefulWidget {
  const EmployeeSalaryPage({super.key});

  @override
  State<EmployeeSalaryPage> createState() => _EmployeeSalaryPageState();
}

class _EmployeeSalaryPageState extends State<EmployeeSalaryPage> {
  // Demo employee salary data
  List<Map<String, dynamic>> employeeSalaries = [
    {"name": "Emma Watson", "salary": 3000, "isPaid": false},
    {"name": "Liam Brown", "salary": 3500, "isPaid": true},
    {"name": "Olivia Davis", "salary": 3200, "isPaid": false},
  ];

  void togglePaid(int index) {
    setState(() {
      employeeSalaries[index]["isPaid"] = !employeeSalaries[index]["isPaid"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Salary Management"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: employeeSalaries.length,
        itemBuilder: (context, index) {
          final user = employeeSalaries[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
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
