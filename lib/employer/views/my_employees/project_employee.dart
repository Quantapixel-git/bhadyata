import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class ProjectEmployeesPage extends StatefulWidget {
  const ProjectEmployeesPage({super.key});

  @override
  State<ProjectEmployeesPage> createState() => _ProjectEmployeesPageState();
}

class _ProjectEmployeesPageState extends State<ProjectEmployeesPage> {
  bool _loading = true;
  bool _error = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _employees = [];

  // Use same API base you used elsewhere
  final String apiBase = 'https://dialfirst.in/quantapixel/badhyata/api';

  // UI state
  bool _includeTerminated = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    setState(() {
      _loading = true;
      _error = false;
      _errorMessage = null;
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
          _loading = false;
        });
        return;
      }

      final uri = Uri.parse('$apiBase/projectEmployeesByEmployer');
      final body = jsonEncode({
        'employer_id': employerId,
        'include_terminated': _includeTerminated,
      });

      final resp = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      if (resp.statusCode != 200) {
        throw Exception(
          'Server returned ${resp.statusCode}: ${resp.body.length > 200 ? resp.body.substring(0, 200) : resp.body}',
        );
      }

      final Map<String, dynamic> j = jsonDecode(resp.body);
      if (j['success'] != true) {
        throw Exception(j['message'] ?? 'API returned failure');
      }

      final List<dynamic> data = j['data'] ?? [];
      final List<Map<String, dynamic>> mapped =
          data.map<Map<String, dynamic>>((item) {
        final assignments = (item['assignments'] as List<dynamic>? ?? [])
            .map<Map<String, dynamic>>((a) {
          return {
            'assignment_id': a['assignment_id'],
            'project_id': a['project_id'],
            'title': a['title'],
            'category': a['category'],
            'location': a['location'],
            'budget_min': a['budget_min'],
            'budget_max': a['budget_max'],
            'budget_type': a['budget_type'],
            'joining_date': a['joining_date'],
            'employment_status': a['employment_status'],
            'terminate': a['terminate'],
          };
        }).toList();

        return {
          'employee_id': item['employee_id'],
          'first_name': item['first_name'],
          'last_name': item['last_name'],
          'mobile': item['mobile'],
          'email': item['email'],
          'assignments': assignments,
        };
      }).toList();

      setState(() {
        _employees = mapped;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = true;
        _errorMessage = e.toString();
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

  List<Map<String, dynamic>> get _filteredEmployees {
    if (_search.trim().isEmpty) return _employees;
    final q = _search.toLowerCase();
    return _employees.where((e) {
      final name = _fullName(e).toLowerCase();
      final email = (e['email'] ?? '').toString().toLowerCase();
      final mobile = (e['mobile'] ?? '').toString().toLowerCase();
      return name.contains(q) || email.contains(q) || mobile.contains(q);
    }).toList();
  }

  // format date short
  String _fmtDate(String? raw) {
    if (raw == null) return '';
    return raw.length >= 16 ? raw.substring(0, 16) : raw;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isWeb = constraints.maxWidth >= 900;
      final filtered = _filteredEmployees;

      return EmployerDashboardWrapper(
        child: Column(
          children: [
            AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              automaticallyImplyLeading: !isWeb,
              title: const Text(
                "Project Employees",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: AppColors.primary,
              elevation: 2,
              actions: [
                // refresh + optional toggle later
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _fetchEmployees,
                ),
                const SizedBox(width: 8),
              ],
            ),

            // remove top padding so first card sits directly under AppBar (keeps your wrapper)
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
                  child: _buildBody(isWeb, filtered),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBody(bool isWeb, List<Map<String, dynamic>> filtered) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Error: ${_errorMessage ?? 'Unknown'}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchEmployees,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (filtered.isEmpty) {
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
        itemCount: filtered.length,
        itemBuilder: (context, idx) {
          final e = filtered[idx];
          return _ProjectEmployeeCard(employee: e);
        },
      );
    } else {
      return ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, idx) {
          final e = filtered[idx];
          return _ProjectEmployeeCard(employee: e);
        },
      );
    }
  }
}

/// Card for project employee — shows budget fields and status
class _ProjectEmployeeCard extends StatefulWidget {
  final Map<String, dynamic> employee;
  const _ProjectEmployeeCard({required this.employee});

  @override
  State<_ProjectEmployeeCard> createState() => _ProjectEmployeeCardState();
}

class _ProjectEmployeeCardState extends State<_ProjectEmployeeCard> {
  bool _expanded = false;

  String _fullName(Map<String, dynamic> e) {
    final fn = (e['first_name'] ?? '').toString();
    final ln = (e['last_name'] ?? '').toString();
    final name = '$fn ${ln}'.trim();
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
    final assignments = (e['assignments'] as List<dynamic>? ?? []);
    final primary =
        assignments.isNotEmpty ? assignments[0] as Map<String, dynamic> : null;

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
              CircleAvatar(
                radius: 28,
                child: Text(
                  (_fullName(e)
                          .split(' ')
                          .map((s) => s.isEmpty ? '' : s[0])
                          .take(2)
                          .join())
                      .toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),

              // main info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name + mobile
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            _fullName(e),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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

                    // primary assignment summary (project specific)
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

                    // meta row (join date + budget)
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
                        '${primary['budget_min'] ?? '0.00'} - ${primary['budget_max'] ?? '0.00'} • ${primary['budget_type'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),

                    if (_expanded) ...[
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Email: ${e['email'] ?? ''}',
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Assignments:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      ...assignments.map<Widget>((a) {
                        final Map<String, dynamic> asg = a as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(top: 6, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      asg['title'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${asg['location'] ?? ''} • ${asg['category'] ?? ''}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Joined: ${_fmtDate(asg['joining_date'])} • Budget: ${asg['budget_min'] ?? '0.00'} - ${asg['budget_max'] ?? '0.00'}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Status: ${asg['employment_status'] ?? ''} • Terminate: ${asg['terminate'] ?? ''}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 10),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
