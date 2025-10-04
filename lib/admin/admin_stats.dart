import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

import 'admin_sidebar.dart'; // <-- Use common sidebar

class AdminStats extends StatefulWidget {
  const AdminStats({super.key});

  @override
  State<AdminStats> createState() => _AdminStatsState();
}

class _AdminStatsState extends State<AdminStats> {
  int touchedIndex = -1;

  final List<Map<String, dynamic>> jobStatusData = [
    {'title': 'Approved', 'value': 60, 'color': Colors.green},
    {'title': 'Rejected', 'value': 20, 'color': Colors.red},
    {'title': 'Pending', 'value': 20, 'color': Colors.orange},
  ];

  final List<Map<String, dynamic>> summaryData = [
    {'title': 'Total Work', 'value': 100, 'icon': Icons.work, 'color': Colors.blue},
    {'title': 'Approved Work', 'value': 60, 'icon': Icons.check_circle, 'color': Colors.green},
    {'title': 'Rejected Work', 'value': 20, 'icon': Icons.cancel, 'color': Colors.red},
    {'title': 'KYC Verified', 'value': 75, 'icon': Icons.verified, 'color': Colors.purple},
    {'title': 'Total Users', 'value': 200, 'icon': Icons.people, 'color': Colors.teal},
  ];

  Widget _buildDashboardContent(bool isMobile, int crossAxisCount) {
  // For Web: show left cards, right pie chart
  if (!isMobile) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Left: Cards ----------
          Expanded(
            flex: 2,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: summaryData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 3.0,
              ),
              itemBuilder: (context, index) {
                final data = summaryData[index];
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: data['color'].withOpacity(0.5), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: data['color'],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(data['icon'], color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${data['value']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: data['color'],
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

          const SizedBox(width: 40),

          // ---------- Right: Pie Chart ----------
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 400,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 90,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = response.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sections: List.generate(jobStatusData.length, (index) {
                    final isTouched = index == touchedIndex;
                    final double radius = isTouched ? 70 : 60;
                    return PieChartSectionData(
                      color: jobStatusData[index]['color'],
                      value: jobStatusData[index]['value'].toDouble(),
                      title: isTouched
                          ? '${jobStatusData[index]['value']} Jobs'
                          : jobStatusData[index]['title'],
                      radius: radius,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Mobile layout ----------
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = response.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: List.generate(jobStatusData.length, (index) {
                final isTouched = index == touchedIndex;
                final double radius = isTouched ? 60 : 50;
                return PieChartSectionData(
                  color: jobStatusData[index]['color'],
                  value: jobStatusData[index]['value'].toDouble(),
                  title: jobStatusData[index]['title'],
                  radius: radius,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: summaryData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemBuilder: (context, index) {
            final data = summaryData[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: data['color'],
                      child: Icon(data['icon'], color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(data['title'],
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${data['value']}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: data['color'])),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isWeb = constraints.maxWidth > 900;
      bool isMobile = constraints.maxWidth < 800;
      int crossAxisCount = isMobile ? 2 : (constraints.maxWidth < 1200 ? 3 : 4);

      return Scaffold(
        appBar: isWeb
            ? null
            : AppBar(
                title: const Text('Admin Stats',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: AppColors.primary,
              ),
        drawer: isWeb
            ? null
            : const AdminSidebar(selectedPage: "Chart"),
        body: Row(
          children: [
            if (isWeb)
              Container(
                width: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(2, 0),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: const AdminSidebar(selectedPage: "Chart", isWeb: true),
              ),
            Expanded(child: _buildDashboardContent(isMobile, crossAxisCount)),
          ],
        ),
      );
    });
  }
}
