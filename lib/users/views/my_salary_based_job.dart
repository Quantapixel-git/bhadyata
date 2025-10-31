// import 'package:flutter/material.dart';
// import 'package:jobshub/users/views/bottomnav_drawer_dashboard/user_sidedrawer.dart';
// import 'package:jobshub/common/utils/AppColor.dart';

// class JobApplication {
//   final String title;
//   final String company;
//   final String appliedDate;
//   final String location;
//   final String jobType;
//   final String salary; // Monthly Salary
//   String status; // Pending / Accepted / Rejected

//   JobApplication({
//     required this.title,
//     required this.company,
//     required this.appliedDate,
//     required this.location,
//     required this.jobType,
//     required this.salary,
//     this.status = "Pending",
//   });
// }

// class SalaryJobs extends StatefulWidget {
//   const SalaryJobs({super.key});

//   @override
//   State<SalaryJobs> createState() => _SalaryJobsState();
// }

// class _SalaryJobsState extends State<SalaryJobs> {
//   List<JobApplication> jobApplications = [
//     JobApplication(
//       title: "Flutter Developer",
//       company: "TechNova Pvt. Ltd.",
//       appliedDate: "Oct 20, 2025",
//       location: "Remote",
//       jobType: "Full-Time",
//       salary: "₹60,000 / month",
//       status: "Pending",
//     ),
//     JobApplication(
//       title: "UI/UX Designer",
//       company: "PixelCraft Studio",
//       appliedDate: "Oct 15, 2025",
//       location: "Bangalore, India",
//       jobType: "Hybrid",
//       salary: "₹55,000 / month",
//       status: "Accepted",
//     ),
//     JobApplication(
//       title: "Backend Engineer",
//       company: "CodeWorks",
//       appliedDate: "Oct 10, 2025",
//       location: "Mumbai, India",
//       jobType: "Remote",
//       salary: "₹65,000 / month",
//       status: "Rejected",
//     ),
//   ];

//   // 🟢 Allow only one job to be accepted
//   void _acceptJob(int index) {
//     setState(() {
//       for (var job in jobApplications) {
//         job.status = "Pending";
//       }
//       jobApplications[index].status = "Accepted";
//     });
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Accepted":
//         return Colors.green.shade100;
//       case "Rejected":
//         return Colors.red.shade100;
//       default:
//         return Colors.orange.shade100;
//     }
//   }

//   Color _getStatusTextColor(String status) {
//     switch (status) {
//       case "Accepted":
//         return Colors.green.shade800;
//       case "Rejected":
//         return Colors.red.shade800;
//       default:
//         return Colors.orange.shade800;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case "Accepted":
//         return Icons.check_circle_outline;
//       case "Rejected":
//         return Icons.cancel_outlined;
//       default:
//         return Icons.hourglass_empty_outlined;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isWeb = MediaQuery.of(context).size.width > 800;

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.black),
//         title: const Text(
//           "My Job Applications",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         elevation: 0,
//       ),
//       body: Row(
//         children: [
//           if (isWeb) const AppDrawer(),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: jobApplications.isEmpty
//                   ? _buildEmptyState()
//                   : ListView.builder(
//                       itemCount: jobApplications.length,
//                       itemBuilder: (context, index) {
//                         final job = jobApplications[index];
//                         return Container(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // 🧩 Company Icon
//                                 CircleAvatar(
//                                   radius: 28,
//                                   backgroundColor: Colors.grey.shade200,
//                                   child: Icon(
//                                     Icons.work_outline_rounded,
//                                     color: AppColors.primary,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),

//                                 // 🧱 Job Info
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         job.title,
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         job.company,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.black54,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),

//                                       Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.location_on_outlined,
//                                             size: 16,
//                                             color: Colors.grey,
//                                           ),
//                                           const SizedBox(width: 4),
//                                           Text(
//                                             job.location,
//                                             style: const TextStyle(
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                           const SizedBox(width: 16),
//                                           const Icon(
//                                             Icons.work_history_outlined,
//                                             size: 16,
//                                             color: Colors.grey,
//                                           ),
//                                           const SizedBox(width: 4),
//                                           Text(
//                                             job.jobType,
//                                             style: const TextStyle(
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 8),

