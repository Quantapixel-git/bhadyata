import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';
import 'package:jobshub/employer/view/drawer_dashboard/employer_side_bar.dart';

class adminSendNotificationPage extends StatefulWidget {
  const adminSendNotificationPage({super.key});

  @override
  State<adminSendNotificationPage> createState() => _adminSendNotificationPageState();
}

class _adminSendNotificationPageState extends State<adminSendNotificationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Demo users list
  final List<Map<String, dynamic>> users = [
    {"id": 1, "name": "John Doe", "email": "john@example.com", "selected": false},
    {"id": 2, "name": "Priya Sharma", "email": "priya@example.com", "selected": false},
    {"id": 3, "name": "Amit Verma", "email": "amit@example.com", "selected": false},
    {"id": 4, "name": "Sara Khan", "email": "sara@example.com", "selected": false},
    {"id": 5, "name": "David Roy", "email": "david@example.com", "selected": false},
  ];

  void _sendNotification() {
    final selectedUsers = users.where((user) => user["selected"]).toList();
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    if (selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one user")),
      );
      return;
    }
    if (title.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title and message")),
      );
      return;
    }

    // In future, integrate API call here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Notification sent to ${selectedUsers.length} users!",
        ),
        backgroundColor: Colors.green,
      ),
    );

    _titleController.clear();
    _messageController.clear();
    setState(() {
      for (var user in users) {
        user["selected"] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Notification"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: AdminSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Notification Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Notification Message",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Users",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return CheckboxListTile(
                    value: user["selected"],
                    onChanged: (val) {
                      setState(() {
                        user["selected"] = val!;
                      });
                    },
                    title: Text(user["name"]),
                    subtitle: Text(user["email"]),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("Send Notification"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _sendNotification,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
