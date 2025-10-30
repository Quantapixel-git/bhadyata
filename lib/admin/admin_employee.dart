import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  List<Map<String, dynamic>> employees = [
    {"name": "Emma Watson", "isBlocked": false},
    {"name": "Liam Brown", "isBlocked": false},
    {"name": "Olivia Davis", "isBlocked": true},
  ];

  void toggleBlock(int index) {
    setState(() {
      employees[index]["isBlocked"] = !employees[index]["isBlocked"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employees / Users"),
        backgroundColor: Colors.blueAccent,
      ),
      
      drawer: AdminSidebar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final user = employees[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
              title: Text(user["name"]),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: user["isBlocked"] ? Colors.red : Colors.green,
                ),
                child: Text(user["isBlocked"] ? "Unblock" : "Block"),
                onPressed: () => toggleBlock(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
