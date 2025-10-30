import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';

class HRUsersPage extends StatefulWidget {
  const HRUsersPage({super.key});

  @override
  State<HRUsersPage> createState() => _HRUsersPageState();
}

class _HRUsersPageState extends State<HRUsersPage> {
  // Demo HR users
  List<Map<String, dynamic>> hrUsers = [
    {"name": "John Doe", "isBlocked": false},
    {"name": "Alice Smith", "isBlocked": true},
    {"name": "Mark Johnson", "isBlocked": false},
  ];

  void toggleBlock(int index) {
    setState(() {
      hrUsers[index]["isBlocked"] = !hrUsers[index]["isBlocked"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HR Users"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: AdminSidebar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: hrUsers.length,
        itemBuilder: (context, index) {
          final user = hrUsers[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
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
