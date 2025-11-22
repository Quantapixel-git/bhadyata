import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/job_applicants/project_applicants_hr.dart';
// import 'package:jobshub/hr/views/job_applicants/one_time_job_applicant.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

class HrProjectApplicants extends StatefulWidget {
  const HrProjectApplicants({super.key});

  @override
  State<HrProjectApplicants> createState() => _HrProjectApplicantsState();
}

class _HrProjectApplicantsState extends State<HrProjectApplicants> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _jobs = [];

  // endpoint
  final String apiUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/projectsWithApplicants';

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
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final List data = (json['data'] as List?) ?? [];
        setState(() {
          // ensure each element is a Map<String, dynamic>
          _jobs = data.map<Map<String, dynamic>>((e) {
            if (e is Map) return Map<String, dynamic>.from(e as Map);
            return <String, dynamic>{};
          }).toList();
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

  /// Robust extractor for project id: supports `id`, `project_id`, `projectId`
  int _extractProjectId(Map<String, dynamic> j) {
    final raw = j['id'] ?? j['project_id'] ?? j['projectId'];
    if (raw == null) return 0;
    if (raw is int) return raw;
    return int.tryParse(raw.toString()) ?? 0;
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
                "Projects",
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

                              // Extract project id and pass it along
                              final int projectId = _extractProjectId(j);

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
                                  trailing: IconButton(
                                    tooltip: "View applicants",
                                    icon: const Icon(
                                      Icons.people_outline,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () {
                                      if (projectId == 0) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Project ID missing for this item",
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                        return;
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProjectApplicantsPage(
                                                jobId: projectId,
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
