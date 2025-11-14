import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';
import 'package:table_calendar/table_calendar.dart';

class SalaryBasedAttendancePage extends StatefulWidget {
  const SalaryBasedAttendancePage({super.key});

  @override
  State<SalaryBasedAttendancePage> createState() =>
      _SalaryBasedAttendancePageState();
}

class _SalaryBasedAttendancePageState extends State<SalaryBasedAttendancePage> {
  final List<Map<String, dynamic>> employees = [
    {
      "name": "Amit Sharma",
      "joiningDate": "10 Jan 2024",
      "jobTitle": "Software Developer",
      "isPresent": true,
    },
    {
      "name": "Priya Patel",
      "joiningDate": "25 Feb 2024",
      "jobTitle": "UI/UX Designer",
      "isPresent": true,
    },
    {
      "name": "Rahul Mehta",
      "joiningDate": "05 Mar 2024",
      "jobTitle": "QA Engineer",
      "isPresent": true,
    },
  ];

  void _markAttendance(int index, bool isPresent) {
    setState(() => employees[index]["isPresent"] = isPresent);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          "${employees[index]['name']} marked as ${isPresent ? 'Present' : 'Absent'}",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _viewHistory(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AttendanceHistoryPage(employeeName: name),
      ),
    );
  }

  void _submitAttendance() {
    final presentCount = employees.where((e) => e["isPresent"] == true).length;
    final absentCount = employees.length - presentCount;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          "Attendance submitted!\nPresent: $presentCount, Absent: $absentCount",
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              // ✅ AppBar inside Column, not Scaffold
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Salary-Based Employees Attendance",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 📅 Date Header + Submit Button
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Today: ${today.day}-${today.month}-${today.year}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: _submitAttendance,
                              icon: const Icon(Icons.send, size: 18),
                              label: const Text("Submit"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 👥 Employee List
                      Expanded(
                        child: ListView.builder(
                          itemCount: employees.length,
                          itemBuilder: (context, index) {
                            final emp = employees[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 26,
                                          backgroundImage: AssetImage(
                                            "assets/job_bgr.png",
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                emp["name"],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Joining Date: ${emp['joiningDate']}",
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                "Job: ${emp['jobTitle']}",
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              _viewHistory(emp["name"]),
                                          icon: const Icon(Icons.history),
                                          color: AppColors.primary,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () =>
                                              _markAttendance(index, true),
                                          icon: const Icon(
                                            Icons.check_circle,
                                            size: 18,
                                          ),
                                          label: const Text("Present"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: emp["isPresent"]
                                                ? Colors.green
                                                : Colors.grey.shade300,
                                            foregroundColor: emp["isPresent"]
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton.icon(
                                          onPressed: () =>
                                              _markAttendance(index, false),
                                          icon: const Icon(
                                            Icons.cancel,
                                            size: 18,
                                          ),
                                          label: const Text("Absent"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: !emp["isPresent"]
                                                ? Colors.redAccent
                                                : Colors.grey.shade300,
                                            foregroundColor: !emp["isPresent"]
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:jobshub/common/utils/AppColor.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:jobshub/employer/views/drawer_dashboard/employer_side_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:jobshub/common/utils/AppColor.dart';
// import 'package:table_calendar/table_calendar.dart';

class AttendanceHistoryPage extends StatefulWidget {
  final String employeeName;
  const AttendanceHistoryPage({super.key, required this.employeeName});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  late Map<DateTime, String> attendanceData;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();
    attendanceData = {
      DateTime(2025, 10, 17): "Present",
      DateTime(2025, 10, 16): "Absent",
      DateTime(2025, 10, 15): "Present",
      DateTime(2025, 10, 14): "Present",
      DateTime(2025, 10, 13): "Absent",
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // final bool isWeb = constraints.maxWidth >= 900;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            automaticallyImplyLeading: true, // ✅ hide menu on web
            title: Text(
              "${widget.employeeName} - Attendance",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),

          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2026, 12, 31),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                      focusedDay = focused;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, _) {
                      final status =
                          attendanceData[DateTime(
                            day.year,
                            day.month,
                            day.day,
                          )];
                      Color? bgColor;
                      if (status == "Present") {
                        bgColor = Colors.green.shade100;
                      } else if (status == "Absent") {
                        bgColor = Colors.red.shade100;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                            color: status == "Absent"
                                ? Colors.redAccent
                                : Colors.black87,
                            fontWeight: status != null
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (selectedDay != null) _buildSelectedDayInfo(selectedDay!),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedDayInfo(DateTime day) {
    final status = attendanceData[DateTime(day.year, day.month, day.day)];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Date: ${day.day}-${day.month}-${day.year}",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            status ?? "No Record",
            style: TextStyle(
              color: status == "Present"
                  ? Colors.green
                  : status == "Absent"
                  ? Colors.redAccent
                  : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
