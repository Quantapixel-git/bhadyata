import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/common/constants/constants.dart';
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

  // API endpoint (matches your controller route)
  final String apiUrl =
      '${ApiConstants.baseUrl}commissionBasedJobsWithApplicants';

  // Always fetch with hr_approval = 1 for this screen
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
      // Read employer_id from session (avoid hardcoding 14)
      final employerIdStr = await SessionManager.getValue('employer_id');
      if (employerIdStr == null || employerIdStr.isEmpty) {
        setState(() {
          _error = "Employer ID not found. Please log in again.";
          _loading = false;
        });
        return;
      }

      final body = {
        "employer_id": int.tryParse(employerIdStr) ?? employerIdStr,
        "hr_approval": _hrApproval,
      };

      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        if (json['success'] == true) {
          final List data = (json['data'] as List?) ?? [];
          setState(() {
            _jobs = data.cast<Map<String, dynamic>>();
          });
        } else {
          setState(
            () => _error = (json['message'] ?? 'Failed to load').toString(),
          );
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
                "Jobs With Applicants",
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
                          textAlign: TextAlign.center,
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

                              // Common fields from your controller mapping
                              final title = _safe(j['title']);
                              final category = _safe(j['category']);
                              final location = _safe(j['location']);
                              final createdAt = _formatDate(j['created_at']);
                              final count = (j['applicants_count'] is int)
                                  ? (j['applicants_count'] as int)
                                  : int.tryParse(
                                          _safe(j['applicants_count']),
                                        ) ??
                                        0;

                              // Salary-based friendly bits (optional, if present)
                              final jobType = _safe(
                                j['job_type'],
                              ); // may not exist
                              final salaryMin = _safe(
                                j['salary_min'],
                              ); // may not exist
                              final salaryMax = _safe(
                                j['salary_max'],
                              ); // may not exist

                              // If salary fields are missing, we won’t show salary line.
                              final hasSalaryRange =
                                  salaryMin != '—' || salaryMax != '—';

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
                                        jobType != '—'
                                            ? "$category • $jobType"
                                            : "$category",
                                      ),
                                      if (hasSalaryRange) ...[
                                        const SizedBox(height: 2),
                                        Text("₹$salaryMin - ₹$salaryMax"),
                                      ],
                                      const SizedBox(height: 2),
                                      Text("Location: $location"),
                                      const SizedBox(height: 2),
                                      Text("Posted on: $createdAt"),
                                      const SizedBox(height: 8),
                                      _countPill(count),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    tooltip: "View applicants",
                                    icon: const Icon(
                                      Icons.people_outline,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () {
                                      // TODO: Navigate to applicant list for this job ID
                                      // final jobId = j['id'];
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
