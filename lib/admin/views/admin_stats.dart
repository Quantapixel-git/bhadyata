import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';

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
    {
      'title': 'Total Work',
      'value': 100,
      'icon': Icons.work,
      'color': Colors.blue,
    },
    {
      'title': 'Approved Work',
      'value': 60,
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'title': 'Rejected Work',
      'value': 20,
      'icon': Icons.cancel,
      'color': Colors.red,
    },
    {
      'title': 'KYC Verified',
      'value': 75,
      'icon': Icons.verified,
      'color': Colors.purple,
    },
    {
      'title': 'Total Users',
      'value': 200,
      'icon': Icons.people,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AdminDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Admin Stats",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.primary,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isWeb = constraints.maxWidth >= 900;
            bool isMobile = constraints.maxWidth < 800;
            int crossAxisCount = isMobile
                ? 2
                : (constraints.maxWidth < 1200 ? 3 : 4);
            return _buildDashboardContent(isMobile, isWeb, crossAxisCount);
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(bool isMobile, bool isWeb, int crossAxisCount) {
    if (!isMobile) {
      // ---------- WEB LAYOUT ----------
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Left: Summary Cards ----------
            Expanded(
              flex: 2,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: summaryData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 3.0,
                ),
                itemBuilder: (context, index) {
                  final data = summaryData[index];
                  return _summaryCard(data);
                },
              ),
            ),

            const SizedBox(width: 40),

            // ---------- Right: Pie Chart ----------
            Expanded(flex: 1, child: _buildPieChart()),
          ],
        ),
      );
    }

    // ---------- MOBILE LAYOUT ----------
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 300, child: _buildPieChart()),
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
              return _summaryCard(data);
            },
          ),
        ],
      ),
    );
  }

  // ---------- SUMMARY CARD ----------
  Widget _summaryCard(Map<String, dynamic> data) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: data['color'].withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: data['color'],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data['icon'], color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
    );
  }

  // ---------- PIE CHART ----------
  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 80,
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
    );
  }
}
