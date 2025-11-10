import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

// Uses the same base as your list page
const String kApiBase = 'https://dialfirst.in/quantapixel/badhyata/api/';

class HrEmployeeAttendanceDetailPage extends StatefulWidget {
  final int jobEmployeeId;
  final int initialYear;
  final int initialMonth;
  final String? employeeName;

  const HrEmployeeAttendanceDetailPage({
    super.key,
    required this.jobEmployeeId,
    required this.initialYear,
    required this.initialMonth,
    this.employeeName,
  });

  @override
  State<HrEmployeeAttendanceDetailPage> createState() =>
      _HrEmployeeAttendanceDetailPageState();
}

class _HrEmployeeAttendanceDetailPageState
    extends State<HrEmployeeAttendanceDetailPage> {
  bool _loading = false;
  String? _error;

  late int _year = widget.initialYear;
  late int _month = widget.initialMonth;

  AttendanceMonthlyResponse? _resp;

  static const _perPage = 31;
  static const _page = 1;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse('${kApiBase}attendanceMonthly');
      final body = jsonEncode({
        "job_employee_id": widget.jobEmployeeId,
        "year": _year,
        "month": _month,
        "per_page": _perPage,
        "page": _page,
      });

      final res = await http.post(
        uri,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final map = jsonDecode(res.body) as Map<String, dynamic>;
        if (map['success'] == true) {
          setState(() => _resp = AttendanceMonthlyResponse.fromJson(map));
        } else {
          setState(
            () => _error = map['message']?.toString() ?? 'Failed to fetch.',
          );
        }
      } else {
        setState(
          () => _error =
              'Failed (${res.statusCode}). ${res.reasonPhrase ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onRefresh() => _fetch();

  void _goPrev() {
    final pm = _resp?.prevMonth;
    if (pm == null) return;
    setState(() {
      _year = pm.year;
      _month = pm.month;
    });
    _fetch();
  }

  void _goNext() {
    final nm = _resp?.nextMonth;
    if (nm == null) return;
    setState(() {
      _year = nm.year;
      _month = nm.month;
    });
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel = _monthName(_month);
    final emp = widget.employeeName?.trim();
    final title = (emp == null || emp.isEmpty) ? 'Attendance' : 'Attendance';

    return HrDashboardWrapper(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              title,
              style: const TextStyle(
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
                onPressed: _fetch,
              ),
            ],
          ),
          // Month switcher
          Material(
            color: Colors.white,
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Previous month',
                    onPressed: _resp?.prevMonth == null ? null : _goPrev,
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
                    onPressed: _resp?.nextMonth == null ? null : _goNext,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: _loading && _resp == null
                  ? const _Skeleton()
                  : _error != null
                  ? _ErrorBox(message: _error!, onRetry: _fetch)
                  : _resp == null
                  ? const _Empty()
                  : ListView(
                      padding: const EdgeInsets.all(12),
                      children: [
                        // Summary
                        _SummaryChips(summary: _resp!.summary),
                        const SizedBox(height: 12),
                        // Day list
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _resp!.data.length,
                            separatorBuilder: (_, __) =>
                                Divider(height: 1, color: Colors.grey.shade200),
                            itemBuilder: (_, i) {
                              final d = _resp!.data[i];
                              final status = _mapStatus(d.status);
                              final icon = _statusIcon(status.key);
                              final color = _statusColor(status.key);

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: color.withOpacity(0.12),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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

  // -------- helpers

  _StatusView _mapStatus(int? raw) {
    // Best-effort map; aligns with summary keys you shared.
    // 0=unmarked, 1=present, 2=absent, 3=leave, 4=holiday, 5=weekoff
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
}

/* ===== Models ===== */

class AttendanceMonthlyResponse {
  final bool success;
  final String? message;
  final int jobEmployeeId;
  final int year;
  final int month;
  final DateRange? range;
  final YearMonth? prevMonth;
  final YearMonth? nextMonth;
  final Summary summary;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final List<AttendanceRow> data;

  AttendanceMonthlyResponse({
    required this.success,
    required this.jobEmployeeId,
    required this.year,
    required this.month,
    required this.summary,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.data,
    this.message,
    this.range,
    this.prevMonth,
    this.nextMonth,
  });

  factory AttendanceMonthlyResponse.fromJson(Map<String, dynamic> j) {
    return AttendanceMonthlyResponse(
      success: j['success'] == true,
      message: j['message']?.toString(),
      jobEmployeeId: (j['job_employee_id'] as num).toInt(),
      year: (j['year'] as num).toInt(),
      month: (j['month'] as num).toInt(),
      range: j['range'] == null ? null : DateRange.fromJson(j['range']),
      prevMonth: j['prev_month'] == null
          ? null
          : YearMonth.fromJson(j['prev_month']),
      nextMonth: j['next_month'] == null
          ? null
          : YearMonth.fromJson(j['next_month']),
      summary: Summary.fromJson(j['summary'] as Map<String, dynamic>),
      total: (j['total'] as num).toInt(),
      perPage: (j['per_page'] as num).toInt(),
      currentPage: (j['current_page'] as num).toInt(),
      lastPage: (j['last_page'] as num).toInt(),
      data: ((j['data'] as List?) ?? [])
          .map((e) => AttendanceRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

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
    year: (j['year'] as num).toInt(),
    month: (j['month'] as num).toInt(),
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
  final int id;
  final String attendDate; // "YYYY-MM-DD"
  final int? status; // numeric code
  final String? checkIn; // may be null
  final String? checkOut; // may be null
  final String? createdAt;
  final String? updatedAt;

  AttendanceRow({
    required this.id,
    required this.attendDate,
    this.status,
    this.checkIn,
    this.checkOut,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceRow.fromJson(Map<String, dynamic> j) => AttendanceRow(
    id: (j['id'] as num).toInt(),
    attendDate: j['attend_date'].toString(),
    status: (j['status'] as num?)?.toInt(),
    checkIn: j['check_in']?.toString(),
    checkOut: j['check_out']?.toString(),
    createdAt: j['created_at']?.toString(),
    updatedAt: j['updated_at']?.toString(),
  );
}

/* ===== UI bits ===== */

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

class _Skeleton extends StatelessWidget {
  const _Skeleton();

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
      itemCount: 8,
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

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
  final String key; // 'present', 'absent', etc.
  final String label; // UI label
  final IconData icon;
  const _StatusView(this.key, this.label, this.icon);
}
