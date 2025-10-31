import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class AdminSendNotificationPage extends StatefulWidget {
  const AdminSendNotificationPage({super.key});

  @override
  State<AdminSendNotificationPage> createState() => _AdminSendNotificationPageState();
}

class _AdminSendNotificationPageState extends State<AdminSendNotificationPage> {
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

    // Future API integration placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Notification sent to ${selectedUsers.length} users!"),
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
    return AdminDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Send Notification",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.primary,
        ),
        drawer: AdminSidebar(),
        body: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Notification Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Message Input
              TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Notification Message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Select Users",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              // User List
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: CheckboxListTile(
                        value: user["selected"],
                        onChanged: (val) {
                          setState(() {
                            user["selected"] = val!;
                          });
                        },
                        activeColor: AppColors.primary,
                        title: Text(
                          user["name"],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(user["email"]),
                      ),
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
                    backgroundColor: AppColors.primary,
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
      ),
    );
  }
}
