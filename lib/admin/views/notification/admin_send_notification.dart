import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';

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

  // Will be filled from API
  final List<Map<String, dynamic>> _employees = [];
  final List<Map<String, dynamic>> _employers = [];
  final List<Map<String, dynamic>> _hrs = [];

  UserGroup _activeGroup = UserGroup.employees;

  bool _loadingEmployees = false;
  bool _loadingEmployers = false;
  bool _loadingHrs = false;

  bool _sending = false;

  @override
  void initState() {
    super.initState();
    // load employees by default
    _fetchUsersForGroup(UserGroup.employees);
  }

  // ---------- Helpers ----------

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

  bool get _isActiveLoading {
    switch (_activeGroup) {
      case UserGroup.employers:
        return _loadingEmployers;
      case UserGroup.hrs:
        return _loadingHrs;
      case UserGroup.employees:
      default:
        return _loadingEmployees;
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

  int _roleForGroup(UserGroup group) {
    switch (group) {
      case UserGroup.employees:
        return 1; // employee
      case UserGroup.employers:
        return 2; // employer
      case UserGroup.hrs:
        return 3; // hr
    }
  }

  // ---------- API: usersByRole ----------

  Future<void> _fetchUsersForGroup(UserGroup group) async {
    final role = _roleForGroup(group);
    final url = Uri.parse("${ApiConstants.baseUrl}usersByRole");

    setState(() {
      if (group == UserGroup.employees) _loadingEmployees = true;
      if (group == UserGroup.employers) _loadingEmployers = true;
      if (group == UserGroup.hrs) _loadingHrs = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"role": role}),
      );

      print("\n===== usersByRole (role=$role) =====");
      print("Status: ${response.statusCode}");
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> list = data['data'] ?? [];

          final mapped = list.map<Map<String, dynamic>>((u) {
            final first = (u['first_name'] ?? '').toString();
            final last = (u['last_name'] ?? '').toString();
            final name = (first + ' ' + last).trim().isEmpty
                ? u['mobile'].toString()
                : (first + ' ' + last).trim();

            return {
              "id": u['id'],
              "name": name,
              "email": u['email'] ?? u['mobile'] ?? '',
              "selected": false,
            };
          }).toList();

          setState(() {
            if (group == UserGroup.employees) {
              _employees
                ..clear()
                ..addAll(mapped);
            } else if (group == UserGroup.employers) {
              _employers
                ..clear()
                ..addAll(mapped);
            } else {
              _hrs
                ..clear()
                ..addAll(mapped);
            }
          });
        } else {
          _showSnack(data['message'] ?? "Failed to fetch users (role=$role)");
        }
      } else {
        _showSnack("Error ${response.statusCode} fetching users (role=$role)");
      }
    } catch (e) {
      print("❌ usersByRole error: $e");
      _showSnack("Something went wrong while fetching users");
    } finally {
      setState(() {
        if (group == UserGroup.employees) _loadingEmployees = false;
        if (group == UserGroup.employers) _loadingEmployers = false;
        if (group == UserGroup.hrs) _loadingHrs = false;
      });
    }
  }

  // ---------- API: sendNotification ----------

  Future<void> _sendNotification() async {
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
      _showSnack("Please enter title and message");
      return;
    }
    if (totalSelected == 0) {
      _showSnack("Please select at least one user");
      return;
    }

    // Collect all user IDs
    final ids = <int>[
      ...selectedEmployees.map<int>((u) => u['id'] as int),
      ...selectedEmployers.map<int>((u) => u['id'] as int),
      ...selectedHrs.map<int>((u) => u['id'] as int),
    ];

    dynamic userIdPayload;
    if (ids.length == 1) {
      userIdPayload = ids.first; // single
    } else {
      userIdPayload = ids; // array
    }

    final url = Uri.parse("${ApiConstants.baseUrl}sendNotification");

    setState(() => _sending = true);

    try {
      final body = {
        "user_id": userIdPayload,
        "title": title,
        "message": message,
      };

      print("\n===== sendNotification =====");
      print("Body: ${jsonEncode(body)}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final success = json['success'] == true || json['status'] == 1;

        if (success) {
          _showSnack("Notification sent to $totalSelected users!");

          _titleController.clear();
          _messageController.clear();
          setState(() {
            for (var u in _employees) u["selected"] = false;
            for (var u in _employers) u["selected"] = false;
            for (var u in _hrs) u["selected"] = false;
          });
        } else {
          _showSnack(json['message'] ?? "Failed to send notification");
        }
      } else {
        _showSnack("Error: ${response.statusCode} while sending notification");
      }
    } catch (e) {
      print("❌ sendNotification error: $e");
      _showSnack("Something went wrong while sending notification");
    } finally {
      setState(() => _sending = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(msg)),
    );
  }

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

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return AdminDashboardWrapper(
          child: Column(
            children: [
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

              // Main body
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    // This scrolls when keyboard opens
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10,),
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

                        // Send button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: _sending
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send, size: 22),
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
                            onPressed: _sending ? null : _sendNotification,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Group switcher + counts
                        if (isWeb) ...[
                          Row(
                            children: [
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
                                    if (i == 0) {
                                      _activeGroup = UserGroup.employees;
                                      if (_employees.isEmpty &&
                                          !_loadingEmployees) {
                                        _fetchUsersForGroup(
                                          UserGroup.employees,
                                        );
                                      }
                                    }
                                    if (i == 1) {
                                      _activeGroup = UserGroup.employers;
                                      if (_employers.isEmpty &&
                                          !_loadingEmployers) {
                                        _fetchUsersForGroup(
                                          UserGroup.employers,
                                        );
                                      }
                                    }
                                    if (i == 2) {
                                      _activeGroup = UserGroup.hrs;
                                      if (_hrs.isEmpty && !_loadingHrs) {
                                        _fetchUsersForGroup(UserGroup.hrs);
                                      }
                                    }
                                  });
                                },
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Text("Employees"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Text("Employers"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Text("HRs"),
                                  ),
                                ],
                              ),
                              const Spacer(),
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
                        ] else ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ToggleButtons(
                                  borderRadius: BorderRadius.circular(10),
                                  selectedColor: Colors.white,
                                  color: AppColors.primary,
                                  fillColor: AppColors.primary,
                                  borderColor: AppColors.primary.withOpacity(
                                    .35,
                                  ),
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
                                      if (i == 0) {
                                        _activeGroup = UserGroup.employees;
                                        if (_employees.isEmpty &&
                                            !_loadingEmployees) {
                                          _fetchUsersForGroup(
                                            UserGroup.employees,
                                          );
                                        }
                                      }
                                      if (i == 1) {
                                        _activeGroup = UserGroup.employers;
                                        if (_employers.isEmpty &&
                                            !_loadingEmployers) {
                                          _fetchUsersForGroup(
                                            UserGroup.employers,
                                          );
                                        }
                                      }
                                      if (i == 2) {
                                        _activeGroup = UserGroup.hrs;
                                        if (_hrs.isEmpty && !_loadingHrs) {
                                          _fetchUsersForGroup(UserGroup.hrs);
                                        }
                                      }
                                    });
                                  },
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: Text("Employees"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: Text("Employers"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: Text("HRs"),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _Badge(
                                    label: "Employee",
                                    value: _selectedCountEmployees.toString(),
                                    color: Colors.teal,
                                  ),
                                  const SizedBox(width: 8),
                                  _Badge(
                                    label: "Employer",
                                    value: _selectedCountEmployers.toString(),
                                    color: Colors.indigo,
                                  ),
                                  const SizedBox(width: 8),
                                  _Badge(
                                    label: "HR",
                                    value: _selectedCountHrs.toString(),
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 10),

                        // Select all + counts
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

                        // Active list (non-Expanded; height managed by outer scroll view)
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _isActiveLoading
                              ? const SizedBox(
                                  height: 120,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : _activeList.isEmpty
                              ? const SizedBox(
                                  height: 120,
                                  child: Center(
                                    child: Text(
                                      "No users found for this group",
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  itemCount: _activeList.length,
                                  itemBuilder: (context, index) {
                                    final user = _activeList[index];
                                    return CheckboxListTile(
                                      value: user["selected"] as bool? ?? false,
                                      activeColor: AppColors.primary,
                                      onChanged: (val) =>
                                          _toggleSingle(user, val ?? false),
                                      title: Text(
                                        user["name"] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(user["email"] ?? ''),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
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
