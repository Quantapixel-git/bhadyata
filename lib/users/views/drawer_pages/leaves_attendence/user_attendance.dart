// user_attendance.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  const EmployeeAttendanceScreen({super.key});

  @override
  State<EmployeeAttendanceScreen> createState() =>
      _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen> {
  bool _loading = false;
  String? _error;

  // user and job state
  String? _userId;
  List<Map<String, dynamic>> _jobs = [];
  int? _selectedJobId; // assigned job id (job_id)
  int?
  _selectedJobEmployeeId; // job_employee_id if present (employee_record_id)
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;

  // attendance response state
  EmployeeAttendanceResponse? _resp;

  static const _perPage = 31;
  static const _page = 1;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    _userId = await SessionManager.getValue('user_id');
    debugPrint('[DEBUG] EmployeeAttendance init userId=$_userId');

    if (_userId == null) {
      setState(() {
        _loading = false;
        _error = 'User not logged in';
      });
      return;
    }

    await _fetchJobsAndAttendance();
  }

  Future<void> _fetchJobsAndAttendance() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 1) fetch salary jobs for this employee
      final uriJobs = Uri.parse('${ApiConstants.baseUrl}salaryJobsByEmployee');
      final respJobs = await http.post(
        uriJobs,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'employee_id': int.parse(_userId!)}),
      );

      debugPrint(
        '[DEBUG] salaryJobsByEmployee status=${respJobs.statusCode} body=${respJobs.body}',
      );

      if (respJobs.statusCode != 200) {
        setState(() {
          _error = 'Failed to fetch jobs (${respJobs.statusCode})';
          _loading = false;
        });
        return;
      }

      final bodyJobs = jsonDecode(respJobs.body);
      if (bodyJobs is Map && bodyJobs['success'] == true) {
        final List data = bodyJobs['data'] ?? [];
        _jobs = data
            .where((e) => e is Map)
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();

        debugPrint('[DEBUG] jobs count=${_jobs.length}');

        if (_jobs.isNotEmpty) {
          final first = _jobs.first;
          _selectedJobId = _toInt(first['job_id']);
          _selectedJobEmployeeId = _toInt(
            first['job_employee_id'] ??
                first['employee_record_id'] ??
                first['employee_id'],
          );
        }
      } else {
        debugPrint('[DEBUG] salaryJobsByEmployee returned success!=true');
        _jobs = [];
      }

      // 2) fetch attendance for selected job (if any)
      if (_selectedJobId != null) {
        await _fetchAttendance();
      } else {
        setState(() {
          _resp = null;
          _loading = false;
        });
      }
    } catch (e, st) {
      debugPrint('[ERROR] _fetchJobsAndAttendance exception: $e\n$st');
      setState(() {
        _error = 'Exception: $e';
        _loading = false;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _fetchAttendance() async {
    if (_userId == null || _selectedJobId == null) return;

    setState(() {
      _loading = true;
      _error = null;
      _resp = null;
    });

    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}attendanceByEmployeeMonthly',
      );
      final body = jsonEncode({
        'employee_id': int.parse(_userId!),
        'job_id': _selectedJobId,
        'year': _year, // ← add this
        'month': _month, // ← and this
        // optionally: 'per_page': _perPage, 'page': _page,
      });

      debugPrint('[DEBUG] attendanceEmployee POST $uri body=$body');

      final res = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      debugPrint(
        '[DEBUG] attendanceEmployee status=${res.statusCode} body=${res.body}',
      );

      if (res.statusCode < 200 || res.statusCode >= 300) {
        setState(() {
          _error = 'Failed (${res.statusCode})';
          _loading = false;
        });
        return;
      }

      final raw = jsonDecode(res.body);
      if (raw is! Map) {
        setState(() {
          _error = 'Unexpected response format';
          _loading = false;
        });
        return;
      }

      // Convert to Map<String, dynamic> (fixes the type error)
      final map = Map<String, dynamic>.from(raw as Map);

      // previous checks
      if (map['success'] != true) {
        setState(() {
          _error = map['message']?.toString() ?? 'Failed to fetch attendance';
          _loading = false;
        });
        return;
      }

      // parse
      final parsed = EmployeeAttendanceResponse.fromJson(map);
      debugPrint(
        '[DEBUG] attendance parsed: rows=${parsed.data.length}, present=${parsed.summary.present}',
      );

      // <- IMPORTANT: actually parse and assign
      // final parsed = EmployeeAttendanceResponse.fromJson(map);
      debugPrint(
        '[DEBUG] attendance parsed: rows=${parsed.data.length}, present=${parsed.summary.present}',
      );

      // use range to update local month/year if provided
      if (parsed.range != null) {
        try {
          final from = DateTime.parse(parsed.range!.from);
          _year = from.year;
          _month = from.month;
        } catch (_) {}
      }

      setState(() {
        _resp = parsed;
        _error = null;
      });
    } catch (e, st) {
      debugPrint('[ERROR] _fetchAttendance exception: $e\n$st');
      setState(() {
        _error = 'Exception while fetching attendance: $e';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  // Month navigation helpers - these use the remote response's prev/next if available
  void _goPrev() async {
    if (_resp?.prevMonth != null) {
      _year = _resp!.prevMonth!.year;
      _month = _resp!.prevMonth!.month;
    } else {
      final prev = DateTime(_year, _month - 1, 1);
      _year = prev.year;
      _month = prev.month;
    }
    await _fetchAttendance();
  }

  void _goNext() async {
    if (_resp?.nextMonth != null) {
      _year = _resp!.nextMonth!.year;
      _month = _resp!.nextMonth!.month;
    } else {
      final next = DateTime(_year, _month + 1, 1);
      _year = next.year;
      _month = next.month;
    }
    await _fetchAttendance();
  }

  // status mapping
  _StatusView _mapStatus(int? raw) {
    switch (raw) {
      case 1:
        return const _StatusView('present', 'Present', Icons.check_circle);
      case 2:
        return const _StatusView('absent', 'Absent', Icons.cancel);
      case 3:
        return const _StatusView('leave', 'On Leave', Icons.beach_access);
      case 4:
        return const _StatusView('holiday', 'Holiday', Icons.celebration);
      case 5:
        return const _StatusView('weekoff', 'Weekly Off', Icons.weekend);
      case 0:
      default:
        return const _StatusView('unmarked', 'Unmarked', Icons.help_outline);
    }
  }

  Color _statusColor(String key) {
    switch (key) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'leave':
        return Colors.orange;
      case 'holiday':
        return Colors.teal;
      case 'weekoff':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String key) => _mapStatusIcon[key] ?? Icons.help_outline;
  final Map<String, IconData> _mapStatusIcon = const {
    'present': Icons.check_circle,
    'absent': Icons.cancel,
    'leave': Icons.beach_access,
    'holiday': Icons.celebration,
    'weekoff': Icons.weekend,
    'unmarked': Icons.help_outline,
  };

  String _monthName(int m) {
    const names = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    if (m < 1 || m > 12) return 'Month';
    return names[m];
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel = _monthName(_month);

    return AppDrawerWrapper(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'My Attendance',
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
                onPressed: () async {
                  await _fetchJobsAndAttendance();
                },
              ),
            ],
          ),

          // Top card with job selector and small info
          Material(
            color: Colors.white,
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Jobs',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _buildJobSelectorRow(),
                ],
              ),
            ),
          ),

          // Month switcher (same visual as HR page)
          Material(
            color: Colors.white,
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Previous month',
                    onPressed: (_resp == null && !_loading) ? null : _goPrev,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$monthLabel $_year',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (_resp?.range != null)
                          Text(
                            '${_resp!.range!.from} → ${_resp!.range!.to}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Next month',
                    onPressed: (_resp == null && !_loading) ? null : _goNext,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ),

          // Body
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _fetchAttendance();
              },
              child: _loading && _resp == null
                  ? const _LoadingSkeleton()
                  : _error != null
                  ? _ErrorBox(message: _error!, onRetry: _fetchAttendance)
                  : _resp == null
                  ? const _EmptyState()
                  : ListView(
                      padding: const EdgeInsets.all(12),
                      children: [
                        // summary chips
                        _SummaryChips(summary: _resp!.summary),
                        const SizedBox(height: 12),

                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _resp!.data.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Center(
                                    child: Text(
                                      'No attendance data found for the selected job.',
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _resp!.data.length,
                                  separatorBuilder: (_, __) => Divider(
                                    height: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                  itemBuilder: (_, i) {
                                    final d = _resp!.data[i];
                                    final status = _mapStatus(d.status);
                                    final color = _statusColor(status.key);
                                    final icon = _statusIcon(status.key);

                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: color.withOpacity(
                                          0.12,
                                        ),
                                        child: Icon(icon, color: color),
                                      ),
                                      title: Text(
                                        d.attendDate,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        status.label,
                                        style: const TextStyle(fontSize: 12.5),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text('In: ${d.checkIn ?? '—'}'),
                                          Text('Out: ${d.checkOut ?? '—'}'),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobSelectorRow() {
    if (_jobs.isEmpty) {
      return const Text('No salary-based jobs assigned to you.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<int>(
          value: _selectedJobId,
          decoration: const InputDecoration(labelText: 'Select Job'),
          items: _jobs.map<DropdownMenuItem<int>>((j) {
            final id = _toInt(j['job_id']);
            final title = (j['title'] ?? 'Untitled').toString();
            return DropdownMenuItem<int>(value: id, child: Text(title));
          }).toList(),
          onChanged: (v) async {
            setState(() {
              _selectedJobId = v;
              _resp = null;
              _loading = true;
            });
            await _fetchAttendance();
          },
        ),
        const SizedBox(height: 8),
        if (_selectedJobId != null)
          Builder(
            builder: (_) {
              final match = _jobs.firstWhere(
                (j) => _toInt(j['job_id']) == _selectedJobId,
                orElse: () => {},
              );
              if (match.isEmpty) return const SizedBox();
              final jobTitle = (match['title'] ?? '').toString();
              final joined = match['joining_date']?.toString() ?? '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobTitle,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (joined.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Joined: $joined',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

/* ===== Response Models (lightweight) ===== */

class EmployeeAttendanceResponse {
  final bool success;
  final String? message;
  final int employeeId;
  final DateRange? range;
  final YearMonth? prevMonth; // remote prev_month -> YearMonth
  final YearMonth? nextMonth; // remote next_month -> YearMonth
  final Summary summary;
  final int assignedJobsCount;
  final List<AssignedJob> assignedJobs;
  final int attendanceGroupsCount;
  final List<AttendanceGroup> attendanceGroups;
  final Pagination pagination;

  /// Flattened list of attendance rows for the selected job (we will produce this from groups)
  final List<AttendanceRow> data;

  EmployeeAttendanceResponse({
    required this.success,
    required this.employeeId,
    required this.summary,
    required this.assignedJobsCount,
    required this.assignedJobs,
    required this.attendanceGroupsCount,
    required this.attendanceGroups,
    required this.pagination,
    required this.data,
    this.message,
    this.range,
    this.prevMonth,
    this.nextMonth,
  });

  factory EmployeeAttendanceResponse.fromJson(Map<String, dynamic> j) {
    final summary = Summary.fromJson(
      (j['summary'] ?? {}) as Map<String, dynamic>,
    );
    final assigned = (j['assigned_jobs'] as List? ?? [])
        .map((e) => AssignedJob.fromJson(e as Map<String, dynamic>))
        .toList();
    final groups = (j['attendance_groups'] as List? ?? [])
        .map((e) => AttendanceGroup.fromJson(e as Map<String, dynamic>))
        .toList();

    // We'll pick rows from the groups if present, otherwise gather any top-level 'data' array
    List<AttendanceRow> rows = [];
    if (groups.isNotEmpty) {
      rows = groups.expand((g) => g.attendance).toList();
    } else {
      final dataRows = (j['data'] as List? ?? []);
      rows = dataRows
          .map<AttendanceRow>(
            (e) => AttendanceRow.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    }

    rows.sort((a, b) => a.attendDate.compareTo(b.attendDate));

    // parse prev_month / next_month (if present)
    YearMonth? pm;
    YearMonth? nm;
    if (j['prev_month'] is Map) {
      pm = YearMonth.fromJson(j['prev_month'] as Map<String, dynamic>);
    }
    if (j['next_month'] is Map) {
      nm = YearMonth.fromJson(j['next_month'] as Map<String, dynamic>);
    }

    return EmployeeAttendanceResponse(
      success: j['success'] == true,
      message: j['message']?.toString(),
      employeeId: (j['employee_id'] as num?)?.toInt() ?? 0,
      range: j['range'] == null
          ? null
          : DateRange.fromJson(j['range'] as Map<String, dynamic>),
      prevMonth: pm,
      nextMonth: nm,
      summary: summary,
      assignedJobsCount:
          (j['assigned_jobs_count'] as num?)?.toInt() ?? assigned.length,
      assignedJobs: assigned,
      attendanceGroupsCount:
          (j['attendance_groups_count'] as num?)?.toInt() ?? groups.length,
      attendanceGroups: groups,
      pagination: Pagination.fromJson(
        j['pagination'] as Map<String, dynamic>? ?? {},
      ),
      data: rows,
    );
  }
}

/* ===== Shared Models (use these once only) ===== */

class DateRange {
  final String from;
  final String to;
  DateRange({required this.from, required this.to});
  factory DateRange.fromJson(Map<String, dynamic> j) =>
      DateRange(from: j['from'].toString(), to: j['to'].toString());
}

class YearMonth {
  final int year;
  final int month;
  YearMonth({required this.year, required this.month});
  factory YearMonth.fromJson(Map<String, dynamic> j) => YearMonth(
    year: (j['year'] as num?)?.toInt() ?? 0,
    month: (j['month'] as num?)?.toInt() ?? 0,
  );
}

class Summary {
  final int unmarked;
  final int present;
  final int absent;
  final int leave;
  final int holiday;
  final int weekoff;

  Summary({
    required this.unmarked,
    required this.present,
    required this.absent,
    required this.leave,
    required this.holiday,
    required this.weekoff,
  });

  factory Summary.fromJson(Map<String, dynamic> j) => Summary(
    unmarked: (j['unmarked'] as num?)?.toInt() ?? 0,
    present: (j['present'] as num?)?.toInt() ?? 0,
    absent: (j['absent'] as num?)?.toInt() ?? 0,
    leave: (j['leave'] as num?)?.toInt() ?? 0,
    holiday: (j['holiday'] as num?)?.toInt() ?? 0,
    weekoff: (j['weekoff'] as num?)?.toInt() ?? 0,
  );
}

class AttendanceRow {
  final int? id;
  final String attendDate; // "YYYY-MM-DD"
  final int? status;
  final String? checkIn;
  final String? checkOut;
  final String? createdAt;
  final String? updatedAt;

  AttendanceRow({
    this.id,
    required this.attendDate,
    this.status,
    this.checkIn,
    this.checkOut,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceRow.fromJson(Map<String, dynamic> j) {
    return AttendanceRow(
      id: (j['id'] as num?)?.toInt(),
      attendDate:
          (j['attend_date'] ?? j['attendDate'] ?? j['date'])?.toString() ?? '',
      status: (j['status'] as num?)?.toInt(),
      checkIn: j['check_in']?.toString() ?? j['checkIn']?.toString(),
      checkOut: j['check_out']?.toString() ?? j['checkOut']?.toString(),
      createdAt: j['created_at']?.toString() ?? j['createdAt']?.toString(),
      updatedAt: j['updated_at']?.toString() ?? j['updatedAt']?.toString(),
    );
  }
}

class Pagination {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  Pagination({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });
  factory Pagination.fromJson(Map<String, dynamic> j) => Pagination(
    total: (j['total'] as num?)?.toInt() ?? 0,
    perPage: (j['per_page'] as num?)?.toInt() ?? 0,
    currentPage: (j['current_page'] as num?)?.toInt() ?? 1,
    lastPage: (j['last_page'] as num?)?.toInt() ?? 1,
  );
}

/// Assigned job (used in employee-level response)
class AssignedJob {
  final int? jobEmployeeId;
  final int? jobId;
  final int? employerId;
  final String? title;
  final String? joiningDate;
  final String? employmentStatus;
  AssignedJob({
    this.jobEmployeeId,
    this.jobId,
    this.employerId,
    this.title,
    this.joiningDate,
    this.employmentStatus,
  });
  factory AssignedJob.fromJson(Map<String, dynamic> j) => AssignedJob(
    jobEmployeeId: (j['job_employee_id'] as num?)?.toInt(),
    jobId: (j['job_id'] as num?)?.toInt(),
    employerId: (j['employer_id'] as num?)?.toInt(),
    title: j['title']?.toString(),
    joiningDate: j['joining_date']?.toString(),
    employmentStatus: j['employment_status']?.toString(),
  );
}

class AttendanceGroup {
  final int? jobEmployeeId;
  final int? jobId;
  final List<AttendanceRow> attendance;
  AttendanceGroup({this.jobEmployeeId, this.jobId, required this.attendance});
  factory AttendanceGroup.fromJson(Map<String, dynamic> j) {
    final att = (j['attendance'] as List? ?? [])
        .map((e) => AttendanceRow.fromJson(e as Map<String, dynamic>))
        .toList();
    return AttendanceGroup(
      jobEmployeeId: (j['job_employee_id'] as num?)?.toInt(),
      jobId: (j['job_id'] as num?)?.toInt(),
      attendance: att,
    );
  }
}

/* ===== UI helper widgets (single definitions only) ===== */

class _SummaryChips extends StatelessWidget {
  final Summary summary;
  const _SummaryChips({required this.summary});

  Widget _chip(String label, String value) {
    return Chip(
      backgroundColor: Colors.white,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        _chip('Present', '${summary.present}'),
        _chip('Absent', '${summary.absent}'),
        _chip('Leave', '${summary.leave}'),
        _chip('Holiday', '${summary.holiday}'),
        _chip('Week Off', '${summary.weekoff}'),
        _chip('Unmarked', '${summary.unmarked}'),
      ],
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemBuilder: (_, __) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: 64,
          margin: const EdgeInsets.all(12),
          color: Colors.grey.shade100,
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: 6,
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
            'No attendance entries.',
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

/* ===== Small value holder for status mapping ===== */
class _StatusView {
  final String key;
  final String label;
  final IconData icon;
  const _StatusView(this.key, this.label, this.icon);
}
