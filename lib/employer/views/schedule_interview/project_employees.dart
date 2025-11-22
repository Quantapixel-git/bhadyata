
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/employer/views/schedule_interview/project_employee_scedule.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class EmployerProjectsWithApplicantsPage extends StatefulWidget {
  const EmployerProjectsWithApplicantsPage({super.key});

  @override
  State<EmployerProjectsWithApplicantsPage> createState() =>
      _EmployerProjectsWithApplicantsPageState();
}

class _EmployerProjectsWithApplicantsPageState
    extends State<EmployerProjectsWithApplicantsPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _projects = [];

  // API endpoint (matches your controller route)
  final String apiUrl = '${ApiConstants.baseUrl}projectsWithApplicants';

  // Always fetch with hr_approval = 1 for this screen
  static const int _hrApproval = 1;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Read employer_id from session
      final employerIdStr = await SessionManager.getValue('employer_id');

      if (employerIdStr == null || employerIdStr.toString().trim().isEmpty) {
        setState(() {
          _error = "Employer ID not found. Please log in again.";
          _loading = false;
        });
        return;
      }

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

        if (json['success'] == true || json['status'] == true) {
          final List data = (json['data'] as List?) ?? [];
          setState(() {
            _projects = data.map<Map<String, dynamic>>((e) {
              if (e is Map) return Map<String, dynamic>.from(e as Map);
              return <String, dynamic>{};
            }).toList();
          });
        } else {
          setState(() {
            _error = (json['message'] ?? 'Failed to load projects').toString();
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

  /// Robust id extractor: supports common keys like `id`, `project_id`, `projectId`.
  int _extractProjectId(Map<String, dynamic> job) {
    final raw = job['id'] ?? job['project_id'] ?? job['projectId'];
    if (raw == null) return 0;
    if (raw is int) return raw;
    final parsed = int.tryParse(raw.toString());
    return parsed ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isWeb = constraints.maxWidth >= 900;

      return EmployerDashboardWrapper(
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
                            onPressed: _fetchProjects,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchProjects,
                      child: _projects.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                const SizedBox(height: 120),
                                Center(
                                  child: Text(
                                    'No projects with applicants',
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
                              itemCount: _projects.length,
                              itemBuilder: (context, i) {
                                final p = _projects[i];

                                final title = _safe(p['title']);
                                final category = _safe(p['category']);
                                final location = _safe(p['location']);

                                // Prefer project_fee / payment_amount; fallback if not present
                                String paymentDisplay() {
                                  final pAmount = p['payment_amount']?.toString();
                                  if (pAmount != null && pAmount.trim().isNotEmpty) {
                                    return "₹${pAmount.trim()}";
                                  }
                                  final fee = p['project_fee']?.toString() ?? p['fee']?.toString();
                                  if (fee != null && fee.trim().isNotEmpty) {
                                    return "₹${fee.trim()}";
                                  }
                                  return '—';
                                }

                                final payment = paymentDisplay();

                                // Project date: try project_date else created_at
                                final projectDate = p['project_date'] != null
                                    ? _formatDate(p['project_date'])
                                    : _formatDate(p['created_at']);

                                final startTime = _safe(p['start_time']);
                                final endTime = _safe(p['end_time']);

                                // applicants_count may be int or string — normalize to int
                                int applicantsCount = 0;
                                final rawCount = p['applicants_count'];
                                if (rawCount is int) {
                                  applicantsCount = rawCount;
                                } else if (rawCount is String) {
                                  applicantsCount = int.tryParse(rawCount) ?? 0;
                                } else if (rawCount != null) {
                                  applicantsCount = int.tryParse(rawCount.toString()) ?? 0;
                                }

                                // Extract project id safely
                                final int projectId = _extractProjectId(p);

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
                                      backgroundColor: AppColors.primary.withOpacity(0.12),
                                      child: Icon(
                                        Icons.construction, // project-like icon
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text("$category • $payment"),
                                        const SizedBox(height: 2),
                                        Text("Location: $location"),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Date: $projectDate ${startTime != '—' ? '• $startTime' : ''}${endTime != '—' ? ' – $endTime' : ''}",
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
                                        if (projectId == 0) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Project id not available for this entry.'),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                          return;
                                        }

                                        // Navigate to the project applicants page.
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => employerProjectApplicantsPage(
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
    });
  }
}
