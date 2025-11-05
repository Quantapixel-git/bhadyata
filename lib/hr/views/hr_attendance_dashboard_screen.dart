import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_side_bar.dart';

class LeaveRequest {
  final String employeeName;
  final String leaveType;
  final String reason;
  String status;
  String? hrReview;

  LeaveRequest({
    required this.employeeName,
    required this.leaveType,
    required this.reason,
    this.status = "Pending",
    this.hrReview,
  });
}

class HrAttendanceDashboardScreen extends StatefulWidget {
  const HrAttendanceDashboardScreen({super.key});

  @override
  _HrAttendanceDashboardScreenState createState() =>
      _HrAttendanceDashboardScreenState();
}

class _HrAttendanceDashboardScreenState
    extends State<HrAttendanceDashboardScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<String> employees = ["John Doe", "Jane Smith", "Alice Johnson"];
  String selectedEmployee = "John Doe";

  Map<String, Map<DateTime, String>> allAttendance = {};

  List<LeaveRequest> leaveRequests = [
    LeaveRequest(employeeName: "John Doe", leaveType: "Sick", reason: "Fever"),
    LeaveRequest(
        employeeName: "Jane Smith", leaveType: "Casual", reason: "Personal"),
    LeaveRequest(
        employeeName: "Alice Johnson", leaveType: "Sick", reason: "Flu"),
  ];

  @override
  void initState() {
    super.initState();
    for (var emp in employees) {
      allAttendance[emp] = {};
    }
  }

  void _markAttendance(String status) {
    setState(() {
      allAttendance[selectedEmployee]?[_selectedDay] = status;
    });
  }

  String _getStatusForDay(DateTime day) {
    return allAttendance[selectedEmployee]?[DateTime(day.year, day.month, day.day)] ?? '';
  }

  int get totalPresent =>
      allAttendance[selectedEmployee]!.values.where((s) => s == "Present").length;

  int get totalAbsent =>
      allAttendance[selectedEmployee]!.values.where((s) => s == "Absent").length;

  void _reviewLeave(LeaveRequest request) {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Review Leave for ${request.employeeName}"),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: "Write review/comments"),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    request.status = "Approved";
                    request.hrReview = _controller.text;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Approve")),
            TextButton(
                onPressed: () {
                  setState(() {
                    request.status = "Rejected";
                    request.hrReview = _controller.text;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Reject")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 900;

    Widget mainContent = SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          DropdownButton<String>(
            value: selectedEmployee,
            items: employees
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedEmployee = val!;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Present: $totalPresent",
                  style: const TextStyle(fontSize: 16, color: Colors.green)),
              Text("Absent: $totalAbsent",
                  style: const TextStyle(fontSize: 16, color: Colors.red)),
            ],
          ),
          const SizedBox(height: 12),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final status = _getStatusForDay(day);
                Color? bgColor;
                if (status == "Present") bgColor = Colors.green[300];
                if (status == "Absent") bgColor = Colors.red[300];
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: bgColor ?? Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
                  child: Text('${day.day}'),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => _markAttendance("Present"),
                  child: const Text("Present")),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () => _markAttendance("Absent"),
                  child: const Text("Absent")),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          const Text("Leave Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leaveRequests.length,
            itemBuilder: (context, index) {
              final request = leaveRequests[index];
              return Card(
                margin: const EdgeInsets.all(6),
                child: ListTile(
                  title: Text(request.employeeName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Type: ${request.leaveType}"),
                      Text("Reason: ${request.reason}"),
                      if (request.hrReview != null)
                        Text("HR Review: ${request.hrReview}"),
                      Text("Status: ${request.status}",
                          style: TextStyle(
                              color: request.status == "Approved"
                                  ? Colors.green
                                  : request.status == "Rejected"
                                      ? Colors.red
                                      : Colors.orange)),
                    ],
                  ),
                  trailing: request.status == "Pending"
                      ? IconButton(
                          icon: const Icon(Icons.rate_review),
                          onPressed: () => _reviewLeave(request),
                        )
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );

    if (isWeb) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Attendance Dashboard",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  backgroundColor: AppColors.primary,
                ),
                body: mainContent,
              ),
            ),
          ],
        ),
      );
    } else {
      // ---- Mobile Layout with Drawer ----
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Attendance Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
                  backgroundColor: AppColors.primary,

        ),
        drawer:  HrSidebar(),
        body: mainContent,
      );
    }
  }
}
