// admin_stats_live.dart
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/app_color.dart';

class AdminStats extends StatefulWidget {
  const AdminStats({super.key});

  @override
  State<AdminStats> createState() => _AdminStatsState();
}

class _AdminStatsState extends State<AdminStats> {
  static const String _overviewUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/adminOverview';
  static const String? authToken = null; // Set if required

  bool _loading = false;
  String? _error;

  // API-driven stats
  int totalUsers = 0;
  int employees = 0;
  int employers = 0;
  int hrs = 0;

  int salaryJobs = 0;
  int commissionJobs = 0;
  int oneTimeJobs = 0;
  int totalJobs = 0;

  int projects = 0;
  int newLast7Days = 0;
  int newLast30Days = 0;
  int employersWithJobs = 0;

  // Interaction
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchOverview();
  }

  Future<void> _fetchOverview() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse(_overviewUrl);
      final res = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final Map<String, dynamic>? jsonBody =
            jsonDecode(res.body) as Map<String, dynamic>?;

        if (jsonBody == null || jsonBody['success'] != true) {
          setState(() {
            _error =
                jsonBody?['message']?.toString() ?? 'Unexpected API response';
          });
        } else {
          final data = jsonBody['data'] as Map<String, dynamic>? ?? {};

          final users = data['users'] as Map<String, dynamic>? ?? {};
          final jobs = data['jobs'] as Map<String, dynamic>? ?? {};
          final recent = data['recent'] as Map<String, dynamic>? ?? {};
          final meta = data['meta'] as Map<String, dynamic>? ?? {};

          setState(() {
            employees = (users['employees'] as num?)?.toInt() ?? 0;
            employers = (users['employers'] as num?)?.toInt() ?? 0;
            hrs = (users['hrs'] as num?)?.toInt() ?? 0;
            totalUsers =
                (users['total'] as num?)?.toInt() ??
                (employees + employers + hrs);

            salaryJobs = (jobs['salary_based'] as num?)?.toInt() ?? 0;
            commissionJobs = (jobs['commission_based'] as num?)?.toInt() ?? 0;
            oneTimeJobs = (jobs['one_time'] as num?)?.toInt() ?? 0;
            totalJobs =
                (jobs['total'] as num?)?.toInt() ??
                (salaryJobs + commissionJobs + oneTimeJobs);

            projects = (data['projects'] as num?)?.toInt() ?? 0;
            newLast7Days = (recent['new_last_7_days'] as num?)?.toInt() ?? 0;
            newLast30Days = (recent['new_last_30_days'] as num?)?.toInt() ?? 0;
            employersWithJobs =
                (meta['employers_with_jobs'] as num?)?.toInt() ?? 0;
          });
        }
      } else {
        setState(() {
          _error = 'Failed to fetch overview (${res.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network or parse error: ${e.toString()}';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onRefresh() async => _fetchOverview();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isWeb = width >= 900;
    final bool isMobile = width < 800;

    return AdminDashboardWrapper(
      child: Column(
        children: [
          AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            automaticallyImplyLeading: !isWeb,
            title: const Text(
              "Admin Stats",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                onPressed: _loading ? null : _fetchOverview,
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Refresh',
              ),
            ],
          ),

          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(16),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? _buildError()
                  : _buildContent(isMobile, isWeb),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error',
            style: TextStyle(color: Colors.red.shade700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _fetchOverview,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMobile, bool isWeb) {
    // data for pie chart
    final pieSections = [
      {'title': 'Salary', 'value': salaryJobs, 'color': Colors.green},
      {'title': 'Commission', 'value': commissionJobs, 'color': Colors.blue},
      {'title': 'One-time', 'value': oneTimeJobs, 'color': Colors.deepOrange},
    ];

    final summaryData = [
      {
        'title': 'Total Users',
        'value': totalUsers,
        'icon': Icons.people,
        'color': AppColors.primary,
      },
      {
        'title': 'Employees',
        'value': employees,
        'icon': Icons.person,
        'color': Colors.teal,
      },
      {
        'title': 'Employers',
        'value': employers,
        'icon': Icons.business,
        'color': Colors.indigo,
      },
      {
        'title': 'HRs',
        'value': hrs,
        'icon': Icons.badge,
        'color': Colors.orange,
      },
      {
        'title': 'Total Jobs',
        'value': totalJobs,
        'icon': Icons.work,
        'color': Colors.deepPurple,
      },
      {
        'title': 'Projects',
        'value': projects,
        'icon': Icons.folder_open,
        'color': Colors.teal.shade700,
      },
     
    ];

    if (!isMobile) {
      // Desktop / web layout
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // left: summary grid
            Expanded(
              flex: 2,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: summaryData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3.0,
                ),
                itemBuilder: (context, idx) {
                  final d = summaryData[idx];
                  return _summaryCard(
                    title: d['title'] as String,
                    value: (d['value'] as int).toString(),
                    color: d['color'] as Color,
                    icon: d['icon'] as IconData,
                    isMobile: false,
                  );
                },
              ),
            ),
            const SizedBox(width: 28),

            // right: pie chart & legend
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(height: 320, child: _buildPieChart(pieSections)),
                  const SizedBox(height: 18),
                  _buildLegend(pieSections),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Mobile layout
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(height: 260, child: _buildPieChart(pieSections)),
          const SizedBox(height: 12),
          _buildLegend(pieSections),
          const SizedBox(height: 18),
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
            itemBuilder: (context, idx) {
              final d = summaryData[idx];
              return _summaryCard(
                title: d['title'] as String,
                value: (d['value'] as int).toString(),
                color: d['color'] as Color,
                icon: d['icon'] as IconData,
                isMobile: true,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(List<Map<String, dynamic>> sectionsData) {
    final total = sectionsData.fold<int>(0, (a, b) => a + (b['value'] as int));
    if (total == 0) {
      return Center(
        child: Text(
          'No job data',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 48,
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
        sections: List.generate(sectionsData.length, (index) {
          final item = sectionsData[index];
          final val = (item['value'] as int).toDouble();
          final isTouched = index == touchedIndex;
          final radius = isTouched ? 70.0 : 56.0;
          final title = isTouched
              ? '${item['title']} — ${item['value']}'
              : '${((val / total) * 100).toStringAsFixed(0)}%';
          return PieChartSectionData(
            color: item['color'] as Color,
            value: val,
            title: title,
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLegend(List<Map<String, dynamic>> sectionsData) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: sectionsData.map((s) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 14, height: 14, color: s['color'] as Color),
            const SizedBox(width: 6),
            Text('${s['title']} (${s['value']})'),
          ],
        );
      }).toList(),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    required bool isMobile,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.all(isMobile ? 10 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 8 : 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: isMobile ? 18 : 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
