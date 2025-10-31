import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/views/drawer_dashboard/hr_sidebar.dart';
import 'package:jobshub/hr/views/hr_employee_attendance_detail_page.dart';

class EmployeesAttendancePage extends StatelessWidget {
  const EmployeesAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> employees = [
      {
        "id": 1,
        "name": "John Doe",
        "designation": "Flutter Developer",
        "joiningDate": DateTime(2024, 6, 10),
      },
      {
        "id": 2,
        "name": "Sarah Smith",
        "designation": "UI/UX Designer",
        "joiningDate": DateTime(2024, 8, 5),
      },
      {
        "id": 3,
        "name": "Michael Johnson",
        "designation": "Backend Developer",
        "joiningDate": DateTime(2024, 9, 1),
      },
    ];

    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Employees Attendance",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 2,
        ),
        drawer: HrSidebar(),
        body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
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
                  employee["name"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(employee["designation"]),
                trailing: IconButton(
                  icon: Icon(Icons.remove_red_eye, color: AppColors.primary),
                  tooltip: 'View Attendance',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeAttendanceDetailPage(
                          employeeName: employee["name"],
                          joiningDate: employee["joiningDate"],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
