import 'package:flutter/material.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_side_bar.dart';
import '../../common/utils/AppColor.dart';

class EmployeeListPage extends StatelessWidget {
  final String pageTitle;
  final List<Map<String, String>> employees;

  const EmployeeListPage({
    super.key,
    required this.pageTitle,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(pageTitle),
      //   backgroundColor: AppColors.primary,
      // ),
      drawer: EmployerSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: employees.isEmpty
            ? const Center(
                child: Text(
                  "No employees found.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.separated(
                itemCount: employees.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final emp = employees[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: const Icon(Icons.person, color: Colors.black87),
                      ),
                      title: Text(
                        emp["name"] ?? "Unknown",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Joining Date: ${emp["joiningDate"] ?? "N/A"}",
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            "Title: ${emp["jobTitle"] ?? "N/A"}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Colors.black54,
                      ),
                      onTap: () {
                        // You can navigate to employee details page later
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
