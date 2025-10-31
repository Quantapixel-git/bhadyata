import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class AdminJob {
  final String title;
  final String assignedTo;
  final String employer;
  DateTime startDate;
  DateTime endDate;
  String status;

  AdminJob({
    required this.title,
    required this.assignedTo,
    required this.employer,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}

class JobStatusScreen extends StatelessWidget {
  JobStatusScreen({super.key});

  final List<AdminJob> jobs = [
    AdminJob(
      title: "Flutter Developer",
      assignedTo: "John Doe",
      employer: "Tech Solutions",
      startDate: DateTime(2025, 9, 1),
      endDate: DateTime(2025, 9, 27),
      status: "Active",
    ),
    AdminJob(
      title: "UI/UX Designer",
      assignedTo: "Jane Smith",
      employer: "Creative Minds",
      startDate: DateTime(2025, 9, 10),
      endDate: DateTime(2025, 10, 10),
      status: "Extended",
    ),
    AdminJob(
      title: "Backend Developer",
      assignedTo: "Mike Johnson",
      employer: "Tech Solutions",
      startDate: DateTime(2025, 8, 1),
      endDate: DateTime(2025, 8, 15),
      status: "Terminated",
    ),
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Extended":
        return Colors.orange;
      case "Terminated":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isWeb = constraints.maxWidth > 900;
      bool isMobile = constraints.maxWidth < 600;

      Widget content = Padding(
        padding: const EdgeInsets.all(16.0),
        child: isMobile
            ? ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) => _buildJobCard(jobs[index]),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth < 1024 ? 2 : 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2,
                ),
                itemCount: jobs.length,
                itemBuilder: (context, index) => _buildJobCard(jobs[index]),
              ),
      );

      return Scaffold(
        appBar: isMobile
            ? AppBar(
                title: const Text(
                  "Job Status",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                backgroundColor: AppColors.primary,
              )
            : null,
        // drawer: isMobile ? const AdminSidebar(selectedPage: "Job Status") : null,
        body: Row(
          children: [
            if (isWeb)
              const SizedBox(
                width: 260,
                // child: AdminSidebar(selectedPage: "Job Status", isWeb: true),
              ),
            Expanded(child: content),
          ],
        ),
      );
    });
  }

  Widget _buildJobCard(AdminJob job) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.work_outline, color: getStatusColor(job.status), size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Assigned to: ${job.assignedTo}", style: const TextStyle(color: Colors.black54)),
                  Text("Employer: ${job.employer}", style: const TextStyle(color: Colors.black54)),
                  Text(
                      "Start: ${DateFormat('yyyy-MM-dd').format(job.startDate)} | End: ${DateFormat('yyyy-MM-dd').format(job.endDate)}",
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: getStatusColor(job.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(job.status,
                  style: TextStyle(fontWeight: FontWeight.bold, color: getStatusColor(job.status))),
            ),
          ],
        ),
      ),
    );
  }
}
