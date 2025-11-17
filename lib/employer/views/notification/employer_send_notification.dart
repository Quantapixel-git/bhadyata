import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class EmployerSendNotificationPage extends StatefulWidget {
  const EmployerSendNotificationPage({super.key});

  @override
  State<EmployerSendNotificationPage> createState() =>
      _EmployerSendNotificationPageState();
}

class _EmployerSendNotificationPageState
    extends State<EmployerSendNotificationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Mock data — replace with your fetched employees list
  final List<Map<String, dynamic>> _employees = [
    {
      "id": 101,
      "name": "John Doe",
      "email": "john@example.com",
      "selected": false,
    },
    {
      "id": 102,
      "name": "Priya Sharma",
      "email": "priya@example.com",
      "selected": false,
    },
    {
      "id": 103,
      "name": "Amit Verma",
      "email": "amit@example.com",
      "selected": false,
    },
    {
      "id": 104,
      "name": "Priya Sharma",
      "email": "priya@example.com",
      "selected": false,
    },
    {
      "id": 105,
      "name": "Amit Verma",
      "email": "amit@example.com",
      "selected": false,
    },
    {
      "id": 106,
      "name": "Priya Sharma",
      "email": "priya@example.com",
      "selected": false,
    },
    {
      "id": 107,
      "name": "Amit Verma",
      "email": "amit@example.com",
      "selected": false,
    },
    {
      "id": 108,
      "name": "Priya Sharma",
      "email": "priya@example.com",
      "selected": false,
    },
    {
      "id": 109,
      "name": "Amit Verma",
      "email": "amit@example.com",
      "selected": false,
    },
  ];

  List<Map<String, dynamic>> get _activeList => _employees;

  int get _selectedCount =>
      _activeList.where((u) => u["selected"] == true).length;

  int get _total => _activeList.length;

  bool get _allSelected => _total > 0 && _selectedCount == _total;

  void _toggleSelectAll(bool value) {
    setState(() {
      for (final u in _activeList) {
        u["selected"] = value;
      }
    });
  }

  void _toggleSingle(Map<String, dynamic> user, bool value) {
    setState(() => user["selected"] = value);
  }

  void _sendNotification() {
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    final selectedEmployees = _employees
        .where((u) => u["selected"] == true)
        .toList();

    if (title.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please enter title and message"),
        ),
      );
      return;
    }
    if (selectedEmployees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please select at least one employee"),
        ),
      );
      return;
    }

    // TODO: Call your backend here with selected employee IDs:
    // final ids = selectedEmployees.map((e) => e["id"]).toList();
    // await api.sendNotificationToEmployees(title, message, ids);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          "Notification sent to ${selectedEmployees.length} employee(s)!",
        ),
      ),
    );

    _titleController.clear();
    _messageController.clear();
    setState(() {
      for (var u in _employees) u["selected"] = false;
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
              // AppBar
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Send Notification",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // Content
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Title
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: "Notification Title",
                          // labelStyle: TextStyle(color: AppColors.primary),
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

                      // Message
                      TextField(
                        controller: _messageController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Notification Message",
                          // labelStyle: TextStyle(color: AppColors.primary),
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

                      // Send button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.send, size: 22),
                          label: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              "Send Notification",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
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
                      const SizedBox(height: 16),

                      // Header: Select all + selected count (EMPLOYEES ONLY)
                      Row(
                        children: [
                          InkWell(
                            onTap: () => _toggleSelectAll(!_allSelected),
                            borderRadius: BorderRadius.circular(8),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _allSelected,
                                  onChanged: (val) =>
                                      _toggleSelectAll(val ?? false),
                                  activeColor: AppColors.primary,
                                ),
                                const Text(
                                  "Select All (Employees)",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              "Selected: $_selectedCount / $_total",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Employees list
                      Expanded(
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            itemCount: _activeList.length,
                            itemBuilder: (context, index) {
                              final user = _activeList[index];
                              return CheckboxListTile(
                                value: user["selected"] as bool,
                                activeColor: AppColors.primary,
                                onChanged: (val) =>
                                    _toggleSingle(user, val ?? false),
                                title: Text(
                                  user["name"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(user["email"]),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
