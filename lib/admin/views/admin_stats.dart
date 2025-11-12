import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';

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
    final double width = MediaQuery.of(context).size.width;
    final bool isWeb = width >= 900;
    final bool isMobile = width < 800;

    return AdminDashboardWrapper(
      child: Column(
        children: [
          // ✅ Responsive AppBar
          AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            automaticallyImplyLeading: !isWeb, // hide drawer icon on web
            title: const Text(
              "Admin Stats",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primary,
          ),

          // ✅ Main Content
          Expanded(child: _buildDashboardContent(isMobile, isWeb)),
        ],
      ),
    );
  }

  // ---------- CONTENT ----------
  Widget _buildDashboardContent(bool isMobile, bool isWeb) {
    // 💻 Web layout
    if (!isMobile) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards Grid
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
                  return _summaryCard(data, isMobile: false);
                },
              ),
            ),
            const SizedBox(width: 40),

            // Pie Chart
            Expanded(
              flex: 1,
              child: SizedBox(height: 350, child: _buildPieChart()),
            ),
          ],
        ),
      );
    }

    // 📱 Mobile layout
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(height: 280, child: _buildPieChart()),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: summaryData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.0,
            ),
            itemBuilder: (context, index) {
              final data = summaryData[index];
              return _summaryCard(data, isMobile: true);
            },
          ),
        ],
      ),
    );
  }

  // ---------- SUMMARY CARD ----------
  Widget _summaryCard(Map<String, dynamic> data, {required bool isMobile}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.all(isMobile ? 10 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: data['color'].withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 6 : 10),
            decoration: BoxDecoration(
              color: data['color'],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              data['icon'],
              color: Colors.white,
              size: isMobile ? 22 : 26,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data['title'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${data['value']}',
                  style: TextStyle(
                    fontSize: isMobile ? 17 : 20,
                    fontWeight: FontWeight.bold,
                    color: data['color'],
                  ),
                ),
              ],
            ),
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
