// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/leads/leads_list_page.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

const String API_BASE = 'https://dialfirst.in/quantapixel/badhyata/api';

class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _employees = [];

  // static employer id and include_terminated as you requested
  final int _employerId = 53;
  final bool _includeTerminated = true;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    setState(() {
      _loading = true;
      _error = null;
      _employees = [];
    });

    try {
      // ✅ Get employer_id from SessionManager
      final employerIdStr = await SessionManager.getValue('employer_id');

      if (employerIdStr == null || employerIdStr.toString().isEmpty) {
        setState(() {
          _error = 'Employer ID not found. Please log in again.';
          _loading = false;
        });
        return;
      }

      final employerId = int.tryParse(employerIdStr.toString()) ?? 0;

      final uri = Uri.parse('$API_BASE/commissionEmployeesByEmployerWithLeads');
      final body = jsonEncode({
        'employer_id': employerId,
        'include_terminated': _includeTerminated,
      });

      final resp = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        throw Exception('HTTP ${resp.statusCode}: ${resp.reasonPhrase}');
      }

      final Map<String, dynamic> j = jsonDecode(resp.body);
      if (j['success'] != true) {
        throw Exception(j['message'] ?? 'API returned failure');
      }

      final List<dynamic> data = j['data'] ?? [];
      final mapped = data.map<Map<String, dynamic>>((item) {
        final assignments = (item['assignments'] as List<dynamic>? ?? [])
            .map<Map<String, dynamic>>(
              (a) => Map<String, dynamic>.from(a as Map),
            )
            .toList();

        return {
          'employee_id': item['employee_id'],
          'first_name': item['first_name'],
          'last_name': item['last_name'],
          'mobile': item['mobile'],
          'email': item['email'],
          'assignments': assignments,
          'total_leads': item['total_leads'] ?? 0,
        };
      }).toList();

      setState(() {
        _employees = mapped;
        _loading = false;
      });
    } on TimeoutException catch (_) {
      setState(() {
        _error = 'Request timed out';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _fullName(Map<String, dynamic> e) {
    final fn = (e['first_name'] ?? '').toString();
    final ln = (e['last_name'] ?? '').toString();
    final name = '$fn $ln'.trim();
    if (name.isNotEmpty) return name;
    return e['email'] ?? e['mobile'] ?? 'Employee ${e['employee_id']}';
  }

  Future<void> _openLeadsForAssignment(Map<String, dynamic> employee) async {
    final assignments = (employee['assignments'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    if (assignments.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No assignments for this employee.')),
      );
      return;
    }

    Map<String, dynamic>? chosen;
    if (assignments.length == 1) {
      chosen = assignments[0];
    } else {
      chosen = await showDialog<Map<String, dynamic>?>(
        context: context,
        builder: (c) {
          return SimpleDialog(
            title: const Text('Select job to view leads'),
            children: assignments.map<Widget>((a) {
              final title = (a['title'] ?? 'Untitled').toString();
              final count = (a['leads_count'] ?? 0) as int;
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(c, a),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(title), Text('$count')],
                ),
              );
            }).toList(),
          );
        },
      );
    }

    if (chosen == null) return;

    // ✅ Get employer_id from SessionManager here too
    final employerIdStr = await SessionManager.getValue('employer_id');
    final employerId = int.tryParse(employerIdStr?.toString() ?? '0') ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmployeeLeadsPageNetwork(
          employerId: employerId,
          employeeId: (employee['employee_id'] as num).toInt(),
          jobId: (chosen?['job_id'] as num).toInt(),
          employeeName: _fullName(employee),
          jobTitle: (chosen?['title'] ?? '').toString(),
        ),
      ),
    );
  }

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
                  "Commission Employees",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _fetchEmployees,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: Container(
                    color: Colors.grey.shade100,
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 24 : 12,
                      vertical: 10,
                    ),
                    child: _buildBody(isWeb),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(bool isWeb) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchEmployees,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_employees.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No employees found.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextButton(onPressed: _fetchEmployees, child: const Text('Reload')),
          ],
        ),
      );
    }

    if (isWeb) {
      return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.6,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: _employees.length,
        itemBuilder: (context, idx) {
          final e = _employees[idx];
          return _CommissionEmployeeCard(
            employee: e,
            onViewLeads: _openLeadsForAssignment,
          );
        },
      );
    } else {
      return ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: _employees.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, idx) {
          final e = _employees[idx];
          return _CommissionEmployeeCard(
            employee: e,
            onViewLeads: _openLeadsForAssignment,
          );
        },
      );
    }
  }
}

/// Card similar to your CommissionEmployeesPage with leads count badges.
class _CommissionEmployeeCard extends StatefulWidget {
  final Map<String, dynamic> employee;
  final Future<void> Function(Map<String, dynamic>) onViewLeads;

  const _CommissionEmployeeCard({
    required this.employee,
    required this.onViewLeads,
  });

  @override
  State<_CommissionEmployeeCard> createState() =>
      _CommissionEmployeeCardState();
}

class _CommissionEmployeeCardState extends State<_CommissionEmployeeCard> {
  bool _expanded = false;

  String _fullName(Map<String, dynamic> e) {
    final fn = (e['first_name'] ?? '').toString();
    final ln = (e['last_name'] ?? '').toString();
    final name = '$fn $ln'.trim();
    if (name.isNotEmpty) return name;
    return e['email'] ?? e['mobile'] ?? 'Employee ${e['employee_id']}';
  }

  String _fmtDate(String? raw) {
    if (raw == null) return '';
    return raw.length >= 16 ? raw.substring(0, 16) : raw;
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.employee;
    final assignments = (e['assignments'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final primary = assignments.isNotEmpty ? assignments[0] : null;
    final totalLeads = (e['total_leads'] ?? 0) as int;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const SizedBox(width: 12),
              // main info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name + mobile
                    Row(
                      children: [
                        Text(
                          _fullName(e),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          e['mobile'] ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // primary assignment summary
                    if (primary != null)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              primary['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            primary['location'] ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'No assignments',
                        style: TextStyle(color: Colors.black45),
                      ),
                    const SizedBox(height: 8),
                    // meta row
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Joined: ${_fmtDate(primary != null ? primary['joining_date'] : null)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (primary != null)
                          Text(
                            '${primary['commission_rate'] ?? '0.00'} • ${primary['commission_type'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // interactive trailing leads badge - CALLS the parent callback properly
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      // call the callback passed from parent to open leads
                      await widget.onViewLeads(widget.employee);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.leaderboard,
                            size: 16,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$totalLeads leads',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
