import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';

class HRKYCPage extends StatefulWidget {
  const HRKYCPage({super.key});

  @override
  State<HRKYCPage> createState() => _HRKYCPageState();
}

class _HRKYCPageState extends State<HRKYCPage> {
  List<Map<String, dynamic>> hrUsers = [
    {"name": "John Doe", "status": "Pending"},
    {"name": "Alice Smith", "status": "Approved"},
    {"name": "Mark Johnson", "status": "Rejected"},
  ];

  void updateStatus(int index, String status) {
    setState(() {
      hrUsers[index]["status"] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HR KYC"),
        backgroundColor: Colors.blueAccent,
      ),
      
      drawer: AdminSidebar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: hrUsers.length,
        itemBuilder: (context, index) {
          final user = hrUsers[index];
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
              leading: const Icon(Icons.person, color: Colors.teal),
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
