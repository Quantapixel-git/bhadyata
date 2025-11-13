import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/views/project_model.dart';

/// LIVE Admin Dashboard - fetches data from Admin Overview API
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  static const String kAdminOverviewUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/adminOverview';

  // If your API requires a bearer token, set it here (or fetch from secure storage)
  static const String? kAuthToken = null; // 'YOUR_BEARER_TOKEN';

  bool _loading = false;
  String? _error;

  // Stats (defaults)
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

  // Example project list kept from original (you can fetch real projects similarly)
  final List<ProjectModel> projectsList = [
    ProjectModel(
      title: 'Website Design',
      description: 'Landing page project',
      budget: 5000,
      category: 'Design',
      paymentType: 'Salary',
      paymentValue: 5000,
      status: 'In Progress',
      deadline: DateTime.now().add(const Duration(days: 7)),
      applicants: [
        {'name': 'Alice Johnson', 'proposal': 'I can complete this in 3 days.'},
        {
          'name': 'Bob Smith',
          'proposal': 'I’ll deliver responsive design fast.',
        },
      ],
    ),
  ];

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
      final uri = Uri.parse(kAdminOverviewUrl);
      final res = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          if (kAuthToken != null) 'Authorization': 'Bearer $kAuthToken',
        },
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final jsonBody = jsonDecode(res.body) as Map<String, dynamic>?;

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
          _error = 'Failed to fetch (${res.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onRefresh() async {
    await _fetchOverview();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return AdminDashboardWrapper(
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Admin Dashboard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                actions: [
                  IconButton(
                    onPressed: _fetchOverview,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    tooltip: 'Refresh',
                  ),
                ],
              ),

              // Body
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_loading) ...[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Column(
                                  children: const [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 12),
                                    Text('Loading dashboard...'),
                                  ],
                                ),
                              ),
                            ),
                          ] else if (_error != null) ...[
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red.shade400,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _error!,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton.icon(
                                    onPressed: _fetchOverview,
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            // Greeting
                            if (!isWeb)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Welcome Back 👋",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Here’s an overview of your admin panel.",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Stats grid
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final stats = [
                                  {
                                    "title": "Total Users",
                                    "value": totalUsers.toString(),
                                    "color": AppColors.primary,
                                    "icon": Icons.people,
                                  },
                                  {
                                    "title": "Employees",
                                    "value": employees.toString(),
                                    "color": Colors.teal.shade400,
                                    "icon": Icons.person,
                                  },
                                  {
                                    "title": "Employers",
                                    "value": employers.toString(),
                                    "color": Colors.indigo.shade400,
                                    "icon": Icons.business,
                                  },
                                  {
                                    "title": "HRs",
                                    "value": hrs.toString(),
                                    "color": Colors.orange.shade400,
                                    "icon": Icons.badge,
                                  },
                                  // {
                                  //   "title": "Total Jobs",
                                  //   "value": totalJobs.toString(),
                                  //   "color": Colors.deepPurple.shade400,
                                  //   "icon": Icons.work,
                                  // },
                                  {
                                    "title": "Salary Jobs",
                                    "value": salaryJobs.toString(),
                                    "color": Colors.green.shade400,
                                    "icon": Icons.attach_money,
                                  },
                                  {
                                    "title": "Commission Jobs",
                                    "value": commissionJobs.toString(),
                                    "color": Colors.blue.shade400,
                                    "icon": Icons.paid,
                                  },
                                  {
                                    "title": "One-time Jobs",
                                    "value": oneTimeJobs.toString(),
                                    "color": Colors.red.shade400,
                                    "icon": Icons.timer,
                                  },
                                  {
                                    "title": "Projects",
                                    "value": projects.toString(),
                                    "color": Colors.teal.shade700,
                                    "icon": Icons.folder_open,
                                  },
                                  // {
                                  //   "title": "New (7d)",
                                  //   "value": newLast7Days.toString(),
                                  //   "color": Colors.orange.shade700,
                                  //   "icon": Icons.timeline,
                                  // },
                                  // {
                                  //   "title": "New (30d)",
                                  //   "value": newLast30Days.toString(),
                                  //   "color": Colors.orange.shade400,
                                  //   "icon": Icons.timeline_outlined,
                                  // },
                                  // {
                                  //   "title": "Employers w/ Jobs",
                                  //   "value": employersWithJobs.toString(),
                                  //   "color": Colors.brown.shade400,
                                  //   "icon": Icons.group_work,
                                  // },
                                ];

                                final crossAxisCount = isWeb ? 4 : 2;
                                final childAspect = isWeb ? 1.8 : 1.4;

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: stats.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: childAspect,
                                      ),
                                  itemBuilder: (context, index) {
                                    final stat = stats[index];
                                    return _statCard(
                                      stat['title'] as String,
                                      stat['value'] as String,
                                      stat['color'] as Color,
                                      stat['icon'] as IconData,
                                      isWeb,
                                    );
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 30),

                            // Projects preview (static mock for now)
                            // const Text(
                            //   'Recent Projects',
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     fontWeight: FontWeight.w700,
                            //   ),
                            // ),
                            // const SizedBox(height: 12),
                            // ...projectsList
                            //     .map((p) => _projectCard(p))
                            //     .toList(),
                            // const SizedBox(height: 30),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(
    String title,
    String value,
    Color color,
    IconData icon,
    bool isWeb,
  ) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
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
              color: color.withOpacity(0.24),
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
      ),
    );
  }
}
