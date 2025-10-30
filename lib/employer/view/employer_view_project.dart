import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/view/drawer_dashboard/employer_side_bar.dart';

class ViewProjectsPage extends StatelessWidget {
  const ViewProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployerDashboardWrapper(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Assigned Projects",
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
                Tab(text: "Rejected"),
                Tab(text: "Approved"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ProjectList(status: "Pending"),
              ProjectList(status: "Rejected"),
              ProjectList(status: "Approved"),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectList extends StatelessWidget {
  final String status;
  const ProjectList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // Demo projects per tab
    final Map<String, List<Map<String, String>>> projectsData = {
      "Pending": [
        {
          "title": "Website Redesign",
          "assignedTo": "Not Assigned",
          "deadline": "30 Oct 2025",
          "status": "Pending",
        },
        {
          "title": "Content Strategy",
          "assignedTo": "Not Assigned",
          "deadline": "28 Oct 2025",
          "status": "Pending",
        },
      ],
      "Rejected": [
        {
          "title": "Marketing Campaign",
          "assignedTo": "Not Assigned",
          "deadline": "25 Oct 2025",
          "status": "Rejected",
        },
      ],
      "Approved": [
        {
          "title": "Mobile App Development",
          "assignedTo": "John Doe",
          "deadline": "25 Oct 2025",
          "status": "Ongoing",
        },
        {
          "title": "Social Media Campaign",
          "assignedTo": "Amit Verma",
          "deadline": "28 Oct 2025",
          "status": "Completed",
        },
        {
          "title": "Website Maintenance",
          "assignedTo": "Not Assigned",
          "deadline": "30 Oct 2025",
          "status": "Unassigned",
        },
      ],
    };

    final List<Map<String, String>> projects = projectsData[status]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];

              // Status color coding
              Color statusColor;
              switch (project["status"]) {
                case "Ongoing":
                  statusColor = Colors.orange;
                  break;
                case "Completed":
                  statusColor = Colors.green;
                  break;
                case "Unassigned":
                  statusColor = Colors.red;
                  break;
                case "Pending":
                  statusColor = Colors.orange;
                  break;
                case "Rejected":
                  statusColor = Colors.red;
                  break;
                default:
                  statusColor = Colors.grey;
              }

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
                    project["title"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("Assigned To: ${project["assignedTo"]}"),
                      Text("Deadline: ${project["deadline"]}"),
                      const SizedBox(height: 4),
                      Text(
                        "Status: ${project["status"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: statusColor,
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
