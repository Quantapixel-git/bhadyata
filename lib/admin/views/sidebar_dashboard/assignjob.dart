import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/constants/base_url.dart'; // 👈 for ApiConstants.baseUrl

class AdminAssignJobPage extends StatefulWidget {
  const AdminAssignJobPage({super.key});

  @override
  State<AdminAssignJobPage> createState() => _AdminAssignJobPageState();
}

class _AdminAssignJobPageState extends State<AdminAssignJobPage> {
  String _selectedFilter = 'Salary-based';

  bool _isLoading = false;
  String? _error;

  List<_JobItem> _jobs = [];

  // --- BASE + ENDPOINTS (same style as your HR pages) ---
  static const String _baseUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/';

  final String apiApprovedSalary = '${_baseUrl}SalaryBasedgetApprovedJobs';
  final String apiApprovedCommission = '${_baseUrl}getApprovedCommissionJobs';
  final String apiApprovedOneTime = '${_baseUrl}getApprovedOneTimeJobs';
  final String apiApprovedProjects = '${_baseUrl}getApprovedProjects';

  @override
  void initState() {
    super.initState();
    _loadJobsForFilter(_selectedFilter);
  }

  Future<void> _loadJobsForFilter(String filter) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _jobs = [];
    });

    try {
      final List<_JobItem> loaded = [];

      if (filter == 'Salary-based') {
        loaded.addAll(await _fetchFromApi(apiApprovedSalary, 'Salary-based'));
      } else if (filter == 'Commission-based') {
        loaded.addAll(
          await _fetchFromApi(apiApprovedCommission, 'Commission-based'),
        );
      } else if (filter == 'One-time') {
        loaded.addAll(await _safeFetchOptional(apiApprovedOneTime, 'One-time'));
      } else if (filter == 'Projects') {
        loaded.addAll(
          await _safeFetchOptional(apiApprovedProjects, 'Projects'),
        );
      }

      setState(() {
        _jobs = loaded;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<List<_JobItem>> _safeFetchOptional(
    String url,
    String jobTypeLabel,
  ) async {
    try {
      return await _fetchFromApi(url, jobTypeLabel);
    } catch (_) {
      return [];
    }
  }

  Future<List<_JobItem>> _fetchFromApi(String url, String jobTypeLabel) async {
    final res = await http.post(
      Uri.parse(url),
      headers: const {'Content-Type': 'application/json'},
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load $jobTypeLabel jobs (${res.statusCode})');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = List<Map<String, dynamic>>.from(json['data'] ?? []);

    return list.map((m) => _mapJob(m, jobTypeLabel)).toList();
  }

  _JobItem _mapJob(Map<String, dynamic> j, String jobTypeLabel) {
    final id = int.tryParse(j['id']?.toString() ?? '') ?? 0;
    final title = j['title']?.toString() ?? 'Untitled';
    final company =
        j['company_name']?.toString() ??
        j['employer_name']?.toString() ??
        'Unknown Company';
    final location = j['location']?.toString() ?? 'N/A';

    String salaryRange;
    if (j['salary_min'] != null || j['salary_max'] != null) {
      final min = j['salary_min']?.toString() ?? '-';
      final max = j['salary_max']?.toString() ?? '-';
      salaryRange = '₹$min - ₹$max';
    } else if (j['potential_earning'] != null) {
      salaryRange = 'Potential: ₹${j['potential_earning']}';
    } else if (j['amount'] != null) {
      salaryRange = '₹${j['amount']}';
    } else if (j['budget'] != null) {
      salaryRange = 'Budget: ₹${j['budget']}';
    } else {
      salaryRange = 'N/A';
    }

    final createdAt = j['created_at']?.toString() ?? '';

    return _JobItem(
      id: id,
      title: title,
      company: company,
      location: location,
      jobType: jobTypeLabel,
      salaryRange: salaryRange,
      createdAt: createdAt,
      status: 'Approved',
    );
  }

  // 👉 Open bottom sheet with ALL APPROVED USERS + search + confirm
  void _onAssign(_JobItem job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _AssignJobSheet(job: job);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminDashboardWrapper(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primary,
            title: const Text(
              'Assign Job',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildFilterBar(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _error != null
                        ? _ErrorBox(
                            message: _error!,
                            onRetry: () => _loadJobsForFilter(_selectedFilter),
                          )
                        : _jobs.isEmpty
                        ? const _EmptyJobsState()
                        : ListView.separated(
                            itemCount: _jobs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final job = _jobs[index];
                              return _JobCard(
                                job: job,
                                onAssign: () => _onAssign(job),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = [
      'Salary-based',
      'Commission-based',
      'One-time',
      'Projects',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final selected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                f,
                style: TextStyle(
                  fontSize: 13,
                  color: selected ? Colors.white : Colors.black87,
                ),
              ),
              selected: selected,
              selectedColor: AppColors.primary,
              onSelected: (_) {
                setState(() => _selectedFilter = f);
                _loadJobsForFilter(f);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// ---------- JOB MODEL ----------

class _JobItem {
  final int id;
  final String title;
  final String company;
  final String location;
  final String jobType; // Salary-based / One-time / Commission-based / Projects
  final String salaryRange;
  final String createdAt;
  final String status;

  _JobItem({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.jobType,
    required this.salaryRange,
    required this.createdAt,
    required this.status,
  });
}

/// ---------- JOB CARD ----------

class _JobCard extends StatelessWidget {
  final _JobItem job;
  final VoidCallback onAssign;

  const _JobCard({required this.job, required this.onAssign});

  Color _statusColor() {
    switch (job.status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'closed':
        return Colors.redAccent;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor().withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    job.status,
                    style: TextStyle(
                      fontSize: 11,
                      color: _statusColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              job.company,
              style: const TextStyle(
                fontSize: 13.5,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 15,
                  color: Colors.black54,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job.location,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _chip(icon: Icons.work_outline, label: job.jobType),
                _chip(icon: Icons.payments_outlined, label: job.salaryRange),
                _chip(
                  icon: Icons.calendar_month_outlined,
                  label: 'Posted: ${job.createdAt}',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                ),
                onPressed: onAssign,
                icon: const Icon(
                  Icons.assignment_turned_in_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text(
                  'Assign',
                  style: TextStyle(fontSize: 13.5, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _chip({required IconData icon, required String label}) {
    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }
}

/// ---------- EMPTY + ERROR WIDGETS ----------

class _EmptyJobsState extends StatelessWidget {
  const _EmptyJobsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.work_outline, size: 42, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          const Text(
            'No jobs available to assign.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 28,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =================================================================
///  BOTTOM SHEET: FETCH ALL APPROVED USERS + SEARCH + CONFIRM ASSIGN
/// =================================================================

class _AssignJobSheet extends StatefulWidget {
  final _JobItem job;

  const _AssignJobSheet({required this.job});

  @override
  State<_AssignJobSheet> createState() => _AssignJobSheetState();
}

class _AssignJobSheetState extends State<_AssignJobSheet> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _users = [];
  String _search = '';

  // NEW
  bool _assigning = false;
  String get _apiAllUsersApproved => "${ApiConstants.baseUrl}usersApproved";
  String get _apiAssignJob => "${ApiConstants.baseUrl}assignJobToEmployee";

  // map UI labels → backend job_type
  String _jobTypeSlug(String type) {
    switch (type) {
      case 'Salary-based':
        return 'salary';
      case 'Commission-based':
        return 'commission';
      case 'One-time':
        return 'one_time';
      case 'Projects':
        return 'project';
      default:
        return 'salary';
    }
  }

  // String get _apiAllUsersApproved => "${ApiConstants.baseUrl}usersApproved";

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _loading = true;
      _error = null;
      _users = [];
    });

    final url = _apiAllUsersApproved;
    final bodyMap = {"role": 1}; // 👈 same as EmployeeUsersPage (HR role)
    final bodyJson = jsonEncode(bodyMap);

    // 🔍 DEBUG PRINTS
    debugPrint('[_AssignJobSheet] Fetching approved users...');
    debugPrint('[_AssignJobSheet] URL: $url');
    debugPrint('[_AssignJobSheet] Request body: $bodyJson');

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: const {"Content-Type": "application/json"},
        body: bodyJson,
      );

      debugPrint('[_AssignJobSheet] Response status: ${res.statusCode}');
      debugPrint('[_AssignJobSheet] Response body: ${res.body}');

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final List data = (json['data'] as List?) ?? [];
        debugPrint('[_AssignJobSheet] Parsed users count: ${data.length}');

        setState(() {
          _users = data.cast<Map<String, dynamic>>();
        });
      } else {
        setState(() {
          _error = "Error ${res.statusCode}";
        });
      }
    } catch (e, st) {
      debugPrint('[_AssignJobSheet] Exception while fetching users: $e');
      debugPrint('[_AssignJobSheet] Stacktrace: $st');
      setState(() {
        _error = "Network error: $e";
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  List<Map<String, dynamic>> get _filteredUsers {
    if (_search.trim().isEmpty) return _users;
    final q = _search.toLowerCase();
    return _users.where((u) {
      final first = (u['first_name'] ?? '').toString().toLowerCase();
      final last = (u['last_name'] ?? '').toString().toLowerCase();
      final mobile = (u['mobile'] ?? '').toString().toLowerCase();
      final email = (u['email'] ?? '').toString().toLowerCase();
      final name = ('$first $last').trim();
      return name.contains(q) || mobile.contains(q) || email.contains(q);
    }).toList();
  }

  String _fullName(Map<String, dynamic> u) {
    final f = (u['first_name'] ?? '').toString().trim();
    final l = (u['last_name'] ?? '').toString().trim();
    if (f.isEmpty && l.isEmpty) return '—';
    return [f, l].where((e) => e.isNotEmpty).join(' ');
  }

  Future<void> _confirmAssign(Map<String, dynamic> user) async {
    final userId = int.tryParse(user['id']?.toString() ?? '');
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid user id')));
      return;
    }

    final jobTypeSlug = _jobTypeSlug(widget.job.jobType);

    final body = {
      "job_id": widget.job.id,
      "employee_id": userId,
      "job_type": jobTypeSlug,
      "remarks": "Assigned from app",
    };

    debugPrint('[_AssignJobSheet] Assign URL: $_apiAssignJob');
    debugPrint('[_AssignJobSheet] Assign BODY: ${jsonEncode(body)}');

    setState(() => _assigning = true);

    try {
      final res = await http.post(
        Uri.parse(_apiAssignJob),
        headers: const {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      debugPrint('[_AssignJobSheet] Assign STATUS: ${res.statusCode}');
      debugPrint('[_AssignJobSheet] Assign RESPONSE: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        final jsonRes = jsonDecode(res.body) as Map<String, dynamic>;
        final msg = (jsonRes['message'] ?? 'Employee assigned successfully')
            .toString();

        Navigator.pop(context); // close bottom sheet

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(behavior: SnackBarBehavior.floating, content: Text(msg)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Assign failed (${res.statusCode})'),
          ),
        );
      }
    } catch (e) {
      debugPrint('[_AssignJobSheet] Assign EXCEPTION: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Network error: $e'),
        ),
      );
    } finally {
      if (mounted) setState(() => _assigning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
        child: SizedBox(
          height: media.size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assign Job',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.job.title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.job.company,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search user by name, mobile, email',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (v) {
                        setState(() {
                          _search = v;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: _fetchUsers,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _filteredUsers.isEmpty
                    ? const Center(child: Text('No users found'))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final u = _filteredUsers[index];
                          final name = _fullName(u);
                          final mobile = (u['mobile'] ?? '').toString();
                          final email = (u['email'] ?? '').toString();
                          final img = (u['profile_image'] ?? '').toString();

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.1,
                                ),
                                foregroundImage:
                                    img.isNotEmpty && img.startsWith('http')
                                    ? NetworkImage(img)
                                    : null,
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                ),
                              ),
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (mobile.isNotEmpty)
                                    Text('Mobile: $mobile'),
                                  if (email.isNotEmpty) Text('Email: $email'),
                                ],
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                ),
                                onPressed: _assigning
                                    ? null
                                    : () => _confirmAssign(u),
                                child: _assigning
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Text(
                                        'Confirm',
                                        style: TextStyle(fontSize: 12, color: Colors.white),
                                      ),
                              ),
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
  }
}
