import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

class AdminReportsPage extends StatelessWidget {
  final List<ProjectModelReport> projects;

  const AdminReportsPage({super.key, required this.projects});

  Color getStatusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalProjects = projects.length;
    int approved = projects.where((p) => p.adminStatus == "approved").length;
    int rejected = projects.where((p) => p.adminStatus == "rejected").length;
    int pending = projects.where((p) => p.adminStatus == "pending").length;
    int completed = projects.where((p) => p.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Work Reports",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Web layout
            if (kIsWeb && constraints.maxWidth >= 1024) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Project cards
                  Expanded(
                    flex: 3,
                    child: GridView.builder(
                      itemCount: projects.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth > 1600
                            ? 3
                            : constraints.maxWidth > 1200
                                ? 2
                                : 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.4,
                      ),
                      itemBuilder: (_, index) =>
                          _projectCard(context, projects[index]),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right: Summary
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                "Project Overview",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 16,
                                runSpacing: 12,
                                children: [
                                  _statusBadge("Total", totalProjects, AppColors.primary),
                                  _statusBadge("Approved", approved, Colors.green),
                                  _statusBadge("Pending", pending, Colors.orange),
                                  _statusBadge("Rejected", rejected, Colors.red),
                                  if (completed > 0)
                                    _statusBadge("Completed", completed, Colors.purple),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            // Tablet / Mobile layout
            return Column(
              children: [
                // Top summary card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "Project Overview",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            _statusBadge("Total", totalProjects, AppColors.primary),
                            _statusBadge("Approved", approved, Colors.green),
                            _statusBadge("Pending", pending, Colors.orange),
                            _statusBadge("Rejected", rejected, Colors.red),
                            if (completed > 0)
                              _statusBadge("Completed", completed, Colors.purple),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Project list
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1;
                      if (constraints.maxWidth >= 601 && constraints.maxWidth < 1024) {
                        crossAxisCount = 2; // Tablet
                      }
                      if (crossAxisCount == 1) {
                        return ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (_, index) =>
                              _projectCard(context, projects[index]),
                        );
                      } else {
                        return GridView.builder(
                          itemCount: projects.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.4,
                          ),
                          itemBuilder: (_, index) =>
                              _projectCard(context, projects[index]),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _statusBadge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          if (count > 0)
            Text(
              "$count",
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _projectCard(BuildContext context, ProjectModelReport project) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {}, // Placeholder for click behavior
        hoverColor: AppColors.primary,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text("Assigned User: ${project.assignedUser ?? '-'}"),
              Text("Category: ${project.category}"),
              Text("Budget: ₹${project.budget}"),
              Text(
                  "Deadline: ${project.deadline.toLocal().toString().split(' ')[0]}"),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  _statusBadge(
                    project.adminStatus[0].toUpperCase() +
                        project.adminStatus.substring(1),
                    0,
                    getStatusColor(project.adminStatus),
                  ),
                  if (project.isCompleted)
                    _statusBadge("Completed", 0, Colors.purple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== PROJECT MODEL ==================
class ProjectModelReport {
  final String title;
  final String category;
  final double budget;
  final String paymentType;
  final double paymentValue;
  final DateTime deadline;
  final List<Map<String, String>> applicants;

  String? assignedUser;
  String adminStatus;
  bool isCompleted;
  DateTime? completedOn;

  ProjectModelReport({
    required this.title,
    required this.category,
    required this.budget,
    required this.paymentType,
    required this.paymentValue,
    required this.deadline,
    required this.applicants,
    this.assignedUser,
    this.adminStatus = "pending",
    this.isCompleted = false,
    this.completedOn,
  });
}
