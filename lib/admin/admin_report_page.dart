import 'package:flutter/material.dart';

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
        title: const Text("Work Reports",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
         iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        _statusBadge("Total", totalProjects, Colors.blue),
                        const SizedBox(height: 8),
                        _statusBadge("Approved", approved, Colors.green),
                        const SizedBox(height: 8),
                        _statusBadge("Pending", pending, Colors.orange),
                        const SizedBox(height: 8),
                        _statusBadge("Rejected", rejected, Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Project list
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (_, index) {
                  final project = projects[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text("Assigned User: ${project.assignedUser ?? '-'}"),
                          Text("Category: ${project.category}"),
                          Text("Budget: ₹${project.budget}"),
                          Text(
                            "Deadline: ${project.deadline.toLocal().toString().split(' ')[0]}",
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _statusBadge(
                                project.adminStatus[0].toUpperCase() +
                                    project.adminStatus.substring(1),
                                0,
                                getStatusColor(project.adminStatus),
                              ),
                              const SizedBox(width: 10),
                              if (project.isCompleted)
                                _statusBadge("Completed", 0, Colors.purple),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
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
}

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
