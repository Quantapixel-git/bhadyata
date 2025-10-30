import 'package:flutter/material.dart';
import 'package:jobshub/users/view/user_leave_request.dart';

// ------------------ Attendance Model ------------------
class Attendance {
  final DateTime date;
  final bool isPresent;

  Attendance({required this.date, this.isPresent = false});
}

// ------------------ Employee Attendance Screen ------------------
class EmployeeAttendanceScreen extends StatefulWidget {
  final String employeeName;
  final DateTime joiningDate;
  final WorkAssignment work;

  const EmployeeAttendanceScreen({
    super.key,
    required this.employeeName,
    required this.joiningDate,
    required this.work,
  });

  @override
  State<EmployeeAttendanceScreen> createState() =>
      _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen> {
  final Map<String, bool> attendanceMap = {};
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now();
    _generateAttendance();
  }

  // Generate attendance from joining date till today
  void _generateAttendance() {
    DateTime current = widget.joiningDate;
    DateTime today = DateTime.now();

    while (!current.isAfter(today)) {
      final key =
          "${current.year}-${current.month.toString().padLeft(2, '0')}-${current.day.toString().padLeft(2, '0')}";
      attendanceMap[key] = _getRandomAttendance(current);
      current = current.add(const Duration(days: 1));
    }
  }

  bool _getRandomAttendance(DateTime date) {
    if (date.weekday == DateTime.sunday) return false; // Sunday off
    return date.day % 7 != 0; // Random absents
  }

  @override
  Widget build(BuildContext context) {
    final work = widget.work;
    final isSalaryBased = work.employmentType.toLowerCase().contains("salary");

    if (!isSalaryBased) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Attendance",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                "Attendance records are available only\nfor salary-based employees.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ Calendar Month Days
    final daysInMonth = DateUtils.getDaysInMonth(
      selectedMonth.year,
      selectedMonth.month,
    );
    final firstWeekday = DateTime(
      selectedMonth.year,
      selectedMonth.month,
      1,
    ).weekday;

    final List<Widget> dayTiles = [];

    // Empty slots before the 1st day
    for (int i = 1; i < firstWeekday; i++) {
      dayTiles.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(
        selectedMonth.year,
        selectedMonth.month,
        day,
      );
      final key =
          "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
      final isPresent = attendanceMap[key] ?? false;

      dayTiles.add(
        Container(
          decoration: BoxDecoration(
            color: isPresent
                ? Colors.green.withOpacity(0.15)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isPresent ? Colors.green : Colors.redAccent,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isPresent ? Colors.green : Colors.redAccent,
                  fontSize: 16,
                ),
              ),
              Icon(
                isPresent ? Icons.check_circle : Icons.cancel,
                color: isPresent ? Colors.green : Colors.redAccent,
                size: 16,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Attendance",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Month Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month - 1,
                      );
                    });
                  },
                ),
                Text(
                  "${_getMonthName(selectedMonth.month)} ${selectedMonth.year}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 🔹 Weekday Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Mon", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Tue", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Wed", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Thu", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Fri", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Sat", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Sun", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 8),

            // 🔹 Calendar Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                children: dayTiles,
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem(Colors.green, "Present"),
                const SizedBox(width: 14),
                _legendItem(Colors.redAccent, "Absent"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  String _getMonthName(int month) {
    const names = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return names[month - 1];
  }
}
