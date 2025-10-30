import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';

class EmployersKYCPage extends StatefulWidget {
  const EmployersKYCPage({super.key});

  @override
  State<EmployersKYCPage> createState() => _EmployersKYCPageState();
}

class _EmployersKYCPageState extends State<EmployersKYCPage> {
  List<Map<String, dynamic>> employers = [
    {"name": "Tech Corp", "status": "Pending"},
    {"name": "Business Ltd", "status": "Approved"},
    {"name": "Innovate LLC", "status": "Rejected"},
  ];

  void updateStatus(int index, String status) {
    setState(() {
      employers[index]["status"] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employers KYC"),
        backgroundColor: Colors.blueAccent,
      ),
      
      drawer: AdminSidebar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: employers.length,
        itemBuilder: (context, index) {
          final employer = employers[index];
          Color statusColor;
          switch (employer["status"]) {
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
              leading: const Icon(Icons.business, color: Colors.purple),
              title: Text(employer["name"]),
              subtitle: Text(
                "Status: ${employer["status"]}",
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (employer["status"] != "Approved")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text("Approve"),
                      onPressed: () => updateStatus(index, "Approved"),
                    ),
                  const SizedBox(width: 6),
                  if (employer["status"] != "Rejected")
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
