import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_side_bar.dart';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});

  @override
  State<SendNotificationPage> createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
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

  bool selectAll = false;

  void _toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      for (var user in users) {
        user["selected"] = selectAll;
      }
    });
  }

  int get selectedCount => users.where((u) => u["selected"]).length;

  void _sendNotification() {
    final selectedUsers = users.where((user) => user["selected"]).toList();
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    if (selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please select at least one user"),
        ),
      );
      return;
    }
    if (title.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please enter title and message"),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Notification sent to ${selectedUsers.length} users!"),
        behavior: SnackBarBehavior.floating,
      ),
    );

    _titleController.clear();
    _messageController.clear();
    setState(() {
      for (var user in users) {
        user["selected"] = false;
      }
      selectAll = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              // ✅ Top AppBar - Same structure as AdminDashboard
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // hide drawer icon on web
                title: const Text(
                  "Send Notification",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // ✅ Main content
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: _buildNotificationContent(isWeb),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationContent(bool isWeb) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Send Custom Notification",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Use this feature to send personalized notifications to selected users. "
                "You can notify them about updates, offers, or important messages directly.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // 🔤 Notification Title
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Notification Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),

              // 💬 Notification Message
              TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Notification Message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.message),
                ),
              ),
              const SizedBox(height: 24),

              // 📋 User Selection Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Users",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: selectAll,
                        activeColor: AppColors.primary,
                        onChanged: _toggleSelectAll,
                      ),
                      const Text("Select All"),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Selected: $selectedCount user${selectedCount == 1 ? '' : 's'}",
                  style: TextStyle(
                    fontSize: 13.5,
                    color: selectedCount > 0
                        ? AppColors.primary
                        : Colors.grey.shade600,
                    fontWeight: selectedCount > 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 👥 User List
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return CheckboxListTile(
                      value: user["selected"],
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() {
                          user["selected"] = val!;
                          if (!val) selectAll = false;
                        });
                      },
                      title: Text(user["name"]),
                      subtitle: Text(user["email"]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 🚀 Send Button
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
                  ),
                  onPressed: _sendNotification,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
