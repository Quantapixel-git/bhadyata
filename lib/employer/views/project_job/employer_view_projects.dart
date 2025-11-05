import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_side_bar.dart';
import 'package:intl/intl.dart';

class ViewPostedProjectsPage extends StatelessWidget {
  const ViewPostedProjectsPage({super.key});

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
                  ProjectsList(status: "Pending"),
                  ProjectsList(status: "Approved"),
                  ProjectsList(status: "Rejected"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProjectsList extends StatefulWidget {
  final String status;
  const ProjectsList({super.key, required this.status});

  @override
  State<ProjectsList> createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  bool isLoading = true;
  List<Map<String, dynamic>> projects = [];

  // 🔗 API URLs
  final String apiUrlPending =
      'https://dialfirst.in/quantapixel/badhyata/api/getPendingProjects';
  final String apiUrlApproved =
      'https://dialfirst.in/quantapixel/badhyata/api/getApprovedProjects';
  final String apiUrlRejected =
      'https://dialfirst.in/quantapixel/badhyata/api/getRejectedProjects';

  // 🧠 Fetch Projects by Status
  Future<void> fetchProjects() async {
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

      print("📡 Fetching projects for status: ${widget.status}");
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"employer_id": 14}), // Change dynamically if needed
      );

      print("📬 Response Status: ${response.statusCode}");
      print("📥 Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          projects = List<Map<String, dynamic>>.from(data['data']);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        print("❌ Error fetching projects: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("🔥 Error while fetching projects: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : projects.isEmpty
                  ? const Center(
                      child: Text(
                        "No projects found.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final project = projects[index];
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
                              project["title"] ?? "Unknown Project",
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
                                  "${project["category"] ?? "N/A"} | ₹${project["budget_min"] ?? "0"} - ₹${project["budget_max"] ?? "0"} (${project["budget_type"] ?? "N/A"})",
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Location: ${project["location"] ?? "N/A"}",
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Deadline: ${_formatDate(project["application_deadline"])}",
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Posted on: ${_formatDate(project["created_at"])}",
                                ),
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
                              icon: const Icon(
                                Icons.visibility,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                // TODO: Navigate to project detail page
                              },
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
