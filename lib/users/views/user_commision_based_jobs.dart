import 'package:flutter/material.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/user_sidedrawer.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class CommissionApplication {
  final String title;
  final String company;
  final String appliedDate;
  final String location;
  final String commissionRate;
  final String expectedLeads;
  String status;

  CommissionApplication({
    required this.title,
    required this.company,
    required this.appliedDate,
    required this.location,
    required this.commissionRate,
    required this.expectedLeads,
    this.status = "Pending",
  });
}

class CommissionJobs extends StatefulWidget {
  const CommissionJobs({super.key});

  @override
  State<CommissionJobs> createState() => _CommissionJobsState();
}

class _CommissionJobsState extends State<CommissionJobs> {
  List<CommissionApplication> applications = [
    CommissionApplication(
      title: "Sales Lead Generator",
      company: "Growthly Pvt. Ltd.",
      appliedDate: "Oct 22, 2025",
      location: "Remote",
      commissionRate: "12% per Sale",
      expectedLeads: "Target: 50+ Leads",
      status: "Pending",
    ),
    CommissionApplication(
      title: "Real Estate Lead Executive",
      company: "HomeKart Realty",
      appliedDate: "Oct 18, 2025",
      location: "Pune, India",
      commissionRate: "₹2000 per Lead",
      expectedLeads: "Target: 25 Leads",
      status: "Accepted",
    ),
    CommissionApplication(
      title: "Insurance Lead Promoter",
      company: "SecureLife Agency",
      appliedDate: "Oct 14, 2025",
      location: "Delhi, India",
      commissionRate: "8% per Sale",
      expectedLeads: "Target: 40 Leads",
      status: "Rejected",
    ),
  ];

  void _acceptJob(int index) {
    setState(() {
      for (var app in applications) {
        app.status = "Pending";
      }
      applications[index].status = "Accepted";
    });
  }

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
    return AppDrawerWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 800;

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 1,
              title: const Text(
                "My Commission Applications",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb
                    ? MediaQuery.of(context).size.width * 0.2
                    : 16,
                vertical: 20,
              ),
              child: applications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: applications.length,
                      itemBuilder: (context, index) {
                        final app = applications[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey.shade200,
                                child: Icon(
                                  Icons.trending_up_rounded,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Commission: ${app.commissionRate}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      app.expectedLeads,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13,
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
                                    const SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Chip(
                                          avatar: Icon(
                                            _getStatusIcon(app.status),
                                            color: _getStatusTextColor(
                                              app.status,
                                            ),
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
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.visibility_outlined,
                                              size: 18,
                                            ),
                                            label: const Text("View Details"),
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  AppColors.primary,
                                            ),
                                          )
                                        else if (app.status == "Pending")
                                          TextButton.icon(
                                            onPressed: () => _acceptJob(index),
                                            icon: const Icon(
                                              Icons.check_circle_outline,
                                              size: 18,
                                            ),
                                            label: const Text("Accept Job"),
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  AppColors.primary,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_down_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          const Text(
            "No Commission Applications Yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "You haven’t applied for any commission-based roles.\nExplore new sales and lead opportunities!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
