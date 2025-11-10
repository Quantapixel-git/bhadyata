import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/constants/constants.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class EmployerDashboardPage extends StatefulWidget {
  const EmployerDashboardPage({super.key});

  @override
  State<EmployerDashboardPage> createState() => _EmployerDashboardPageState();
}

class _EmployerDashboardPageState extends State<EmployerDashboardPage> {
  bool loading = true;
  String? error;

  int salaryJobs = 0;
  int commissionJobs = 0;
  int oneTimeJobs = 0;
  int totalJobs = 0;

  int projects = 0;

  @override
  void initState() {
    super.initState();
    _fetchEmployerStats();
  }

  Future<void> _fetchEmployerStats() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      // Build endpoint: {baseUrl}statsEmployer
      final uri = Uri.parse("${ApiConstants.baseUrl}statsEmployer");

      // read employer_id from session
      final employerId = await SessionManager.getValue('employer_id');
      if (employerId == null || employerId.toString().isEmpty) {
        setState(() {
          error = "Employer ID not found. Please log in again.";
          loading = false;
        });
        return;
      }

      final res = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"employer_id": employerId}),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final decoded = jsonDecode(res.body);

        if (decoded["success"] == true) {
          final d = decoded["data"] ?? {};
          final j = d["jobs"] ?? {};

          setState(() {
            salaryJobs = (j["salary_based"] ?? 0) as int;
            commissionJobs = (j["commission_based"] ?? 0) as int;
            oneTimeJobs = (j["one_time"] ?? 0) as int;
            totalJobs =
                (j["total"] ?? (salaryJobs + commissionJobs + oneTimeJobs))
                    as int;

            projects = (d["projects"] ?? 0) as int;

            loading = false;
          });
        } else {
          setState(() {
            error = decoded["message"]?.toString() ?? "Something went wrong";
            loading = false;
          });
        }
      } else {
        setState(() {
          error = "Failed (${res.statusCode})";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Employer Dashboard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _fetchEmployerStats,
                  ),
                ],
              ),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : (error != null)
                    ? _errorView()
                    : _buildDashboardContent(isWeb),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _errorView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text(
            error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _fetchEmployerStats,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(bool isWeb) {
    final stats = [
      {
        "title": "Salary-Based Jobs",
        "value": salaryJobs.toString(),
        "color": Colors.blue.shade400,
        "icon": Icons.attach_money,
      },
      {
        "title": "Commission Jobs",
        "value": commissionJobs.toString(),
        "color": Colors.orange.shade400,
        "icon": Icons.bar_chart,
      },
      {
        "title": "One-Time Jobs",
        "value": oneTimeJobs.toString(),
        "color": Colors.indigo.shade400,
        "icon": Icons.task_alt_outlined,
      },
      {
        "title": "Total Jobs",
        "value": totalJobs.toString(),
        "color": Colors.purple.shade400,
        "icon": Icons.work_outline,
      },
      {
        "title": "Projects",
        "value": projects.toString(),
        "color": Colors.teal.shade400,
        "icon": Icons.folder_copy_outlined,
      },
    ];

    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isWeb ? 1.8 : 1.4,
          ),
          itemBuilder: (context, index) {
            final s = stats[index];
            return _statCard(
              s["title"] as String,
              s["value"] as String,
              s["color"] as Color,
              s["icon"] as IconData,
              isWeb,
            );
          },
        ),
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    Color color,
    IconData icon,
    bool isWeb,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(isWeb ? 18 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: isWeb ? 36 : 30),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isWeb ? 24 : 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isWeb ? 15 : 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
