import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/job_applicants/salary_job_applicants.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

class HrSalaryBasedJobApplicantsPage extends StatefulWidget {
  const HrSalaryBasedJobApplicantsPage({super.key});

  @override
  State<HrSalaryBasedJobApplicantsPage> createState() =>
      _HrSalaryBasedJobApplicantsPageState();
}

class _HrSalaryBasedJobApplicantsPageState
    extends State<HrSalaryBasedJobApplicantsPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _jobs = [];

  final String apiUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/salaryBasedjobsWithApplicants';

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}), // no filters initially
      );

      if (res.statusCode == 200) {
        final jsonBody = jsonDecode(res.body) as Map<String, dynamic>;
        final List data = (jsonBody['data'] as List?) ?? [];
        // ensure each element is Map<String, dynamic>
        _jobs = data.map<Map<String, dynamic>>((e) {
          if (e is Map) {
            return Map<String, dynamic>.from(e as Map);
          }
          return <String, dynamic>{};
        }).toList();
        if (mounted) setState(() {});
      } else {
        setState(() => _error = "Error ${res.statusCode}");
      }
    } catch (e) {
      setState(() => _error = "Network error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _safe(dynamic v) {
    if (v == null) return '—';
    final s = v.toString().trim();
    return s.isEmpty ? '—' : s;
  }

  String _formatDate(dynamic raw) {
    if (raw == null) return '—';
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      return "${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}";
    } catch (_) {
      final s = raw.toString();
      return s.isEmpty ? '—' : s;
    }
  }

  String _month(int m) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    final idx = (m.clamp(1, 12)) - 1;
    return months[idx];
  }

  Widget _countPill(int count) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.primary.withOpacity(0.10),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: AppColors.primary.withOpacity(0.25)),
    ),
    child: Text(
      "$count applicant${count == 1 ? '' : 's'}",
      style: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    ),
  );

  /// Robust job id extractor: supports common keys like `id`, `job_id`, `jobId`.
  int _extractJobId(Map<String, dynamic> job) {
    final raw =
        job['id'] ?? job['job_id'] ?? job['jobId'] ?? job['jobId']?.toString();
    if (raw == null) return 0;
    if (raw is int) return raw;
    final parsed = int.tryParse(raw.toString());
    return parsed ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return HrDashboardWrapper(
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              automaticallyImplyLeading: !isWeb,
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: AppColors.primary,
              title: const Text(
                "Salary-Based Jobs",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              elevation: 2,
            ),
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: _fetchJobs,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchJobs,
                    child: _jobs.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 120),
                              Center(
                                child: Text(
                                  'No jobs with applicants',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _jobs.length,
                            itemBuilder: (context, i) {
                              final j = _jobs[i];

                              final title = _safe(j['title']);
                              final category = _safe(j['category']);
                              final location = _safe(j['location']);

                              // Payment: prefer payment_amount; fallback to salary_min/salary_max if present
                              String paymentDisplay() {
                                final pAmount = j['payment_amount']?.toString();
                                if (pAmount != null &&
                                    pAmount.trim().isNotEmpty) {
                                  return "₹${pAmount.trim()}";
                                }
                                final sMin = j['salary_min']?.toString();
                                final sMax = j['salary_max']?.toString();
                                if ((sMin?.isNotEmpty ?? false) ||
                                    (sMax?.isNotEmpty ?? false)) {
                                  final min = sMin?.isNotEmpty == true
                                      ? sMin
                                      : '-';
                                  final max = sMax?.isNotEmpty == true
                                      ? sMax
                                      : '-';
                                  return "₹$min - ₹$max";
                                }
                                return '—';
                              }

                              final payment = paymentDisplay();

                              // Job date: try job_date else created_at
                              final jobDate = j['job_date'] != null
                                  ? _formatDate(j['job_date'])
                                  : _formatDate(j['created_at']);

                              final startTime = _safe(j['start_time']);
                              final endTime = _safe(j['end_time']);

                              // applicants_count may be int or string — normalize to int
                              int applicantsCount = 0;
                              final rawCount = j['applicants_count'];
                              if (rawCount is int) {
                                applicantsCount = rawCount;
                              } else if (rawCount is String) {
                                applicantsCount = int.tryParse(rawCount) ?? 0;
                              } else if (rawCount != null) {
                                applicantsCount =
                                    int.tryParse(rawCount.toString()) ?? 0;
                              }

                              // Extract job id safely
                              final int jobId = _extractJobId(j);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.12),
                                    child: Icon(
                                      Icons.work,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  title: Text(
                                    title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text("$category • $payment"),
                                      const SizedBox(height: 2),
                                      Text("Location: $location"),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Created Date: $jobDate ${startTime != '—' ? '• $startTime' : ''}${endTime != '—' ? ' – $endTime' : ''}",
                                      ),
                                      const SizedBox(height: 8),
                                      _countPill(applicantsCount),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    tooltip: "View applicants",
                                    icon: const Icon(
                                      Icons.people_outline,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () {
                                      if (jobId == 0) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Job id not available for this entry.',
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                        return;
                                      }

                                      // Navigate to the applicants page with correct id and title
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              SalaryBasedApplicantsPage(
                                                jobId: jobId,
                                                jobTitle: title,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        );
      },
    );
  }
}