//                                       Text(
//                                         "Salary: ${job.salary}",
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.black87,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         "Applied on ${job.appliedDate}",
//                                         style: const TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 13,
//                                         ),
//                                       ),

//                                       const SizedBox(height: 8),

//                                       Row(
//                                         children: [
//                                           Chip(
//                                             avatar: Icon(
//                                               _getStatusIcon(job.status),
//                                               color:
//                                                   _getStatusTextColor(job.status),
//                                               size: 18,
//                                             ),
//                                             backgroundColor:
//                                                 _getStatusColor(job.status),
//                                             label: Text(
//                                               job.status,
//                                               style: TextStyle(
//                                                 color:
//                                                     _getStatusTextColor(job.status),
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 10),
//                                           if (job.status == "Accepted")
//                                             TextButton.icon(
//                                               onPressed: () {
//                                                 // Open job details page
//                                               },
//                                               icon: const Icon(
//                                                 Icons.visibility_outlined,
//                                                 size: 18,
//                                               ),
//                                               label: const Text("View Details"),
//                                               style: TextButton.styleFrom(
//                                                 foregroundColor:
//                                                     AppColors.primary,
//                                               ),
//                                             )
//                                           else if (job.status == "Pending")
//                                             TextButton.icon(
//                                               onPressed: () {
//                                                 _acceptJob(index);
//                                               },
//                                               icon: const Icon(
//                                                 Icons.check_circle_outline,
//                                                 size: 18,
//                                               ),
//                                               label: const Text("Accept Job"),
//                                               style: TextButton.styleFrom(
//                                                 foregroundColor:
//                                                     AppColors.primary,
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.folder_off_outlined,
//             size: 80,
//             color: Colors.grey.shade400,
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             "No Job Applications Yet",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "You haven’t applied to any jobs yet.\nStart applying to new opportunities!",
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/user_sidedrawer.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class JobApplication {
  final String title;
  final String company;
  final String appliedDate;
  final String location;
  final String jobType;
  final String salary;
  String status;

  JobApplication({
    required this.title,
    required this.company,
    required this.appliedDate,
    required this.location,
    required this.jobType,
    required this.salary,
    this.status = "Pending",
  });
}

class SalaryJobs extends StatefulWidget {
  const SalaryJobs({super.key});

  @override
  State<SalaryJobs> createState() => _SalaryJobsState();
}

class _SalaryJobsState extends State<SalaryJobs> {
  List<JobApplication> jobApplications = [
    JobApplication(
      title: "Flutter Developer",
      company: "TechNova Pvt. Ltd.",
      appliedDate: "Oct 20, 2025",
      location: "Remote",
      jobType: "Full-Time",
      salary: "₹60,000 / month",
      status: "Pending",
    ),
    JobApplication(
      title: "UI/UX Designer",
      company: "PixelCraft Studio",
      appliedDate: "Oct 15, 2025",
      location: "Bangalore, India",
      jobType: "Hybrid",
      salary: "₹55,000 / month",
      status: "Accepted",
    ),
    JobApplication(
      title: "Backend Engineer",
      company: "CodeWorks",
      appliedDate: "Oct 10, 2025",
      location: "Mumbai, India",
      jobType: "Remote",
      salary: "₹65,000 / month",
      status: "Rejected",
    ),
  ];

  void _acceptJob(int index) {
    setState(() {
      for (var job in jobApplications) {
        job.status = "Pending";
      }
      jobApplications[index].status = "Accepted";
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
                "My Job Applications",
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
              child: jobApplications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: jobApplications.length,
                      itemBuilder: (context, index) {
                        final job = jobApplications[index];
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
                              // 🧩 Company Icon
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey.shade200,
                                child: Icon(
                                  Icons.work_outline_rounded,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 16),

                              // 🧱 Job Info
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
                                        const SizedBox(width: 16),
                                        const Icon(
                                          Icons.work_history_outlined,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          job.jobType,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    Text(
                                      "Salary: ${job.salary}",
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

                                    // 🟢 Status & Actions
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
                                              // Navigate to job details page
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
            Icons.folder_off_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          const Text(
            "No Job Applications Yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "You haven’t applied to any jobs yet.\nStart applying to new opportunities!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
