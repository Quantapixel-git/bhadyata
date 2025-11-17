import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';
import 'package:jobshub/common/utils/session_manager.dart'; // <<-- added

class SalaryBasedViewPostedJobsPage extends StatelessWidget {
  const SalaryBasedViewPostedJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.white, // ✅ White menu icon for mobile
                ),
                automaticallyImplyLeading:
                    !isWeb, // ✅ Drawer icon visible only on mobile
                title: const Text(
                  "View Posted Jobs",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
                bottom: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70, // ✅ whitish grey
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

  final String apiUrlPending =
      'https://dialfirst.in/quantapixel/badhyata/api/SalaryBasedgetPendingJobs';
  final String apiUrlApproved =
      'https://dialfirst.in/quantapixel/badhyata/api/SalaryBasedgetApprovedJobs';
  final String apiUrlRejected =
      'https://dialfirst.in/quantapixel/badhyata/api/SalaryBasedgetRejectedJobs';

  Future<void> fetchJobs() async {
    setState(() => isLoading = true);

    try {
      // get employer id from session
      final userIdStr = await SessionManager.getValue('employer_id');

      if (userIdStr == null || userIdStr.toString().isEmpty) {
        // No employer id available — stop loading and leave jobs empty
        setState(() => isLoading = false);
        return;
      }

      String apiUrl;
      if (widget.status == "Pending") {
        apiUrl = apiUrlPending;
      } else if (widget.status == "Approved") {
        apiUrl = apiUrlApproved;
      } else {
        apiUrl = apiUrlRejected;
      }

      final body = jsonEncode({"employer_id": userIdStr});

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          jobs = List<Map<String, dynamic>>.from(data['data'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      // ignore errors for now, just stop loading
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (jobs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text("No jobs found."),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchJobs,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final job = jobs[index];
          final statusColor = widget.status == "Approved"
              ? Colors.green
              : widget.status == "Rejected"
              ? Colors.red
              : Colors.orange;

          return Container(
            width: double.infinity, // ⬅️ full available width
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
                job["title"] ?? "Unknown Title",
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
                    "${job["job_type"] ?? "N/A"} | ₹${job["salary_min"] ?? '0'} - ₹${job["salary_max"] ?? '0'}",
                  ),
                  const SizedBox(height: 2),
                  Text("Location: ${job["location"] ?? "N/A"}"),
                  const SizedBox(height: 2),
                  Text("Posted on: ${job["created_at"] ?? "N/A"}"),
                  const SizedBox(height: 4),
                  Text(
                    "Status: ${widget.status}",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.visibility, color: AppColors.primary),
                onPressed: () {
                  // TODO: Navigate to job detail page
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
