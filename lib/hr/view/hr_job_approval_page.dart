import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/view/drawer_dashboard/hr_sidebar.dart';

class JobApprovalPage extends StatefulWidget {
  final String title; // e.g. "Salary-based Jobs", "Projects", etc.

  const JobApprovalPage({super.key, required this.title});

  @override
  State<JobApprovalPage> createState() => _JobApprovalPageState();
}

class _JobApprovalPageState extends State<JobApprovalPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Example demo data
  final List<Map<String, String>> pendingJobs = [
    {"title": "Flutter Developer", "employer": "TechCorp"},
    {"title": "Sales Executive", "employer": "MarketPro"},
  ];

  final List<Map<String, String>> approvedJobs = [
    {"title": "Backend Engineer", "employer": "SoftNet"},
  ];

  final List<Map<String, String>> rejectedJobs = [
    {"title": "Data Analyst", "employer": "DataWorks"},
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  Widget _buildJobList(List<Map<String, String>> jobs) {
    if (jobs.isEmpty) {
      return const Center(
        child: Text(
          "No jobs found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child: Icon(Icons.work_outline, color: AppColors.primary),
            ),
            title: Text(
              job["title"] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text("Employer: ${job["employer"]}"),
            trailing: IconButton(
              icon: Icon(Icons.info_outline, color: AppColors.primary),
              onPressed: () {
                // TODO: Navigate to job detail page
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 2,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: "Pending"),
              Tab(text: "Approved"),
              Tab(text: "Rejected"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildJobList(pendingJobs),
            _buildJobList(approvedJobs),
            _buildJobList(rejectedJobs),
          ],
        ),
      ),
    );
  }
}
