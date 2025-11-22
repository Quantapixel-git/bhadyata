// lib/employer/views/leads/leads_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

/// LeadsPage => shows list of employees (with lead counts).
/// Tapping an employee opens EmployeeLeadsPage (detail) which shows their leads.
/// UI-only: uses in-memory mock data (same as before), with debug prints.

class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _employees = [];

  final String _debugImagePath =
      '/mnt/data/d128e1cf-fb88-4966-a6df-f6fc82f26061.png';

  @override
  void initState() {
    super.initState();
    print("INIT: LeadsPage (employees list)"); // DEBUG LOG
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    print("UI: Loading mock data for employees list"); // DEBUG LOG
    setState(() {
      _loading = true;
      _error = null;
    });

    await Future.delayed(const Duration(milliseconds: 250));

    try {
      final List<Map<String, dynamic>> mocked = [
        {
          'employee_id': 101,
          'first_name': 'Asha',
          'last_name': 'Verma',
          'mobile': '9876543210',
          'email': 'asha@example.com',
          'leads': [
            {
              'lead_record_id': 5001,
              'job_id': 201,
              'job_title': 'Sales Executive',
              'lead_name': 'Rahul Sharma',
              'lead_mobile': '9123456780',
              'lead_email': 'rahul.s@example.com',
              'lead_source': 'Website',
              'notes': 'Interested, call in evening',
              'hr_status': 2,
              'employer_status': 2,
              'lead_status': 0,
              'created_at': '2025-11-20 10:12',
            },
            {
              'lead_record_id': 5002,
              'job_id': 202,
              'job_title': 'Delivery Agent',
              'lead_name': 'Sneha Kapoor',
              'lead_mobile': '9988776655',
              'lead_email': '',
              'lead_source': 'Referral',
              'notes': '',
              'hr_status': 1,
              'employer_status': 2,
              'lead_status': 0,
              'created_at': '2025-11-18 09:00',
            },
          ],
        },
        {
          'employee_id': 102,
          'first_name': 'Vikram',
          'last_name': 'Singh',
          'mobile': '9123456789',
          'email': 'vikram@example.com',
          'leads': [
            {
              'lead_record_id': 6001,
              'job_id': 203,
              'job_title': 'Accountant',
              'lead_name': 'Pooja Mehta',
              'lead_mobile': '9001122334',
              'lead_email': 'pooja.m@example.com',
              'lead_source': 'Walk-in',
              'notes': 'Has 3 years experience',
              'hr_status': 0,
              'employer_status': 0,
              'lead_status': 1,
              'created_at': '2025-11-15 14:30',
            },
          ],
        },
        // add more mocked employees here if needed
      ];

      print("MOCK: loaded ${mocked.length} employees"); // DEBUG LOG

      setState(() {
        _employees = mocked;
        _loading = false;
      });
    } catch (ex) {
      print("MOCK LOAD EXCEPTION: $ex"); // DEBUG LOG
      setState(() {
        _error = ex.toString();
        _loading = false;
      });
    }
  }

  String _fullName(Map<String, dynamic> e) {
    final fn = (e['first_name'] ?? '').toString();
    final ln = (e['last_name'] ?? '').toString();
    final name = '$fn ${ln}'.trim();
    if (name.isNotEmpty) return name;
    return e['email'] ?? e['mobile'] ?? 'Employee ${e['employee_id']}';
  }

  @override
  Widget build(BuildContext context) {
    print(
      "BUILD: LeadsPage (list) employees=${_employees.length}",
    ); // DEBUG LOG

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 1000;

        return EmployerDashboardWrapper(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "Leads — Employees",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: AppColors.primary,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _loadMockData,
                ),
              ],
            ),
            drawer: isWeb ? null : const EmployerSidebar(),
            body: Container(
              color: Colors.grey.shade100,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Error: $_error',
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadMockData,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 48 : 12,
                        vertical: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lead Generators',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _employees.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, idx) {
                              final e = _employees[idx];
                              final count = (e['leads'] as List).length;
                              final id = e['employee_id'] as int;
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    print(
                                      "NAV: Opening leads for employee id=$id",
                                    ); // DEBUG LOG
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EmployeeLeadsPage(employee: e),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      _debugImagePath,
                                    ),
                                    backgroundColor: Colors.grey.shade100,
                                  ),
                                  title: Text(_fullName(e)),
                                  subtitle: Text(
                                    e['email'] ?? e['mobile'] ?? '',
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(
                                        0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '$count leads',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

/// EmployeeLeadsPage — shows list of leads for passed employee map.
/// Mutations (status updates / conversion) modify the passed employee's leads in memory.
class EmployeeLeadsPage extends StatefulWidget {
  final Map<String, dynamic> employee;
  const EmployeeLeadsPage({required this.employee, super.key});

  @override
  State<EmployeeLeadsPage> createState() => _EmployeeLeadsPageState();
}

class _EmployeeLeadsPageState extends State<EmployeeLeadsPage> {
  Map<String, dynamic> get emp => widget.employee;
  final String _debugImagePath =
      '/mnt/data/d128e1cf-fb88-4966-a6df-f6fc82f26061.png';

  void _showSnack(String text) {
    print("SNACK: $text"); // DEBUG LOG
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _confirmAndUpdateHR(int leadId, int newStatus) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Confirm'),
        content: Text('Update HR status to ${_hrStatusLabel(newStatus)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (ok == true) {
      final success = await _updateStatus(leadId: leadId, hrStatus: newStatus);
      if (success) _showSnack('HR status updated (local)');
    }
  }

  Future<void> _confirmAndUpdateEmployer(int leadId, int newStatus) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Confirm'),
        content: Text(
          'Update Employer status to ${_employerStatusLabel(newStatus)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (ok == true) {
      final success = await _updateStatus(
        leadId: leadId,
        employerStatus: newStatus,
      );
      if (success) _showSnack('Employer status updated (local)');
    }
  }

  Future<void> _confirmAndMarkConverted(int leadId, int newStatus) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Confirm'),
        content: Text(
          'Mark lead as ${newStatus == 1 ? "Converted" : "Not Converted"}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (ok == true) {
      final success = await _markConverted(leadId, newStatus);
      if (success) _showSnack('Lead converted status updated (local)');
    }
  }

  Future<bool> _updateStatus({
    required int leadId,
    int? hrStatus,
    int? employerStatus,
  }) async {
    print(
      "LOCAL UPDATE (detail): leadId=$leadId hr=$hrStatus emp=$employerStatus",
    ); // DEBUG
    try {
      final leads = (emp['leads'] as List);
      bool updated = false;
      for (final lead in leads) {
        final id = ((lead['lead_record_id'] ?? 0) as num).toInt();
        if (id == leadId) {
          if (hrStatus != null) lead['hr_status'] = hrStatus;
          if (employerStatus != null) lead['employer_status'] = employerStatus;
          updated = true;
          break;
        }
      }
      if (!updated) throw Exception('Lead not found');
      setState(() {});
      return true;
    } catch (e) {
      print("ERROR local update: $e");
      return false;
    }
  }

  Future<bool> _markConverted(int leadId, int leadStatus) async {
    print(
      "LOCAL CONVERT (detail): leadId=$leadId leadStatus=$leadStatus",
    ); // DEBUG
    try {
      final leads = (emp['leads'] as List);
      bool updated = false;
      for (final lead in leads) {
        final id = ((lead['lead_record_id'] ?? 0) as num).toInt();
        if (id == leadId) {
          lead['lead_status'] = leadStatus;
          updated = true;
          break;
        }
      }
      if (!updated) throw Exception('Lead not found');
      setState(() {});
      return true;
    } catch (e) {
      print("ERROR local convert: $e");
      return false;
    }
  }

  String _hrStatusLabel(int s) {
    switch (s) {
      case 0:
        return 'Rejected';
      case 1:
        return 'Approved';
      default:
        return 'Pending';
    }
  }

  String _employerStatusLabel(int s) {
    switch (s) {
      case 0:
        return 'Rejected';
      case 1:
        return 'Approved';
      default:
        return 'Pending';
    }
  }

  String _leadStatusLabel(int s) => s == 1 ? 'Converted' : 'Not Converted';

  String _fullName(Map<String, dynamic> e) {
    final fn = (e['first_name'] ?? '').toString();
    final ln = (e['last_name'] ?? '').toString();
    final name = '$fn ${ln}'.trim();
    if (name.isNotEmpty) return name;
    return e['email'] ?? e['mobile'] ?? 'Employee ${e['employee_id']}';
  }

  @override
  Widget build(BuildContext context) {
    final List leads = (emp['leads'] as List);
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 1000;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              '${_fullName(emp)} — Leads',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.primary,
          ),
          // drawer: isWeb ? null : const EmployerSidebar(),
          body: Container(
            color: Colors.grey.shade100,
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? 48 : 12,
              vertical: 18,
            ),
            child: leads.isEmpty
                ? const Center(child: Text('No leads for this employee.'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total leads: ${leads.length}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        ...leads.map<Widget>((l) {
                          final int leadId = ((l['lead_record_id'] ?? 0) as num)
                              .toInt();
                          final int hrStatus = (l['hr_status'] ?? 2) as int;
                          final int employerStatus =
                              (l['employer_status'] ?? 2) as int;
                          final int leadStatus = (l['lead_status'] ?? 0) as int;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        l['lead_name'] ??
                                            (l['job_title'] ?? 'Unnamed'),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      l['created_at'] != null
                                          ? l['created_at']
                                                .toString()
                                                .substring(0, 16)
                                          : '',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if ((l['lead_mobile'] ?? '')
                                        .toString()
                                        .isNotEmpty) ...[
                                      const Icon(Icons.phone, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        l['lead_mobile'] ?? '',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                    if ((l['lead_email'] ?? '')
                                        .toString()
                                        .isNotEmpty) ...[
                                      const Icon(Icons.email, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        l['lead_email'] ?? '',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ],
                                ),
                                if ((l['notes'] ?? '')
                                    .toString()
                                    .isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    l['notes'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Chip(
                                      avatar: CircleAvatar(
                                        backgroundColor: hrStatus == 1
                                            ? Colors.green.withOpacity(0.15)
                                            : (hrStatus == 0
                                                  ? Colors.red.withOpacity(0.15)
                                                  : Colors.orange.withOpacity(
                                                      0.15,
                                                    )),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: hrStatus == 1
                                              ? Colors.green
                                              : (hrStatus == 0
                                                    ? Colors.red
                                                    : Colors.orange),
                                          size: 16,
                                        ),
                                      ),
                                      label: Text(
                                        'HR: ${_hrStatusLabel(hrStatus)}',
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    PopupMenuButton<int>(
                                      onSelected: (val) =>
                                          _confirmAndUpdateHR(leadId, val),
                                      itemBuilder: (_) => const [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Text('Approve'),
                                        ),
                                        PopupMenuItem(
                                          value: 0,
                                          child: Text('Reject'),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Text('Pending'),
                                        ),
                                      ],
                                      child: const Chip(
                                        label: Text('Change HR'),
                                        avatar: Icon(Icons.edit, size: 16),
                                      ),
                                    ),
                                    Chip(
                                      avatar: CircleAvatar(
                                        backgroundColor: employerStatus == 1
                                            ? Colors.green.withOpacity(0.15)
                                            : (employerStatus == 0
                                                  ? Colors.red.withOpacity(0.15)
                                                  : Colors.orange.withOpacity(
                                                      0.15,
                                                    )),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: employerStatus == 1
                                              ? Colors.green
                                              : (employerStatus == 0
                                                    ? Colors.red
                                                    : Colors.orange),
                                          size: 16,
                                        ),
                                      ),
                                      label: Text(
                                        'Employer: ${_employerStatusLabel(employerStatus)}',
                                      ),
                                      backgroundColor: Colors.white,
                                    ),

                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Chip(
                                          avatar: CircleAvatar(
                                            backgroundColor: leadStatus == 1
                                                ? Colors.green.withOpacity(0.15)
                                                : Colors.grey.withOpacity(0.15),
                                            child: Icon(
                                              Icons.check_circle,
                                              color: leadStatus == 1
                                                  ? Colors.green
                                                  : Colors.grey,
                                              size: 16,
                                            ),
                                          ),
                                          label: Text(
                                            'Converted: ${_leadStatusLabel(leadStatus)}',
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                        const SizedBox(height: 6),
                                        DropdownButton<int>(
                                          value: leadStatus,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 0,
                                              child: Text('Not Converted'),
                                            ),
                                            DropdownMenuItem(
                                              value: 1,
                                              child: Text('Converted'),
                                            ),
                                          ],
                                          onChanged: (val) {
                                            if (val == null) return;
                                            _confirmAndMarkConverted(
                                              leadId,
                                              val,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
