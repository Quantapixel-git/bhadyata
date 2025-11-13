import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

enum UserGroup { employees, employers, hrs }

class AdminSendNotificationPage extends StatefulWidget {
  const AdminSendNotificationPage({super.key});

  @override
  State<AdminSendNotificationPage> createState() =>
      _AdminSendNotificationPageState();
}

class _AdminSendNotificationPageState extends State<AdminSendNotificationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Mock data — replace with your fetched lists later
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
  ];

  final List<Map<String, dynamic>> _employers = [
    {
      "id": 201,
      "name": "TechNova Pvt Ltd",
      "email": "hr@technova.com",
      "selected": false,
    },
    {
      "id": 202,
      "name": "CodeSphere Inc",
      "email": "hr@codesphere.io",
      "selected": false,
    },
    {
      "id": 203,
      "name": "BuildRight Solutions",
      "email": "hr@buildright.in",
      "selected": false,
    },
  ];

  // NEW: HR list
  final List<Map<String, dynamic>> _hrs = [
    {
      "id": 301,
      "name": "Rita Kapoor",
      "email": "rita.hr@example.com",
      "selected": false,
    },
    {
      "id": 302,
      "name": "Sameer Khan",
      "email": "sameer.hr@example.com",
      "selected": false,
    },
    {
      "id": 303,
      "name": "Lina Mathew",
      "email": "lina.hr@example.com",
      "selected": false,
    },
  ];

  UserGroup _activeGroup = UserGroup.employees;

  List<Map<String, dynamic>> get _activeList {
    switch (_activeGroup) {
      case UserGroup.employers:
        return _employers;
      case UserGroup.hrs:
        return _hrs;
      case UserGroup.employees:
      default:
        return _employees;
    }
  }

  int get _selectedCountEmployees =>
      _employees.where((u) => u["selected"] == true).length;

  int get _selectedCountEmployers =>
      _employers.where((u) => u["selected"] == true).length;

  int get _selectedCountHrs => _hrs.where((u) => u["selected"] == true).length;

  int get _selectedCountActive =>
      _activeList.where((u) => u["selected"] == true).length;

  int get _totalActive => _activeList.length;

  bool get _allSelectedActive =>
      _totalActive > 0 && _selectedCountActive == _totalActive;

  void _toggleSelectAllActive(bool value) {
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
    final selectedEmployers = _employers
        .where((u) => u["selected"] == true)
        .toList();
    final selectedHrs = _hrs.where((u) => u["selected"] == true).toList();

    final totalSelected =
        selectedEmployees.length +
        selectedEmployers.length +
        selectedHrs.length;

    if (title.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please enter title and message"),
        ),
      );
      return;
    }
    if (totalSelected == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please select at least one user"),
        ),
      );
      return;
    }

    // TODO: Hook your API call here
    // - send lists of ids: selectedEmployees.map((e) => e["id"]), selectedEmployers.map(...), selectedHrs.map(...)
    // - clear after success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Notification sent to $totalSelected users!"),
      ),
    );

    _titleController.clear();
    _messageController.clear();
    setState(() {
      for (var u in _employees) u["selected"] = false;
      for (var u in _employers) u["selected"] = false;
      for (var u in _hrs) u["selected"] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return AdminDashboardWrapper(
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

                      // Message
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
                      const SizedBox(height: 12),

                      // Send button (right below title & message)
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

                      // Group switcher + counts
                      Row(
                        children: [
                          // Group toggle (now 3 options)
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: Colors.white,
                            color: AppColors.primary,
                            fillColor: AppColors.primary,
                            borderColor: AppColors.primary.withOpacity(.35),
                            selectedBorderColor: AppColors.primary,
                            constraints: const BoxConstraints(
                              minHeight: 36,
                              minWidth: 110,
                            ),
                            isSelected: [
                              _activeGroup == UserGroup.employees,
                              _activeGroup == UserGroup.employers,
                              _activeGroup == UserGroup.hrs,
                            ],
                            onPressed: (i) {
                              setState(() {
                                if (i == 0) _activeGroup = UserGroup.employees;
                                if (i == 1) _activeGroup = UserGroup.employers;
                                if (i == 2) _activeGroup = UserGroup.hrs;
                              });
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text("Employees"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text("Employers"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text("HRs"),
                              ),
                            ],
                          ),
                          const Spacer(),

                          // Overall selected badges
                          _Badge(
                            label: "Emp Selected",
                            value: _selectedCountEmployees.toString(),
                            color: Colors.teal,
                          ),
                          const SizedBox(width: 8),
                          _Badge(
                            label: "Er Selected",
                            value: _selectedCountEmployers.toString(),
                            color: Colors.indigo,
                          ),
                          const SizedBox(width: 8),
                          _Badge(
                            label: "HR Selected",
                            value: _selectedCountHrs.toString(),
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Select all + selected count for ACTIVE list
                      Row(
                        children: [
                          InkWell(
                            onTap: () =>
                                _toggleSelectAllActive(!_allSelectedActive),
                            borderRadius: BorderRadius.circular(8),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _allSelectedActive,
                                  onChanged: (val) =>
                                      _toggleSelectAllActive(val ?? false),
                                  activeColor: AppColors.primary,
                                ),
                                Text(
                                  "Select All (${_activeGroup == UserGroup.employees
                                      ? "Employees"
                                      : _activeGroup == UserGroup.employers
                                      ? "Employers"
                                      : "HRs"})",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
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
                              "Selected: $_selectedCountActive / $_totalActive",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Active list
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

class _Badge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Badge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
