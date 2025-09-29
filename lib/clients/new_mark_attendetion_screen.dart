import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobshub/utils/AppColor.dart';

class Candidate {
  final String name;
  Map<String, String> attendance = {}; // 'P' = Present, 'A' = Absent
  Candidate(this.name);
}

class ClientMonthlyAttendanceDashboard extends StatefulWidget {
  const ClientMonthlyAttendanceDashboard({super.key});

  @override
  State<ClientMonthlyAttendanceDashboard> createState() => _ClientMonthlyAttendanceDashboardState();
}

class _ClientMonthlyAttendanceDashboardState extends State<ClientMonthlyAttendanceDashboard> {
  DateTime selectedMonth = DateTime.now();
  final List<Candidate> candidates = [
    Candidate('John Doe'),
    Candidate('Jane Smith'),
    Candidate('Alice Johnson'),
    Candidate('Bob Marley'),
    Candidate('Sarah Connor'),
  ];

  Candidate? selectedCandidate; // filter by candidate

  late ScrollController headerController;
  late ScrollController bodyController;

  @override
  void initState() {
    super.initState();
    headerController = ScrollController();
    bodyController = ScrollController();

    // Sync horizontal scrolling
    headerController.addListener(() {
      if (bodyController.offset != headerController.offset) {
        bodyController.jumpTo(headerController.offset);
      }
    });
    bodyController.addListener(() {
      if (headerController.offset != bodyController.offset) {
        headerController.jumpTo(bodyController.offset);
      }
    });
  }

  @override
  void dispose() {
    headerController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  List<DateTime> getMonthDays() {
    final daysInMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    return List.generate(daysInMonth, (index) => DateTime(selectedMonth.year, selectedMonth.month, index + 1));
  }

  void toggleAttendance(Candidate candidate, DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    setState(() {
      final current = candidate.attendance[key] ?? 'A';
      candidate.attendance[key] = current == 'P' ? 'A' : 'P';
    });
  }

  int countPresent(Candidate candidate) {
    return candidate.attendance.values.where((v) => v == 'P').length;
  }

  @override
  Widget build(BuildContext context) {
    final monthDays = getMonthDays();
    final displayCandidates = selectedCandidate != null ? [selectedCandidate!] : candidates;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Attendance'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // Candidate Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Candidate>(
              hint: const Text("Filter by Candidate"),
              value: selectedCandidate,
              onChanged: (Candidate? value) {
                setState(() {
                  selectedCandidate = value;
                });
              },
              items: [null, ...candidates].map((candidate) {
                return DropdownMenuItem<Candidate>(
                  value: candidate,
                  child: Text(candidate?.name ?? 'All Candidates'),
                );
              }).toList(),
              isExpanded: true,
            ),
          ),

          // Dates Header (Horizontally Scrollable)
          Container(
            color: Colors.deepPurple.shade100,
            height: 50,
            child: Row(
              children: [
                Container(
                  width: 120,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Text('Candidate', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: headerController,
                    child: Row(
                      children: [
                        ...monthDays.map((d) {
                          return Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              DateFormat('d').format(d),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                        Container(
                          width: 60,
                          height: 50,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Attendance Rows
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: displayCandidates.asMap().entries.map((entry) {
                  final index = entry.key;
                  final candidate = entry.value;
                  final isEven = index % 2 == 0;

                  return Container(
                    color: isEven ? Colors.grey.shade100 : Colors.white,
                    height: 50,
                    child: Row(
                      children: [
                        // Sticky Candidate Name
                        Container(
                          width: 120,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(candidate.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        // Attendance Cells
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: bodyController,
                            child: Row(
                              children: [
                                ...monthDays.map((d) {
                                  final key = DateFormat('yyyy-MM-dd').format(d);
                                  final status = candidate.attendance[key] ?? 'A';
                                  return GestureDetector(
                                    onTap: () => toggleAttendance(candidate, d),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      margin: const EdgeInsets.all(2),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: status == 'P' ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        status == 'P' ? Icons.check : Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  );
                                }),
                                // Total Present
                                Container(
                                  width: 60,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text('${countPresent(candidate)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save,color: AppColors.white,),
              label: const Text('Save Attendance',style:TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Monthly attendance saved!',)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
