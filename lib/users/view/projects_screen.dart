import 'package:flutter/material.dart';
import 'package:jobshub/users/view/user_sidedrawer.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class ProjectApplication {
  final String title;
  final String company;
  final String appliedDate;
  final String location;
  final String jobType;
  final String salaryOrAmount; // can be monthly or fixed
  final String paymentType; // "Monthly" or "Fixed"
  String status; // Pending / Accepted / Rejected

  ProjectApplication({
    required this.title,
    required this.company,
    required this.appliedDate,
    required this.location,
    required this.jobType,
    required this.salaryOrAmount,
    required this.paymentType,
    this.status = "Pending",
  });
}

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  List<ProjectApplication> applications = [
    ProjectApplication(
      title: "Flutter Developer (Full App)",
      company: "TechNova Pvt. Ltd.",
      appliedDate: "Oct 20, 2025",
      location: "Remote",
      jobType: "Contract",
      salaryOrAmount: "₹1,20,000",
      paymentType: "Fixed",
      status: "Pending",
    ),
    ProjectApplication(
      title: "UI/UX Designer",
      company: "PixelCraft Studio",
      appliedDate: "Oct 15, 2025",
      location: "Bangalore, India",
      jobType: "Hybrid",
      salaryOrAmount: "₹55,000",
      paymentType: "Monthly",
      status: "Accepted",
    ),
    ProjectApplication(
      title: "Backend Developer",
      company: "CodeWorks",
      appliedDate: "Oct 10, 2025",
      location: "Mumbai, India",
      jobType: "Contract",
      salaryOrAmount: "₹80,000",
      paymentType: "Monthly",
      status: "Rejected",
    ),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "Accepted":
        return Colors.green.shade100;
      case "Rejected":
        return Colors.red.shade100;
      default:
        return Colors.orange.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case "Accepted":
        return Colors.green.shade800;
      case "Rejected":
        return Colors.red.shade800;
      default:
        return Colors.orange.shade800;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Accepted":
        return Icons.check_circle_outline;
      case "Rejected":
        return Icons.cancel_outlined;
      default:
        return Icons.hourglass_empty_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      // backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "My Projects",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        // backgroundColor: Colors.white,
      ),
      body: Row(
        children: [
          if (isWeb) const AppDrawer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: applications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: applications.length,
                      itemBuilder: (context, index) {
                        final app = applications[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Company Logo
                                CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  radius: 28,
                                  child: Icon(
                                    Icons.business_center,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Job Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        app.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        app.company,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            app.location,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          const Icon(
                                            Icons.work_outline,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            app.jobType,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),
                                      Text(
                                        app.paymentType == "Fixed"
                                            ? "Fixed Price: ${app.salaryOrAmount}"
                                            : "Salary: ${app.salaryOrAmount} / month",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Applied on ${app.appliedDate}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),

                                        Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Chip(
                                      avatar: Icon(
                                        _getStatusIcon(app.status),
                                        color: _getStatusTextColor(app.status),
                                        size: 18,
                                      ),
                                      backgroundColor: _getStatusColor(
                                        app.status,
                                      ),
                                      label: Text(
                                        app.status,
                                        style: TextStyle(
                                          color: _getStatusTextColor(
                                            app.status,
                                          ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (app.status == "Accepted")
                                      TextButton.icon(
                                        onPressed: () {
                                          // Navigate to project details page
                                        },
                                        icon: const Icon(
                                          Icons.visibility_outlined,
                                          size: 18,
                                        ),
                                        label: const Text("Details"),
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppColors.primary,
                                        ),
                                      ),
                                  ],
                                ),
                                    ],
                                  ),
                                ),

                                // Status & Action
                              
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          const Text(
            "No Applications Yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "You haven’t applied for any projects.\nStart exploring new opportunities!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
