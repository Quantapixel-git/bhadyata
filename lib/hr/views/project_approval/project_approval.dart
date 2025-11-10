import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/project_approval/hr_project_detail.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

class HrProjectApproval extends StatelessWidget {
  const HrProjectApproval({super.key});

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
                  "View Posted Projects",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
                bottom: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
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

  // API endpoints
  final String apiUrlPending =
      'https://dialfirst.in/quantapixel/badhyata/api/getPendingProjects';
  final String apiUrlApproved =
      'https://dialfirst.in/quantapixel/badhyata/api/getApprovedProjects';
  final String apiUrlRejected =
      'https://dialfirst.in/quantapixel/badhyata/api/getRejectedProjects';

  // Approval API ({{bhadyata}}ProjectApproval)
  final String apiUrlApproval =
      'https://dialfirst.in/quantapixel/badhyata/api/ProjectApproval';

  // track ids currently being approved/rejected
  final Set<int> _processing = {};

  @override
  void initState() {
    super.initState();
    fetchJobs();
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
        // remove the project from the Pending list on success
        setState(() {
          jobs.removeWhere((p) {
            final pid = int.tryParse(p['id'].toString()) ?? -1;
            return pid == id;
          });
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(approval == 1 ? 'Approved' : 'Rejected'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Failed (${res.statusCode})'),
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Network error'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _processing.remove(id));
    }
  }

  String _formatDate(dynamic raw) {
    if (raw == null) return "N/A";
    try {
      final dt = DateTime.parse(raw.toString());
      return "${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}";
    } catch (e) {
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
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    // Full-width layout (no Center/ConstrainedBox)
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
              child: Text(
                'No projects',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
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
                job["title"]?.toString() ?? "Unknown Title",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    "${job["category"] ?? "N/A"} | ₹${job["budget_min"] ?? "-"} - ₹${job["budget_max"] ?? "-"}",
                  ),
                  const SizedBox(height: 2),
                  Text("Location: ${job["location"] ?? "N/A"}"),
                  const SizedBox(height: 2),
                  Text("Posted on: ${_formatDate(job["created_at"])}"),
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
                            ],
                          ))
                  : IconButton(
                      icon: const Icon(
                        Icons.visibility,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailPage(project: job),
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
