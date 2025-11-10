import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class OneTimeViewPostedJobsPage extends StatelessWidget {
  const OneTimeViewPostedJobsPage({super.key});

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
                    // Tab(text: "Approved"),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [
                  JobsList(status: "Pending"),
                  JobsList(status: "Approved"),
                  JobsList(status: "Rejected"),
                  // JobsList(status: "Approved"),
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

  // API URLs (You can replace these with variables from your environment)
  final String apiUrlPending =
      'https://dialfirst.in/quantapixel/badhyata/api/getPendingOneTimeJobs';
  final String apiUrlApproved =
      'https://dialfirst.in/quantapixel/badhyata/api/getApprovedOneTimeJobs';
  final String apiUrlRejected =
      'https://dialfirst.in/quantapixel/badhyata/api/getRejectedOneTimeJobs';

  // Fetch jobs based on status
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

      print("📡 Fetching jobs for status: ${widget.status}");
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"employer_id": 14}),
      );

      print("📬 Response Status: ${response.statusCode}");
      print("📥 Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("📊 Parsed Response: $data");

        setState(() {
          jobs = List<Map<String, dynamic>>.from(data['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("❌ Error fetching jobs: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("🔥 Error while fetching jobs: $e");
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

    // ✅ Full-width ListView
    return Container(
      color: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];

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
                    "${job["job_type"] ?? "N/A"} | ₹${job["salary_min"]} - ₹${job["salary_max"]}",
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
                      color: widget.status == "Approved"
                          ? Colors.green
                          : widget.status == "Rejected"
                          ? Colors.red
                          : Colors.orange,
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
