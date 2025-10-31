import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math';

class EmployeeAttendanceDetailPage extends StatefulWidget {
  final String employeeName;
  final DateTime joiningDate;

  const EmployeeAttendanceDetailPage({
    super.key,
    required this.employeeName,
    required this.joiningDate,
  });

  @override
  State<EmployeeAttendanceDetailPage> createState() =>
      _EmployeeAttendanceDetailPageState();
}

class _EmployeeAttendanceDetailPageState
    extends State<EmployeeAttendanceDetailPage> {
  late Map<DateTime, bool> attendanceData; // true = present, false = absent
  late DateTime firstDay;
  late DateTime lastDay;
  late DateTime focusedDay;

  @override
  void initState() {
    super.initState();
    firstDay = widget.joiningDate;
    lastDay = DateTime.now();
    focusedDay = lastDay;

    // Mock attendance data (you can later replace this with API response)
    attendanceData = {};
    DateTime date = firstDay;
    final random = Random();

    while (date.isBefore(lastDay) || date.isAtSameMomentAs(lastDay)) {
      attendanceData[date] = random.nextBool(); // Randomly mark present/absent
      date = date.add(const Duration(days: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.employeeName}'s Attendance"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TableCalendar(
          focusedDay: focusedDay,
          firstDay: firstDay,
          lastDay: lastDay,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final isPresent = attendanceData[day];
              if (isPresent == null) return null;

              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPresent ? Colors.green[100] : Colors.red[100],
                ),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: isPresent ? Colors.green[800] : Colors.red[800],
                      fontWeight: FontWeight.bold,
                    ),
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
