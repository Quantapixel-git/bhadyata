import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/drawer_dashboard/employer_side_bar.dart';
// import 'package:jobshub/employer/view/drawer_dashboard/employer_dashboard_wrapper.dart';

class LeaveRequestsPage extends StatelessWidget {
  const LeaveRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployerDashboardWrapper(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Leave Requests",
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
                Tab(text: "Approved"),
                Tab(text: "Rejected"),
              ],
            ),
          ),
          drawer: EmployerSidebar(),
          body: const TabBarView(
            children: [
              LeaveListTab(status: "Pending"),
              LeaveListTab(status: "Approved"),
              LeaveListTab(status: "Rejected"),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaveListTab extends StatelessWidget {
  final String status;
  const LeaveListTab({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // Dummy leave data (replace with API data later)
    final List<Map<String, String>> leaves = [
      {"name": "John Doe", "date": "20-22 Oct", "reason": "Medical Leave"},
      {"name": "Priya Sharma", "date": "25 Oct", "reason": "Personal Work"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: leaves.length,
      itemBuilder: (context, index) {
        final item = leaves[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(Icons.person, color: AppColors.primary),
            ),
            title: Text(
              item["name"]!,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            subtitle: Text(
              "${item["date"]} • ${item["reason"]}",
              style: const TextStyle(fontSize: 13.5, color: Colors.black87),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: status == "Pending"
                    ? Colors.orange.shade100
                    : status == "Approved"
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: status == "Pending"
                      ? Colors.orange
                      : status == "Approved"
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
