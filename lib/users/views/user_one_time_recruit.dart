import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/user_sidedrawer.dart';

class OneTimeJob {
  final String title;
  final String company;
  final String appliedDate;
  final String location;
  final String duration;
  final String payout;
  String status;

  OneTimeJob({
    required this.title,
    required this.company,
    required this.appliedDate,
    required this.location,
    required this.duration,
    required this.payout,
    this.status = "Pending",
  });
}

class OneTimeRecruitment extends StatefulWidget {
  const OneTimeRecruitment({super.key});

  @override
  State<OneTimeRecruitment> createState() => _OneTimeRecruitmentState();
}

class _OneTimeRecruitmentState extends State<OneTimeRecruitment> {
  List<OneTimeJob> jobs = [
    OneTimeJob(
      title: "Event Promoter (2 Days)",
      company: "Eventify Pvt. Ltd.",
      appliedDate: "Oct 21, 2025",
      location: "Delhi, India",
      duration: "2 Days",
      payout: "₹3,000",
      status: "Pending",
    ),
    OneTimeJob(
      title: "Survey Field Assistant",
      company: "DataEdge Analytics",
      appliedDate: "Oct 15, 2025",
      location: "Remote",
      duration: "1 Week",
      payout: "₹5,000",
      status: "Accepted",
    ),
    OneTimeJob(
      title: "Photography Assistant",
      company: "LensCraft Studio",
      appliedDate: "Oct 10, 2025",
      location: "Pune, India",
      duration: "3 Days",
      payout: "₹4,500",
      status: "Rejected",
    ),
  ];

  void _acceptJob(int index) {
    setState(() {
      for (var j in jobs) {
        j.status = "Pending";
      }
      jobs[index].status = "Accepted";
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
                "My One-Time Jobs",
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
              child: jobs.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
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
                                  Icons.event_available_outlined,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      job.company,
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
                                          job.location,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Duration: ${job.duration}",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "Payout: ${job.payout}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Applied on ${job.appliedDate}",
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
                                            _getStatusIcon(job.status),
                                            color: _getStatusTextColor(
                                              job.status,
                                            ),
                                            size: 18,
                                          ),
                                          backgroundColor: _getStatusColor(
                                            job.status,
                                          ),
                                          label: Text(
                                            job.status,
                                            style: TextStyle(
                                              color: _getStatusTextColor(
                                                job.status,
                                              ),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        if (job.status == "Accepted")
                                          TextButton.icon(
                                            onPressed: () {
                                              // View details
                                            },
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
                                        else if (job.status == "Pending")
                                          TextButton.icon(
                                            onPressed: () {
                                              _acceptJob(index);
                                            },
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
            Icons.event_busy_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          const Text(
            "No One-Time Jobs Yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "You haven’t applied for any one-time work.\nFind quick short-term tasks now!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
