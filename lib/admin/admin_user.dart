import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({super.key});

  @override
  State<AdminUser> createState() => _AdminUserState();
}

class _AdminUserState extends State<AdminUser> {
  final List<Map<String, dynamic>> users = [
    {
      "name": "John Doe",
      "email": "john@example.com",
      "mobile": "9876543210",
      "role": "User",
      "blocked": false
    },
    {
      "name": "Jane Smith",
      "email": "jane@example.com",
      "mobile": "9123456780",
      "role": "Client",
      "blocked": true
    },
    {
      "name": "Mike Johnson",
      "email": "mike@example.com",
      "mobile": "9001234567",
      "role": "User",
      "blocked": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Manage Users",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: users.isEmpty
            ? const Center(child: Text("No users found"))
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        user["name"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text("Email: ${user["email"]}"),
                          Text("Mobile: ${user["mobile"]}"),
                          Text("Role: ${user["role"]}"),
                        ],
                      ),
                      trailing: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user["blocked"] ? "Blocked" : "Unblocked",
                              style: TextStyle(
                                color: user["blocked"] ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Switch(
                                value: user["blocked"],
                                activeColor: Colors.red,
                                onChanged: (value) {
                                  setState(() {
                                    user["blocked"] = value;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "${user["name"]} ${value ? "blocked" : "unblocked"}"),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    ),
                  );
                },
              ),
      ),
    );
  }
}
