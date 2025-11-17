import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/job_approval/salay_job_detail.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

class HrSalaryBasedViewPostedJobsPage extends StatelessWidget {
  const HrSalaryBasedViewPostedJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return HrDashboardWrapper(
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Salary-Based Jobs",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
                bottom: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70, // whitish grey
                  indicatorColor: Colors.white,
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(text: "Pending"),
                    Tab(text: "Approved"),
                    Tab(text: "Rejected"),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [
                  JobsList(status: "Pending"),
                  JobsList(status: "Approved"),
                  JobsList(status: "Rejected"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class JobsList extends StatefulWidget {
  final String status;
  const JobsList({super.key, required this.status});

  @override
  _JobsListState createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  bool isLoading = true;
  List<Map<String, dynamic>> jobs = [];
  final String apiUrlApproval =
      'https://dialfirst.in/quantapixel/badhyata/api/SalaryBasedJobApproval';

  final Set<int> _processing = {}; // ids currently being approved/rejected

  final String apiUrlPending =
      'https://dialfirst.in/quantapixel/badhyata/api/SalaryBasedgetPendingJobs';
  final String apiUrlApproved =
      'https://dialfirst.in/quantapixel/badhyata/api/SalaryBasedgetApprovedJobs';
  final String apiUrlRejected =
      'https://dialfirst.in/quantapixel/badhyata/api/SalaryBasedgetRejectedJobs';

  final String apiUrlView =
      'https://dialfirst.in/quantapixel/badhyata/api/SalaryBasedJobView';

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> _updateApproval(int id, int approval) async {
    setState(() => _processing.add(id));
    try {
      final res = await http.post(
        Uri.parse(apiUrlApproval),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'approval': approval,
        }), // 1=approved, 3=rejected
      );

      if (res.statusCode == 200) {
        // optionally refresh list: for immediacy remove from local list if pending
        setState(() {
          jobs.removeWhere((j) {
            final jid = int.tryParse(j['id'].toString()) ?? -1;
            return jid == id;
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(approval == 1 ? 'Approved' : 'Rejected'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Failed (${res.statusCode})'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Network error'),
        ),
      );
    } finally {
      if (mounted) setState(() => _processing.remove(id));
    }
  }

  Future<void> fetchJobs() async {
    setState(() {
      isLoading = true;
    });

    try {
      String apiUrl;
      if (widget.status == "Pending") {
        apiUrl = apiUrlPending;
      } else if (widget.status == "Approved") {
        apiUrl = apiUrlApproved;
      } else {
        apiUrl = apiUrlRejected;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          jobs = List<Map<String, dynamic>>.from(data['data'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          jobs = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        jobs = [];
        isLoading = false;
      });
    }
  }

  String _formatDate(dynamic raw) {
    if (raw == null) return "N/A";
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (e) {
      return raw.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (jobs.isEmpty) {
      return RefreshIndicator(
        onRefresh: fetchJobs,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No Jobs',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchJobs,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          final int jobId = int.tryParse(job['id']?.toString() ?? '') ?? -1;

          final title = job["title"]?.toString() ?? "Unknown Title";
          final jobType = job["category"] ?? "N/A";
          final salaryMin = job["salary_min"] ?? "-";
          final salaryMax = job["salary_max"] ?? "-";
          final location = job["location"] ?? "N/A";
          final createdAt = _formatDate(job["created_at"]);

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
                  Text("$jobType | ₹$salaryMin - ₹$salaryMax"),
                  const SizedBox(height: 2),
                  Text("Location: $location"),
                  const SizedBox(height: 2),
                  Text("Posted on: $createdAt"),
                  const SizedBox(height: 6),
                  Text(
                    "Status: ${widget.status}",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: widget.status == "Approved"
                          ? Colors.green
                          : widget.status == "Rejected"
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                ],
              ),

              // Eye button present in all tabs; for pending we still keep approve/reject UI
              trailing: widget.status == "Pending"
                  ? (_processing.contains(jobId)
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: "Approve",
                                icon: const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                ),
                                onPressed: jobId == -1
                                    ? null
                                    : () => _updateApproval(jobId, 1),
                              ),
                              IconButton(
                                tooltip: "Reject",
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.red,
                                ),
                                onPressed: jobId == -1
                                    ? null
                                    : () => _updateApproval(jobId, 3),
                              ),
                              IconButton(
                                tooltip: "View",
                                icon: const Icon(
                                  Icons.visibility,
                                  color: AppColors.primary,
                                ),
                                onPressed: jobId == -1
                                    ? null
                                    : () => _openJobDetail(context, jobId),
                              ),
                            ],
                          ))
                  : IconButton(
                      icon: const Icon(
                        Icons.visibility,
                        color: AppColors.primary,
                      ),
                      onPressed: jobId == -1
                          ? null
                          : () => _openJobDetail(context, jobId),
                    ),
            ),
          );
        },
      ),
    );
  }

  void _openJobDetail(BuildContext context, int jobId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailPage(jobId: jobId, viewUrl: apiUrlView),
      ),
    );
  }
}
