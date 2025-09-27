import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

class AdminApprovalScreen extends StatefulWidget {
  final List<ProjectModel> projects;

  const AdminApprovalScreen({super.key, required this.projects});

  @override
  State<AdminApprovalScreen> createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  final List<String> statusOptions = ["pending", "approved", "rejected"];

  void updateStatus(ProjectModel project, String status) {
    setState(() {
      project.adminStatus = status;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == "approved"
              ? "✅ ${project.assignedUser} approved for ${project.title}"
              : status == "rejected"
                  ? "❌ ${project.assignedUser} rejected for ${project.title}"
                  : "⏳ ${project.assignedUser} set as pending for ${project.title}",
        ),
        backgroundColor: status == "approved"
            ? Colors.green
            : status == "rejected"
                ? Colors.red
                : Colors.orange,
      ),
    );
  }

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
    final assignedProjects =
        widget.projects.where((p) => p.assignedUser != null).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Works",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
         iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
      ),
      body: assignedProjects.isEmpty
          ? const Center(child: Text("No projects assigned yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: assignedProjects.length,
              itemBuilder: (_, index) {
                final project = assignedProjects[index];

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Project title
                        Text(project.title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text("Assigned User: ${project.assignedUser}",
                            style: const TextStyle(color: Colors.black87)),
                        Text("Category: ${project.category}"),
                        Text("Budget: ₹${project.budget}"),
                        Text(
                            "Deadline: ${project.deadline.toLocal()}".split(" ")[0]),
                        const SizedBox(height: 10),

                        // Dropdown for status
                        Row(
                          children: [
                            const Text("Status: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(width: 12),
                            DropdownButton<String>(
                              value: project.adminStatus,
                              items: statusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(
                                    status[0].toUpperCase() + status.substring(1),
                                    style: TextStyle(color: getStatusColor(status)),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) updateStatus(project, value);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ProjectModel class
class ProjectModel {
  final String title;
  final String category;
  final double budget;
  final String paymentType;
  final double paymentValue;
  final DateTime deadline;
  final List<Map<String, String>> applicants;

  String? assignedUser; // Client assigns this
  String adminStatus; // "pending", "approved", "rejected"

  ProjectModel({
    required this.title,
    required this.category,
    required this.budget,
    required this.paymentType,
    required this.paymentValue,
    required this.deadline,
    required this.applicants,
    this.assignedUser,
    this.adminStatus = "pending",
  });
}

// Dummy project list
final List<ProjectModel> dummyProjects = [
  ProjectModel(
    title: "Website Development",
    category: "IT & Software",
    budget: 50000,
    paymentType: "Fixed",
    paymentValue: 50000,
    deadline: DateTime.now().add(const Duration(days: 30)),
    applicants: [
      {"name": "Alice", "proposal": "I will build your website in Flutter"},
      {"name": "Bob", "proposal": "I can do it with ReactJS"},
    ],
    assignedUser: "Alice",
  ),
  ProjectModel(
    title: "Logo Design",
    category: "Design",
    budget: 5000,
    paymentType: "Fixed",
    paymentValue: 5000,
    deadline: DateTime.now().add(const Duration(days: 10)),
    applicants: [
      {"name": "Charlie", "proposal": "Professional logo design"},
    ],
    assignedUser: "Charlie",
  ),
];
