import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';

class EmployersPage extends StatefulWidget {
  const EmployersPage({super.key});

  @override
  State<EmployersPage> createState() => _EmployersPageState();
}

class _EmployersPageState extends State<EmployersPage> {
  List<Map<String, dynamic>> employers = [
    {"name": "Tech Corp", "isBlocked": false},
    {"name": "Business Ltd", "isBlocked": true},
    {"name": "Innovate LLC", "isBlocked": false},
  ];

  void toggleBlock(int index) {
    setState(() {
      employers[index]["isBlocked"] = !employers[index]["isBlocked"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employers"),
        backgroundColor: Colors.blueAccent,
      ),
      
      drawer: AdminSidebar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: employers.length,
        itemBuilder: (context, index) {
          final user = employers[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.business, color: Colors.purple),
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
