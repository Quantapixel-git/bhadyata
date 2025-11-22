import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/job_applicants/commissionbased_applicants.dart';
// <-- import your Commission applicants page (adjust path if needed)
// import 'package:jobshub/hr/views/job_applicants/commission_applicants_page.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

class HrCommissionBasedJobApplicants extends StatefulWidget {
  const HrCommissionBasedJobApplicants({super.key});

  @override
  State<HrCommissionBasedJobApplicants> createState() =>
      _HrCommissionBasedJobApplicantsState();
}

class _HrCommissionBasedJobApplicantsState
    extends State<HrCommissionBasedJobApplicants> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _jobs = [];

  // endpoint for commission jobs with applicants
  final String apiUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/commissionBasedJobsWithApplicants';

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  /// Robust job id extractor: supports common keys and int/string types.
  /// Checks: `job_id`, `jobId`, `id`, and falls back to parsing any numeric-like value.
  int _extractJobIdFromMap(Map<String, dynamic> item) {
    if (item == null) return 0;

    // common keys
    final candidates = [
      item['job_id'],
      item['jobId'],
      item['id'],
      item['jobID'],
      item['Id'],
    ];

    for (final raw in candidates) {
      if (raw == null) continue;
      if (raw is int) return raw;
      final s = raw.toString().trim();
      if (s.isEmpty) continue;
      final parsed = int.tryParse(s);
      if (parsed != null) return parsed;
    }

    // final attempt: search the map for a numeric-looking value (rare)
    for (final v in item.values) {
      if (v == null) continue;
      final s = v.toString().trim();
      final p = int.tryParse(s);
      if (p != null) return p;
    }

    return 0;
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
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final List data = (json['data'] as List?) ?? [];
        setState(() {
          _jobs = data.cast<Map<String, dynamic>>();
        });
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
      final dt = DateTime.parse(raw.toString());
      return "${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}";
    } catch (_) {
      return raw.toString();
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
    return months[(m.clamp(1, 12)) - 1];
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
                "Commission-based jobs",
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
                              final payment = _safe(j['payment_amount']);
                              final paymentType = _safe(j['payment_type']);
                              final jobDate = _formatDate(j['job_date']);
                              final startTime = _safe(j['start_time']);
                              final endTime = _safe(j['end_time']);
                              final count =
                                  int.tryParse(_safe(j['applicants_count'])) ??
                                  0;

                              // pull job_id (ensure it exists and is int)
                              final int jobId = _extractJobIdFromMap(j);

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
                                      Text(
                                        "$category • ₹$payment ($paymentType)",
                                      ),
                                      const SizedBox(height: 2),
                                      Text("Location: $location"),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Job Date: $jobDate • $startTime – $endTime",
                                      ),
                                      const SizedBox(height: 8),
                                      _countPill(count),
                                    ],
                                  ),
                                  // Navigate to Commission applicants page (same pattern as one-time)
                                  trailing: IconButton(
                                    tooltip: "View applicants",
                                    icon: const Icon(
                                      Icons.people_outline,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () {
                                      if (jobId <= 0) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Invalid job id for this item',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CommissionApplicantsPage(
                                                jobId: jobId,
                                                jobTitle: title, // optional
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
