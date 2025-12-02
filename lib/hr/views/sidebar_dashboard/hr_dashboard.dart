import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';

import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/app_routes.dart';
import 'package:jobshub/common/utils/session_manager.dart';

// ⬇️ Adjust this import to wherever your HR KYC checker page lives
// import 'package:jobshub/hr/views/auth/hr_kyc_checker_page.dart';
import 'package:jobshub/hr/views/auth/kyc_checker.dart';

import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

const String kApiBase = "https://dialfirst.in/quantapixel/badhyata/api/";

class HrDashboard extends StatefulWidget {
  const HrDashboard({super.key});

  @override
  State<HrDashboard> createState() => _HrDashboardState();
}

class _HrDashboardState extends State<HrDashboard> {
  bool loading = true;
  String? error;

  int employees = 0;
  int employers = 0;
  int hrs = 0;

  int salaryJobs = 0;
  int commissionJobs = 0;
  int oneTimeJobs = 0;

  int projects = 0;

  // 🔹 NEW: KYC gate flags
  bool _checkingKyc = true;
  int?
  _kycApproval; // 1 = approved, 2 = pending, 3 = rejected, null = not submitted

  @override
  void initState() {
    super.initState();
    _init();
  }

  /// Run KYC check first; only load stats if KYC is approved
  Future<void> _init() async {
    await _checkKycStatus();

    if (_kycApproval == 1) {
      // only fetch dashboard stats when KYC is approved
      await _fetchStats();
    } else {
      // don't keep "loading..." spinner for stats if we are anyway
      // going to show the KYC checker
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  /// 🔹 NEW: Check HR KYC status (similar style as employee)
  Future<void> _checkKycStatus() async {
    setState(() {
      _checkingKyc = true;
      _kycApproval = null;
    });

    try {
      // 🔹 use SAME key as HrKyccheckerPage
      final hrIdStr = await SessionManager.getValue('hr_id');
      final hrId = hrIdStr?.toString() ?? '0';

      // 🔹 use SAME endpoint as HrKyccheckerPage
      final uri = Uri.parse("${ApiConstants.baseUrl}getHrProfileByUserId");

      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"user_id": hrId}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data['success'] == true && data['data'] != null) {
          final raw = data['data']['kyc_approval'];

          int? approval;
          if (raw is int) {
            approval = raw;
          } else if (raw != null) {
            approval = int.tryParse(raw.toString());
          }

          if (!mounted) return;
          setState(() {
            _kycApproval = approval; // 1 = approved, others = not approved
          });
        } else {
          if (!mounted) return;
          setState(() {
            _kycApproval = null;
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          _kycApproval = null;
        });
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint("❌ Error checking HR KYC: $e");
      setState(() {
        _kycApproval = null;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _checkingKyc = false;
      });
    }
  }

  Future<void> _fetchStats() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final uri = Uri.parse("${kApiBase}statsOverview");

      final res = await http.get(uri);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body);

        if (data["success"] == true) {
          final u = data["data"]["users"];
          final j = data["data"]["jobs"];

          setState(() {
            employees = u["employees"] ?? 0;
            employers = u["employers"] ?? 0;
            hrs = u["hrs"] ?? 0;

            salaryJobs = j["salary_based"] ?? 0;
            commissionJobs = j["commission_based"] ?? 0;
            oneTimeJobs = j["one_time"] ?? 0;

            projects = data["data"]["projects"] ?? 0;

            loading = false;
          });
        } else {
          setState(() {
            error = data["message"] ?? "Something went wrong";
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
    // 1️⃣ While KYC status is loading → show loader
    if (_checkingKyc) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2️⃣ If KYC is NOT approved → show HR KYC checker page instead of dashboard
    if (_kycApproval != 1) {
      // return const HrKyccheckerPage();
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, AppRoutes.hrKycChecker);
      });
      return const SizedBox(); // temporary placeholder
    }

    // 3️⃣ Only when KYC is approved, show real HR Dashboard UI
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return HrDashboardWrapper(
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "HR Dashboard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _fetchStats,
                  ),
                ],
              ),

              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _fetchStats,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      )
                    : _buildDashboardContent(isWeb),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardContent(bool isWeb) {
    final stats = [
      {
        "title": "Employees/Users",
        "value": employees.toString(),
        "color": Colors.blue.shade400,
        "icon": Icons.people,
      },
      {
        "title": "Employers",
        "value": employers.toString(),
        "color": Colors.orange.shade400,
        "icon": Icons.business_center,
      },
      {
        "title": "HRs",
        "value": hrs.toString(),
        "color": Colors.green.shade400,
        "icon": Icons.admin_panel_settings,
      },
      {
        "title": "Salary Jobs",
        "value": salaryJobs.toString(),
        "color": Colors.purple.shade400,
        "icon": Icons.work_outline,
      },
      {
        "title": "Commission Jobs",
        "value": commissionJobs.toString(),
        "color": Colors.teal.shade400,
        "icon": Icons.monetization_on_outlined,
      },
      {
        "title": "One-Time Jobs",
        "value": oneTimeJobs.toString(),
        "color": Colors.indigo.shade400,
        "icon": Icons.task_alt_outlined,
      },
      {
        "title": "Projects",
        "value": projects.toString(),
        "color": Colors.red.shade400,
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
