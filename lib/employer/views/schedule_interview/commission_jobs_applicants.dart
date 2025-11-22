// lib/employer/views/jobs/employer_commission_jobs_with_applicants.dart
//
// NOTE: This file mirrors the UI & behavior of the salary-based employer list
// but targets commission-based jobs. It sends the same request body shape
// (employer_id + hr_approval) to the commission endpoint and navigates to
// CommissionApplicantsPage when the "View applicants" button is tapped.
//
// Uploaded asset path (you provided this file earlier; we'll convert to a URL
// where needed): sandbox:/mnt/data/2643eb78-a484-4ed7-891d-f2e6eb195ec0.png

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/employer/views/schedule_interview/commission_employee_sceduled.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class EmployerCommissionBasedJobsWithApplicantsPage extends StatefulWidget {
  const EmployerCommissionBasedJobsWithApplicantsPage({super.key});

  @override
  State<EmployerCommissionBasedJobsWithApplicantsPage> createState() =>
      _EmployerCommissionBasedJobsWithApplicantsPageState();
}

class _EmployerCommissionBasedJobsWithApplicantsPageState
    extends State<EmployerCommissionBasedJobsWithApplicantsPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _jobs = [];

  // API endpoint (commission)
  final String apiUrl =
      '${ApiConstants.baseUrl}commissionBasedJobsWithApplicants';

  // Always fetch with hr_approval = 1 for this screen (same behavior as salary screen)
  static const int _hrApproval = 1;

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
      // Read employer_id from session (avoid hardcoding)
      final employerIdStr = await SessionManager.getValue('employer_id');

      if (employerIdStr == null || employerIdStr.toString().trim().isEmpty) {
        setState(() {
          _error = "Employer ID not found. Please log in again.";
          _loading = false;
        });
        return;
      }

      // Build body same as the salary variant: include employer_id and hr_approval
      final body = {
        "employer_id": int.tryParse(employerIdStr.toString()) ?? employerIdStr,
        "hr_approval": _hrApproval,
      };

      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;

        // If your API returns a success flag, keep the same check
        if (json['success'] == true || json['status'] == true) {
          final List data = (json['data'] as List?) ?? [];
          setState(() {
            _jobs = data.map<Map<String, dynamic>>((e) {
              if (e is Map) return Map<String, dynamic>.from(e as Map);
              return <String, dynamic>{};
            }).toList();
          });
        } else {
          setState(() {
            _error = (json['message'] ?? 'Failed to load jobs').toString();
          });
        }
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
      final months = [
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
      return "${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}";
    } catch (_) {
      return raw.toString();
    }
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

        return EmployerDashboardWrapper(
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              automaticallyImplyLeading: !isWeb,
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: AppColors.primary,
              title: const Text(
                "Commission-based Jobs",
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
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
                                      Icons.monetization_on,
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
                                              employerCommissionBasedApplicantsPage(
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
