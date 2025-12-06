import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

enum JobGroup { salary, commission, oneTime, project }

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

  // Separate lists per job type
  final List<Map<String, dynamic>> _salaryEmployees = [];
  final List<Map<String, dynamic>> _commissionEmployees = [];
  final List<Map<String, dynamic>> _oneTimeEmployees = [];
  final List<Map<String, dynamic>> _projectEmployees = [];

  JobGroup _activeGroup = JobGroup.salary;

  // loading state per group
  bool _loadingSalary = false;
  bool _loadingCommission = false;
  bool _loadingOneTime = false;
  bool _loadingProject = false;

  bool _error = false;
  String? _errorMessage;
  bool _includeTerminated = true;

  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _fetchEmployeesForGroup(JobGroup.salary);
  }

  // ---------- Helpers ----------

  List<Map<String, dynamic>> get _allEmployees => [
    ..._salaryEmployees,
    ..._commissionEmployees,
    ..._oneTimeEmployees,
    ..._projectEmployees,
  ];

  List<Map<String, dynamic>> get _activeList {
    switch (_activeGroup) {
      case JobGroup.salary:
        return _salaryEmployees;
      case JobGroup.commission:
        return _commissionEmployees;
      case JobGroup.oneTime:
        return _oneTimeEmployees;
      case JobGroup.project:
        return _projectEmployees;
    }
  }

  bool get _isActiveLoading {
    switch (_activeGroup) {
      case JobGroup.salary:
        return _loadingSalary;
      case JobGroup.commission:
        return _loadingCommission;
      case JobGroup.oneTime:
        return _loadingOneTime;
      case JobGroup.project:
        return _loadingProject;
    }
  }

  int get _selectedCountActive =>
      _activeList.where((u) => u["selected"] == true).length;

  int get _totalActive => _activeList.length;

  bool get _allSelectedActive =>
      _totalActive > 0 && _selectedCountActive == _totalActive;

  int get _totalSelectedOverall =>
      _allEmployees.where((u) => u["selected"] == true).length;

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

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(msg)),
    );
  }

  String _pathForGroup(JobGroup group) {
    switch (group) {
      case JobGroup.salary:
        return 'SalaryemployeesByEmployer';
      case JobGroup.commission:
        return 'commissionEmployeesByEmployer';
      case JobGroup.oneTime:
        return 'oneTimeEmployeesByEmployer';
      case JobGroup.project:
        return 'projectEmployeesByEmployer';
    }
  }

  // ---------- API: fetch employees of employer (one job type at a time) ----------

  Future<void> _fetchEmployeesForGroup(JobGroup group) async {
    setState(() {
      _error = false;
      _errorMessage = null;
      if (group == JobGroup.salary) _loadingSalary = true;
      if (group == JobGroup.commission) _loadingCommission = true;
      if (group == JobGroup.oneTime) _loadingOneTime = true;
      if (group == JobGroup.project) _loadingProject = true;
    });

    try {
      final dynamic userIdRaw = await SessionManager.getValue('employer_id');

      int? employerId;
      if (userIdRaw == null) {
        employerId = null;
      } else if (userIdRaw is int) {
        employerId = userIdRaw;
      } else if (userIdRaw is String) {
        employerId = int.tryParse(userIdRaw);
      } else {
        employerId = null;
      }

      if (employerId == null) {
        setState(() {
          _error = true;
          _errorMessage = 'Could not read employer id from session.';
        });
        return;
      }

      final path = _pathForGroup(group);
      final uri = Uri.parse("${ApiConstants.baseUrl}$path");
      final body = jsonEncode({
        'employer_id': employerId,
        'include_terminated': _includeTerminated,
      });

      final resp = await http.post(
        uri,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      print("\n===== $path =====");
      print("Status: ${resp.statusCode}");
      print(resp.body);

      if (resp.statusCode != 200) {
        throw Exception(
          'Server returned ${resp.statusCode} on $path: '
          '${resp.body.length > 200 ? resp.body.substring(0, 200) : resp.body}',
        );
      }

      final Map<String, dynamic> j = jsonDecode(resp.body);
      if (j['success'] != true) {
        throw Exception(j['message'] ?? '$path returned failure');
      }

      final List<dynamic> data = j['data'] as List<dynamic>? ?? <dynamic>[];

      Map<String, dynamic> _mapEmployee(Map item) {
        final first = (item['first_name'] ?? '').toString();
        final last = (item['last_name'] ?? '').toString();
        final name = (first + ' ' + last).trim().isEmpty
            ? (item['mobile'] ?? '').toString()
            : (first + ' ' + last).trim();

        return {
          'id': item['employee_id'],
          'name': name,
          'email': item['email'] ?? item['mobile'] ?? '',
          'selected': false,
        };
      }

      final mapped = data
          .whereType<Map>()
          .where((e) => e['employee_id'] != null)
          .map(_mapEmployee)
          .toList();

      setState(() {
        if (group == JobGroup.salary) {
          _salaryEmployees
            ..clear()
            ..addAll(mapped);
        } else if (group == JobGroup.commission) {
          _commissionEmployees
            ..clear()
            ..addAll(mapped);
        } else if (group == JobGroup.oneTime) {
          _oneTimeEmployees
            ..clear()
            ..addAll(mapped);
        } else if (group == JobGroup.project) {
          _projectEmployees
            ..clear()
            ..addAll(mapped);
        }
      });
    } catch (e) {
      setState(() {
        _error = true;
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        if (group == JobGroup.salary) _loadingSalary = false;
        if (group == JobGroup.commission) _loadingCommission = false;
        if (group == JobGroup.oneTime) _loadingOneTime = false;
        if (group == JobGroup.project) _loadingProject = false;
      });
    }
  }

  Future<void> _sendNotification() async {
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    if (title.isEmpty || message.isEmpty) {
      _showSnack("Please enter title and message");
      return;
    }

    // Selected from ALL job types, de-duplicated by id
    final Set<int> idSet = {};
    for (final list in [
      _salaryEmployees,
      _commissionEmployees,
      _oneTimeEmployees,
      _projectEmployees,
    ]) {
      for (final u in list) {
        if (u['selected'] == true && u['id'] is int) {
          idSet.add(u['id'] as int);
        }
      }
    }

    if (idSet.isEmpty) {
      _showSnack("Please select at least one employee");
      return;
    }

    // 👇 get sender_id from session (employer_id)
    final dynamic senderRaw = await SessionManager.getValue('employer_id');
    int? senderId;
    if (senderRaw is int) {
      senderId = senderRaw;
    } else if (senderRaw is String) {
      senderId = int.tryParse(senderRaw);
    }

    if (senderId == null) {
      _showSnack("Could not read employer id from session.");
      return;
    }

    final ids = idSet.toList();

    dynamic userIdPayload;
    if (ids.length == 1) {
      userIdPayload = ids.first;
    } else {
      userIdPayload = ids;
    }

    final url = Uri.parse("${ApiConstants.baseUrl}sendNotification");

    setState(() => _sending = true);

    try {
      final body = {
        "user_id": userIdPayload,
        "sender_id": senderId, // 👈 send sender_id
        "title": title,
        "message": message,
      };

      // 🔍 DEBUG: what we are sending
      print("\n===== EMPLOYER SEND NOTIFICATION DEBUG =====");
      print("Endpoint: $url");
      print("Sender ID (employer_id): $senderId");
      print("Selected user IDs: $ids");
      print("Request body JSON: ${jsonEncode(body)}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      // 🔍 DEBUG: what we received
      print("Status code: ${response.statusCode}");
      print("Raw response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        print("Decoded response JSON: $json"); // extra debug

        final success = json['success'] == true || json['status'] == 1;

        if (success) {
          _showSnack("Notification sent to ${ids.length} employee(s)!");

          _titleController.clear();
          _messageController.clear();
          setState(() {
            for (var list in [
              _salaryEmployees,
              _commissionEmployees,
              _oneTimeEmployees,
              _projectEmployees,
            ]) {
              for (var u in list) {
                u["selected"] = false;
              }
            }
          });
        } else {
          _showSnack(json['message'] ?? "Failed to send notification");
        }
      } else {
        _showSnack("Error: ${response.statusCode} while sending notification");
      }
    } catch (e) {
      print("❌ employer sendNotification error: $e");
      _showSnack("Something went wrong while sending notification");
    } finally {
      setState(() => _sending = false);
    }
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
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
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => _fetchEmployeesForGroup(_activeGroup),
                  ),
                ],
              ),

              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),

                        // include terminated toggle
                        // SwitchListTile(
                        //   contentPadding: EdgeInsets.zero,
                        //   title: const Text("Include terminated employees"),
                        //   value: _includeTerminated,
                        //   onChanged: (val) {
                        //     setState(() => _includeTerminated = val);
                        //     // reload current group with new flag
                        //     _fetchEmployeesForGroup(_activeGroup);
                        //   },
                        // ),
                        // const SizedBox(height: 8),

                        // Title
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: "Notification Title",
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
                        const SizedBox(height: 10),

                        // Job type switcher + overall selected
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
                                minWidth: 88,
                              ),
                              isSelected: [
                                _activeGroup == JobGroup.salary,
                                _activeGroup == JobGroup.commission,
                                _activeGroup == JobGroup.oneTime,
                                _activeGroup == JobGroup.project,
                              ],
                              onPressed: (i) {
                                final selectedGroup = JobGroup
                                    .values[i]; // order: salary, commission, oneTime, project
                                setState(() {
                                  _activeGroup = selectedGroup;
                                });

                                // If that group has never been loaded, fetch it
                                if (_activeList.isEmpty && !_isActiveLoading) {
                                  _fetchEmployeesForGroup(selectedGroup);
                                }
                              },
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  child: Text(
                                    "Salary",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  child: Text(
                                    "Commission",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  child: Text(
                                    "One-time",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  child: Text(
                                    "Project",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),

                            // const Spacer(),
                          ],
                        ),
                        SizedBox(height: 8),
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
                            "Total Selected: $_totalSelectedOverall",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (_error)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              _errorMessage ?? 'Error loading employees.',
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),

                        // Select all + selected count (ACTIVE group)
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
                                    "Select All (${_activeGroup.name})",
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

                        // Employees list for active group
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
                                      "No employees found for this job type",
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
                                        user["name"],
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
