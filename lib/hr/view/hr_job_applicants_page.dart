import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/view/drawer_dashboard/hr_sidebar.dart';

class JobApplicantsPage extends StatefulWidget {
  final String title; // e.g. "Salary-based Jobs"

  const JobApplicantsPage({super.key, required this.title});

  @override
  State<JobApplicantsPage> createState() => _JobApplicantsPageState();
}

class _JobApplicantsPageState extends State<JobApplicantsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Demo data for each tab (replace later with API calls)
  final List<Map<String, String>> pendingApplicants = [
    {"name": "John Doe", "job": "Flutter Developer"},
    {"name": "Emily Smith", "job": "Sales Associate"},
  ];

  final List<Map<String, String>> approvedApplicants = [
    {"name": "Michael Brown", "job": "Backend Engineer"},
  ];

  final List<Map<String, String>> rejectedApplicants = [
    {"name": "Lisa Adams", "job": "Graphic Designer"},
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  Widget _buildApplicantList(List<Map<String, String>> applicants) {
    if (applicants.isEmpty) {
      return const Center(
        child: Text(
          "No applicants found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: applicants.length,
      itemBuilder: (context, index) {
        final applicant = applicants[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child: Icon(Icons.person, color: AppColors.primary),
            ),
            title: Text(
              applicant["name"] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text("Applied for: ${applicant["job"]}"),
            trailing: IconButton(
              icon: Icon(Icons.info_outline, color: AppColors.primary),
              tooltip: 'View Details',
              onPressed: () {
                // TODO: Navigate to applicant detail page
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
            _buildApplicantList(pendingApplicants),
            _buildApplicantList(approvedApplicants),
            _buildApplicantList(rejectedApplicants),
          ],
        ),
      ),
    );
  }
}
