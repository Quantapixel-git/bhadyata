import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/user_sidedrawer.dart';

class AvailableProject {
  final String title;
  final String company;
  final String location;
  final String jobType;
  final String description;
  final String salaryOrAmount; // can be monthly or fixed
  final String paymentType; // "Monthly" or "Fixed"
  bool applied;

  AvailableProject({
    required this.title,
    required this.company,
    required this.location,
    required this.jobType,
    required this.description,
    required this.salaryOrAmount,
    required this.paymentType,
    this.applied = false,
  });
}

class AllProjectsPage extends StatefulWidget {
  const AllProjectsPage({super.key});

  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  List<AvailableProject> projects = [
    AvailableProject(
      title: "E-commerce Flutter App Development",
      company: "TechNova Pvt. Ltd.",
      location: "Remote",
      jobType: "Contract",
      description:
          "Develop a complete Flutter app for an e-commerce platform including payment, login, and order tracking.",
      salaryOrAmount: "₹1,50,000",
      paymentType: "Fixed",
    ),
    AvailableProject(
      title: "Social Media Dashboard Design",
      company: "PixelCraft Studio",
      location: "Hyderabad, India",
      jobType: "Hybrid",
      description:
          "UI/UX dashboard design for a new social media management platform.",
      salaryOrAmount: "₹60,000",
      paymentType: "Monthly",
    ),
    AvailableProject(
      title: "Node.js Backend Development",
      company: "CodeWorks",
      location: "Mumbai, India",
      jobType: "Remote",
      description:
          "Set up backend APIs for mobile app authentication and data management using Node.js and MongoDB.",
      salaryOrAmount: "₹90,000",
      paymentType: "Monthly",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Available Projects",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Row(
        children: [
          if (isWeb) const AppDrawer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: projects.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final proj = projects[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🔹 Project Header
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: 28,
                                      child: Icon(
                                        Icons.work_outline,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            proj.title,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            proj.company,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // 🔹 Job Info
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(proj.location,
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                    const SizedBox(width: 14),
                                    const Icon(Icons.work_outline,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(proj.jobType,
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // 🔹 Description
                                Text(
                                  proj.description,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // 🔹 Payment Info
                                Text(
                                  proj.paymentType == "Fixed"
                                      ? "Fixed Price: ${proj.salaryOrAmount}"
                                      : "Salary: ${proj.salaryOrAmount} / month",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // 🔹 Apply Button
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: proj.applied
                                          ? Colors.grey.shade400
                                          : AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                    onPressed: proj.applied
                                        ? null
                                        : () {
                                            setState(() {
                                              proj.applied = true;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Applied successfully for '${proj.title}'"),
                                                backgroundColor:
                                                    AppColors.primary,
                                              ),
                                            );
                                          },
                                    icon: Icon(
                                      proj.applied
                                          ? Icons.check_circle_outline
                                          : Icons.send_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      proj.applied ? "Applied" : "Apply Now",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
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
          Icon(Icons.work_off_outlined,
              size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            "No Projects Available",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "New project opportunities will appear here.\nCheck back later!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
