import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';
import 'package:jobshub/hr/views/attendance/hr_employee_attendance_detail_page.dart';

const String kApiBase = 'https://dialfirst.in/quantapixel/badhyata/api/';

class EmployeesAttendancePage extends StatefulWidget {
  const EmployeesAttendancePage({super.key});

  @override
  State<EmployeesAttendancePage> createState() =>
      _EmployeesAttendancePageState();
}

class _EmployeesAttendancePageState extends State<EmployeesAttendancePage> {
  bool _loading = false;
  String? _error;
  final int _perPage = 20;
  int _currentPage = 1;
  int _total = 0;
  final List<JobEmployeeItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetch(page: 1);
  }

  Future<void> _fetch({int page = 1}) async {
    setState(() {
      _loading = true;
      _error = null;
      if (page == 1) _items.clear();
    });

    try {
      final uri = Uri.parse('${kApiBase}salaryJobEmployees').replace(
        queryParameters: {
          'per_page': _perPage.toString(),
          'page': page.toString(),
        },
      );

      final res = await http.post(
        uri,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: '', // API expects POST with empty body
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final Map<String, dynamic> jsonMap = jsonDecode(res.body);
        final dataList = (jsonMap['data'] as List?) ?? [];
        final parsed = dataList
            .map((e) => JobEmployeeItem.fromJson(e as Map<String, dynamic>))
            .toList();

        setState(() {
          _items.addAll(parsed);
          _total = (jsonMap['total'] ?? 0) as int;
          _currentPage = (jsonMap['current_page'] ?? page) as int;
        });
      } else {
        setState(() {
          _error =
              'Failed (${res.statusCode}). ${res.reasonPhrase ?? 'Unknown error'}';
        });
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onRefresh() => _fetch(page: 1);

  void _loadMoreIfNeeded(int index) {
    final haveMore = _items.length < _total;
    if (!haveMore || _loading) return;
    if (index >= _items.length - 4) {
      _fetch(page: _currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return HrDashboardWrapper(
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Employees Attendance",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
                actions: [
                  IconButton(
                    tooltip: 'Refresh',
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () => _fetch(page: 1),
                  ),
                ],
              ),

              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.all(12),
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: _loading && _items.isEmpty
                        ? const _SkeletonList()
                        : _error != null
                        ? _ErrorBox(
                            message: _error!,
                            onRetry: () => _fetch(page: 1),
                          )
                        : _items.isEmpty
                        ? const _EmptyState()
                        : ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              _loadMoreIfNeeded(index);
                              final r = _items[index];
                              final fullName =
                                  '${r.employee.firstName} ${r.employee.lastName}'
                                      .trim();
                              final employerName =
                                  '${r.employerFirstName ?? ''} ${r.employerLastName ?? ''}'
                                      .trim();

                              return Card(
                                elevation: 2.5,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          _AvatarInitials(
                                            name: fullName.isEmpty
                                                ? '—'
                                                : fullName,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  fullName.isEmpty
                                                      ? 'Employee'
                                                      : fullName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  r.jobTitle ?? '—',
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 12.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          OutlinedButton.icon(
                                            onPressed: () {
                                              final now =
                                                  DateTime.now(); // current year & month
                                              final fullName =
                                                  '${r.employee.firstName ?? ''} ${r.employee.lastName ?? ''}'
                                                      .trim();

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => HrEmployeeAttendanceDetailPage(
                                                    jobEmployeeId: r
                                                        .jobEmployeeId, // ✅ send JE id
                                                    initialYear: now
                                                        .year, // ✅ send current year
                                                    initialMonth: now
                                                        .month, // ✅ send current month
                                                    employeeName:
                                                        fullName.isEmpty
                                                        ? null
                                                        : fullName,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.remove_red_eye,
                                              size: 18,
                                            ),
                                            label: const Text('View'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      // meta row
                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 8,
                                        children: [
                                          _ChipStat(
                                            label: 'Job ID',
                                            value: '${r.jobId}',
                                          ),
                                          _ChipStat(
                                            label: 'JE ID',
                                            value: '${r.jobEmployeeId}',
                                          ),
                                          _ChipStat(
                                            label: 'Joining',
                                            value: r.joiningDate != null
                                                ? r.joiningDate!.toString()
                                                : '-',
                                          ),
                                          _ChipStat(
                                            label: 'Status',
                                            value: r.status ?? '-',
                                          ),
                                          _ChipStat(
                                            label: 'Employer',
                                            value: employerName.isEmpty
                                                ? '—'
                                                : employerName,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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

/* ===== Models ===== */

class JobEmployeeItem {
  final int jobEmployeeId;
  final int jobId;
  final int employeeId;
  final DateTime? joiningDate;
  final String? status;
  final int? terminate;
  final String? remarks;
  final String? jobTitle;
  final int? employerId;
  final String? employerFirstName;
  final String? employerLastName;
  final EmployeeMini employee;

  JobEmployeeItem({
    required this.jobEmployeeId,
    required this.jobId,
    required this.employeeId,
    required this.employee,
    this.joiningDate,
    this.status,
    this.terminate,
    this.remarks,
    this.jobTitle,
    this.employerId,
    this.employerFirstName,
    this.employerLastName,
  });

  factory JobEmployeeItem.fromJson(Map<String, dynamic> j) {
    DateTime? jd;
    final raw = j['joining_date'];
    if (raw != null && raw.toString().isNotEmpty) {
      // API returns "YYYY-MM-DD HH:mm:ss"
      jd = DateTime.tryParse(raw.toString().replaceFirst(' ', 'T'));
    }
    final employer = (j['employer'] as Map?) ?? {};
    final job = (j['job'] as Map?) ?? {};
    final emp = (j['employee'] as Map?) ?? {};

    return JobEmployeeItem(
      jobEmployeeId: (j['job_employee_id'] as num).toInt(),
      jobId: (j['job_id'] as num).toInt(),
      employeeId: (j['employee_id'] as num).toInt(),
      joiningDate: jd,
      status: j['status']?.toString(),
      terminate: (j['terminate'] as num?)?.toInt(),
      remarks: j['remarks']?.toString(),
      jobTitle: job['title']?.toString(),
      employerId: (job['employer_id'] as num?)?.toInt(),
      employerFirstName: employer['first_name']?.toString(),
      employerLastName: employer['last_name']?.toString(),
      employee: EmployeeMini.fromJson(emp.cast<String, dynamic>()),
    );
  }
}

class EmployeeMini {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImage;

  EmployeeMini({this.firstName, this.lastName, this.email, this.profileImage});

  factory EmployeeMini.fromJson(Map<String, dynamic> j) => EmployeeMini(
    firstName: j['first_name']?.toString(),
    lastName: j['last_name']?.toString(),
    email: j['email']?.toString(),
    profileImage: j['profile_image']?.toString(),
  );
}

/* ===== UI helpers ===== */

class _AvatarInitials extends StatelessWidget {
  final String name;
  const _AvatarInitials({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase())
        .take(2)
        .join();
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.primary.withOpacity(0.12),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ChipStat extends StatelessWidget {
  final String label;
  final String value;
  const _ChipStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    Widget box({double h = 14, double w = 120}) => Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          box(w: 160),
                          const SizedBox(height: 8),
                          box(w: 120, h: 12),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    box(w: 70, h: 30),
                  ],
                ),
                const SizedBox(height: 12),
                box(w: double.infinity),
                const SizedBox(height: 8),
                box(w: double.infinity),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 42, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          const Text(
            'No job employees found.',
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
