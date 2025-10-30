import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/view/drawer_dashboard/hr_sidebar.dart';
// import 'package:jobshub/hr/view/drawer_dashboard/hr_dashboard_wrapper.dart';

class HrSendNotificationPage extends StatefulWidget {
  const HrSendNotificationPage({super.key});

  @override
  State<HrSendNotificationPage> createState() => _HrSendNotificationPageState();
}

class _HrSendNotificationPageState extends State<HrSendNotificationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> users = [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "selected": false,
    },
    {
      "id": 2,
      "name": "Priya Sharma",
      "email": "priya@example.com",
      "selected": false,
    },
    {
      "id": 3,
      "name": "Amit Verma",
      "email": "amit@example.com",
      "selected": false,
    },
    {
      "id": 4,
      "name": "Sara Khan",
      "email": "sara@example.com",
      "selected": false,
    },
    {
      "id": 5,
      "name": "David Roy",
      "email": "david@example.com",
      "selected": false,
    },
  ];

  void _sendNotification() {
    final selectedUsers = users.where((u) => u["selected"]).toList();
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
    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Send Notification",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 2,
        ),
        drawer: HrSidebar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Notification Title",
                  labelStyle: TextStyle(color: AppColors.primary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Notification Message",
                  labelStyle: TextStyle(color: AppColors.primary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CheckboxListTile(
                        value: user["selected"],
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            user["selected"] = val!;
                          });
                        },
                        title: Text(
                          user["name"],
                          style: const TextStyle(fontWeight: FontWeight.w500),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
