import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';

class UsersKYCPage extends StatefulWidget {
  const UsersKYCPage({super.key});

  @override
  State<UsersKYCPage> createState() => _UsersKYCPageState();
}

class _UsersKYCPageState extends State<UsersKYCPage> {
  // Demo data
  List<Map<String, dynamic>> users = [
    {"name": "Emma Watson", "status": "Pending"},
    {"name": "Liam Brown", "status": "Approved"},
    {"name": "Olivia Davis", "status": "Rejected"},
  ];

  void updateStatus(int index, String status) {
    setState(() {
      users[index]["status"] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users / Employees KYC"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: AdminSidebar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          Color statusColor;
          switch (user["status"]) {
            case "Approved":
              statusColor = Colors.green;
              break;
            case "Rejected":
              statusColor = Colors.red;
              break;
            default:
              statusColor = Colors.orange;
          }
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(user["name"]),
              subtitle: Text(
                "Status: ${user["status"]}",
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user["status"] != "Approved")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text("Approve"),
                      onPressed: () => updateStatus(index, "Approved"),
                    ),
                  const SizedBox(width: 6),
                  if (user["status"] != "Rejected")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Reject"),
                      onPressed: () => updateStatus(index, "Rejected"),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
