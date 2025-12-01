// users/views/main_pages/assigned/assigned_jobs_page.dart
// Adapted: choose API based on user's job_type and use session user_id as employee_id
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';
import 'package:jobshub/users/views/main_pages/assigned_job/leads.dart';

class AssignedJobsPage extends StatefulWidget {
  const AssignedJobsPage({super.key});

  @override
  State<AssignedJobsPage> createState() => _AssignedJobsPageState();
}

class _AssignedJobsPageState extends State<AssignedJobsPage> {
  bool _loading = false;
  String? _error;
  List<Map<String, dynamic>> _items = []; // normalized assigned items
  String _profileJobType = '';

  @override
  void initState() {
    super.initState();
    _loadAndFetch();
  }

  Future<void> _loadAndFetch() async {
    setState(() {
      _loading = true;
      _error = null;
      _items = [];
    });

    try {
      final storedJobType = await SessionManager.getValue('job_type') ?? '';
      final normalized = _normalizeJobType(storedJobType.toString());
      setState(() => _profileJobType = normalized);

      await _fetchAssignedForEmployee();
    } catch (e, st) {
      if (kDebugMode) print('❌ init error: $e\n$st');
      setState(() {
        _error = 'Failed to initialize: $e';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refresh() async {
    await _fetchAssignedForEmployee();
  }

  String _normalizeJobType(String raw) {
    final s = raw.toString().trim();
    final low = s.toLowerCase();
    if (low.contains('commission') || low.contains('commision'))
      return 'commission';
    if (low.contains('one') ||
        low.contains('one-time') ||
        low.contains('onetime') ||
        low.contains('one time'))
      return 'one-time';
    if (low.contains('project') ||
        low.contains('projects') ||
        low.contains('freelance') ||
        low.contains('it'))
      return 'project';
    if (low.contains('salary')) return 'salary';
    return s;
  }

  Future<void> _fetchAssignedForEmployee() async {
    setState(() {
      _loading = true;
      _error = null;
      _items = [];
    });

    try {
      final rawUser = await SessionManager.getValue('user_id') ?? '';
      final employeeId = rawUser?.toString() ?? '';
      if (employeeId.isEmpty) {
        setState(() {
          _error = 'Not logged in';
          _items = [];
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to see assigned jobs')),
          );
        }
        return;
      }

      final jt = _profileJobType.toLowerCase();
      String endpoint;
      if (jt.contains('commission')) {
        endpoint = 'commissionJobsByEmployee';
      } else if (jt.contains('one') ||
          jt.contains('one-time') ||
          jt.contains('onetime')) {
        endpoint = 'oneTimeJobsByEmployee';
      } else if (jt.contains('project')) {
        endpoint = 'projectsByEmployee';
      } else {
        endpoint = 'salaryJobsByEmployee';
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final body = {'employee_id': int.tryParse(employeeId) ?? employeeId};

      if (kDebugMode) {
        print('🔁 Assigned -> endpoint: $endpoint');
        print('🔁 URL: $uri');
        print('🔁 Body: ${jsonEncode(body)}');
      }

      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (kDebugMode) {
        print('⬅️ status: ${res.statusCode}');
        print('⬅️ body: ${res.body}');
      }

      if (res.statusCode < 200 || res.statusCode >= 300) {
        setState(() => _error = 'Server returned ${res.statusCode}');
        return;
      }

      final decoded = jsonDecode(res.body);
      final successFlag =
          (decoded is Map &&
          ((decoded['success'] == true) || (decoded['status'] == 1)));

      if (!successFlag) {
        setState(() {
          _items = [];
          _error = decoded is Map
              ? (decoded['message']?.toString() ?? 'API error')
              : 'Unexpected response';
        });
        return;
      }

      final List<dynamic> data = (decoded['data'] as List?) ?? [];

      // Normalize varied response shapes into a consistent map we can display
      final normalized = data.map<Map<String, dynamic>>((raw) {
        if (raw is! Map) return <String, dynamic>{'raw': raw};
        final map = Map<String, dynamic>.from(raw);

        // Several response variants exist: salary jobs, commission, one-time, projects
        // We'll extract common display fields where present.
        String id =
            (map['job_id'] ??
                    map['project_id'] ??
                    map['assigned_job_id'] ??
                    map['assigned_project_id'] ??
                    map['assignment_id'] ??
                    '')
                .toString();
        String title = (map['title'] ?? '').toString();
        String location = (map['location'] ?? '').toString();
        String jobType = map['job_type']?.toString() ?? '';
        // salary/payment/budget fields
        String salaryMin = map['salary_min']?.toString() ?? '';
        String salaryMax = map['salary_max']?.toString() ?? '';
        String salaryType = map['salary_type']?.toString() ?? '';
        String paymentAmount = map['payment_amount']?.toString() ?? '';
        String budgetMin = map['budget_min']?.toString() ?? '';
        String budgetMax = map['budget_max']?.toString() ?? '';

        // Compose a sensible displaySalary
        String displaySalary = '';
        if (salaryMin.isNotEmpty || salaryMax.isNotEmpty) {
          displaySalary = (salaryMin == salaryMax || salaryMax.isEmpty)
              ? '₹$salaryMin / ${salaryType.isNotEmpty ? salaryType : 'period'}'
              : '₹$salaryMin - ₹$salaryMax / ${salaryType.isNotEmpty ? salaryType : 'period'}';
        } else if (paymentAmount.isNotEmpty) {
          displaySalary = '₹$paymentAmount';
        } else if (budgetMin.isNotEmpty || budgetMax.isNotEmpty) {
          displaySalary = '₹$budgetMin - ₹$budgetMax';
        } else {
          displaySalary = map['salary']?.toString() ?? '';
        }

        return <String, dynamic>{
          'id': id,
          'title': title.isNotEmpty
              ? title
              : (map['name']?.toString() ?? 'Untitled'),
          'location': location,
          'job_type': jobType,
          'display_salary': displaySalary,
          'raw': map,
        };
      }).toList();

      setState(() {
        _items = normalized;
        _error = null;
      });
    } catch (e, st) {
      if (kDebugMode) print('❌ fetch assigned error: $e\n$st');
      setState(() {
        _error = 'Failed to fetch assigned items: $e';
        _items = [];
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildEmpty() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Column(
            children: const [
              Icon(Icons.assignment_late, size: 68, color: Colors.grey),
              SizedBox(height: 12),
              Text('No assigned job', style: TextStyle(fontSize: 18)),
              SizedBox(height: 6),
              Text(
                'You have no active assigned job at the moment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final it = _items[index];
        final title = it['title']?.toString() ?? 'Untitled';
        final subtitleParts = <String>[];
        if ((it['job_type'] ?? '').toString().isNotEmpty)
          subtitleParts.add(it['job_type'].toString());
        if ((it['location'] ?? '').toString().isNotEmpty)
          subtitleParts.add(it['location'].toString());
        final subtitle = subtitleParts.join(' • ');
        final salary = (it['display_salary'] ?? '').toString();

        return Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            // onTap: () => _openDetail(it),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              subtitle.isNotEmpty ? subtitle : 'Assigned',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (salary.isNotEmpty)
                  Text(
                    salary,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                const SizedBox(height: 8),

                // 🔹 Only enable "View" for commission-based jobs
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Builder(
                      builder: (ctx) {
                        final jobTypeStr = (it['job_type'] ?? '')
                            .toString()
                            .toLowerCase();
                        final isCommissionJob =
                            _profileJobType.toLowerCase().contains(
                              'commission',
                            ) ||
                            jobTypeStr.contains('commission');

                        if (!isCommissionJob) {
                          // Placeholder for non-commission jobs
                          return const Text(
                            'View (N/A)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          );
                        }

                        return TextButton(
                          onPressed: () async {
                            // Get employee info from session
                            final rawUserId =
                                await SessionManager.getValue('user_id') ?? '';
                            final rawUserName =
                                await SessionManager.getValue('user_name') ??
                                '';

                            final employeeId =
                                int.tryParse(rawUserId.toString()) ?? 0;
                            final employeeName =
                                rawUserName.toString().isNotEmpty
                                ? rawUserName.toString()
                                : 'You';

                            // Try to resolve job id from normalized or raw map
                            final raw =
                                (it['raw'] ?? {}) as Map<String, dynamic>?;

                            final jobIdStr =
                                (it['id']?.toString().isNotEmpty == true
                                        ? it['id'].toString()
                                        : (raw?['job_id'] ??
                                              raw?['assigned_job_id'] ??
                                              raw?['project_id'] ??
                                              raw?['assigned_project_id'] ??
                                              ''))
                                    .toString();

                            final jobId = int.tryParse(jobIdStr) ?? 0;

                            if (jobId == 0 || employeeId == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Missing job or employee info to open leads',
                                  ),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CommissionLeadsPage(
                                  jobId: jobId,
                                  jobTitle: title,
                                  employeeId: employeeId,
                                  employeeName: employeeName, employerId: 66,
                                ),
                              ),
                            );
                          },
                          child: const Text('View'),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine whether to show mobile AppBar+Drawer.
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 1000; // show appbar on narrower screens

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      // show drawer for mobile; on wider screens you can place a persistent sidebar elsewhere
      drawer: isMobile ? const AppDrawer() : null,
      appBar: isMobile
          ? AppBar(
              backgroundColor: AppColors.primary,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Assigned Job',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _fetchAssignedForEmployee,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : _items.isEmpty
            ? _buildEmpty()
            : _buildList(),
      ),
    );
  }
}
