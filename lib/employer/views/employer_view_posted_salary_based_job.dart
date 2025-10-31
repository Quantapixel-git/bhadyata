import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/drawer_dashboard/employer_side_bar.dart';

class ViewPostedJobsPage extends StatelessWidget {
  const ViewPostedJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.white, // ✅ White menu icon for mobile
                ),
                automaticallyImplyLeading:
                    !isWeb, // ✅ Drawer icon visible only on mobile
                title: const Text(
                  "View Posted Jobs",
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
                  JobsList(status: "Pending"),
                  JobsList(status: "Rejected"),
                  JobsList(status: "Approved"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class JobsList extends StatelessWidget {
  final String status;
  const JobsList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> jobsData = {
      "Pending": [
        {
          "title": "Flutter Developer",
          "type": "Full-time",
          "salary": "₹40,000",
          "location": "New Delhi",
          "date": "20 Oct 2025",
        },
        {
          "title": "Marketing Executive",
          "type": "Part-time",
          "salary": "₹20,000",
          "location": "Gurugram",
          "date": "19 Oct 2025",
        },
      ],
      "Rejected": [
        {
          "title": "PHP Developer",
          "type": "Full-time",
          "salary": "₹35,000",
          "location": "Noida",
          "date": "18 Oct 2025",
        },
        {
          "title": "Content Writer",
          "type": "Freelance",
          "salary": "₹12,000",
          "location": "Remote",
          "date": "16 Oct 2025",
        },
      ],
      "Approved": [
        {
          "title": "Backend Developer (Laravel)",
          "type": "Full-time",
          "salary": "₹45,000",
          "location": "Gurugram",
          "date": "15 Oct 2025",
        },
        {
          "title": "UI/UX Designer",
          "type": "Internship",
          "salary": "₹15,000",
          "location": "Noida",
          "date": "14 Oct 2025",
        },
        {
          "title": "HR Manager",
          "type": "Full-time",
          "salary": "₹50,000",
          "location": "New Delhi",
          "date": "12 Oct 2025",
        },
      ],
    };

    final List<Map<String, String>> jobs = jobsData[status]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
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
                    job["title"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("${job["type"]} | ${job["salary"]}"),
                      const SizedBox(height: 2),
                      Text("Location: ${job["location"]}"),
                      const SizedBox(height: 2),
                      Text("Posted on: ${job["date"]}"),
                      const SizedBox(height: 4),
                      Text(
                        "Status: $status",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: status == "Approved"
                              ? Colors.green
                              : status == "Rejected"
                              ? Colors.red
                              : Colors.orange,
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
                      // TODO: Navigate to job detail page
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
