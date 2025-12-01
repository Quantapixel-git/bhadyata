import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/common/views/onboarding/mobile_onboarding_screen.dart';
import 'package:jobshub/common/views/onboarding/web_onboarding_screen.dart';
import 'package:jobshub/employer/views/commission_job/post_commission_job.dart';
import 'package:jobshub/employer/views/commission_job/view_commission_job.dart';
import 'package:jobshub/employer/views/schedule_interview/commission_jobs_applicants.dart';
import 'package:jobshub/employer/views/schedule_interview/employer_salary_jobs_applicants.dart';
import 'package:jobshub/employer/views/one_time_job/view_one_time_job.dart';
import 'package:jobshub/employer/views/project_job/post_project.dart';
import 'package:jobshub/employer/views/one_time_job/post_one_time_job.dart';
import 'package:jobshub/employer/views/project_job/view_project.dart';
import 'package:jobshub/employer/views/salary_job/post_salary_job.dart';
import 'package:jobshub/employer/views/notification/employer_all_notification.dart';
import 'package:jobshub/employer/views/attendance_leave/employer_attendance.dart';
import 'package:jobshub/employer/views/my_employees/commision_job.dart';
import 'package:jobshub/employer/views/notes/employer_commision_job_note.dart';
import 'package:jobshub/employer/views/employer_details/employer_detail.dart';
import 'package:jobshub/employer/views/schedule_interview/one-time_applicates.dart';
import 'package:jobshub/employer/views/schedule_interview/project_employees.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_dashboard.dart';
import 'package:jobshub/employer/views/leads/leads_page.dart';
import 'package:jobshub/employer/views/wallet_deposit/employer_deposit.dart';
import 'package:jobshub/employer/views/my_employees/one_time_job.dart';
import 'package:jobshub/employer/views/notes/employer_one_time_job_note.dart';
import 'package:jobshub/employer/views/employer_details/employer_profile.dart';
import 'package:jobshub/employer/views/notes/employer_project_note.dart';
import 'package:jobshub/employer/views/my_employees/project_employee.dart';
import 'package:jobshub/employer/views/query/employer_query_to_admin.dart';
import 'package:jobshub/employer/views/query/employer_query_to_hr.dart';
import 'package:jobshub/employer/views/my_employees/salary_job.dart';
import 'package:jobshub/employer/views/notification/employer_send_notification.dart';
import 'package:jobshub/employer/views/salary_job/view_salary_job.dart';
import 'package:jobshub/employer/views/notes/employer_wallet_note.dart';
import 'package:jobshub/employer/views/attendance_leave/leave_requests.dart';
import 'package:jobshub/employer/views/notes/employer_salary_job_note.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/employer/views/kyc/employer_upload_kyc.dart';
import 'package:jobshub/employer/views/salary_management/salary_structure.dart';
import 'package:jobshub/employer/views/wallet_deposit/employer_wallet.dart';

class EmployerSidebar extends StatelessWidget {
  final bool isWeb;
  final bool isCollapsed;
  final ValueChanged<bool>? onToggle;

  const EmployerSidebar({
    super.key,
    this.isWeb = false,
    this.isCollapsed = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return EmployerSidebarWeb(isCollapsed: isCollapsed, onToggle: onToggle);
    } else {
      return const EmployerSidebarMobile();
    }
  }
}

////////////////////////////////////////////////////////////////
/// 📱 FULL MOBILE VERSION (with all items from original sidebar)
////////////////////////////////////////////////////////////////
class EmployerSidebarMobile extends StatelessWidget {
  const EmployerSidebarMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.grey[50],
        child: Column(
          children: [
            _buildHeader(),

            // scrollable section
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _sectionTitle("🏠 General"),
                  _sidebarItem(
                    context,
                    Icons.dashboard_outlined,
                    "Dashboard",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmployerDashboardPage(),
                        ),
                      );
                    },
                  ),

                  ExpansionTile(
                    leading: Icon(Icons.business, color: AppColors.primary),
                    title: const Text("My Info"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      ListTile(
                        title: const Text(
                          "My Profile",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmployerProfilePage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "Details",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CompanyDetailsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  _sidebarItem(context, Icons.approval, "KYC", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EmployerKycUploadPage(),
                      ),
                    );
                  }),

                  ExpansionTile(
                    leading: Icon(
                      Icons.note_alt_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Notes for Employer"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      _expTileChild(context, "Salary-Based Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SalaryBasedRecruitmentPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "One-Time Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OneTimeRecruitmentPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Project-Based Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProjectBasedRecruitmentPage(),
                          ),
                        );
                      }),
                      _expTileChild(
                        context,
                        "Commission-Based Recruitment",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommissionBasedRecruitmentPage(),
                            ),
                          );
                        },
                      ),
                      _expTileChild(context, "Wallet & Deposit Working", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WalletDepositWorkingPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  ExpansionTile(
                    leading: Icon(
                      Icons.notifications_active_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Notifications"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      _expTileChild(context, "Send Notification", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployerSendNotificationPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "All Notifications", () {
                        // AllNotificationsPage();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployerNotificationsPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  const Divider(height: 25),
                  _sectionTitle("💼 Job & Recruitment"),

                  ExpansionTile(
                    leading: Icon(
                      Icons.monetization_on_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Post Salary-based Job"),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    children: [
                      _expTileChild(context, "Post Job", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployerPostSalaryBasedJob(),
                          ),
                        );
                      }),
                      _expTileChild(context, "View Posted Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SalaryBasedViewPostedJobsPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  ExpansionTile(
                    leading: Icon(
                      Icons.person_add_alt_1_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Post One-time Jobs"),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    children: [
                      _expTileChild(context, "Post Job", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployerPostOneTimeJob(),
                          ),
                        );
                      }),
                      _expTileChild(context, "View Posted Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OneTimeViewPostedJobsPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  ExpansionTile(
                    leading: Icon(
                      Icons.cached_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Post Commission-based Job"),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    children: [
                      _expTileChild(context, "Post Job", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployerPostCommissionBasedJob(),
                          ),
                        );
                      }),
                      _expTileChild(context, "View Posted Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommissionBasedViewPostedJobsPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  ExpansionTile(
                    leading: Icon(
                      Icons.schedule_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Schedule Interviews (Job)"),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    children: [
                      _expTileChild(context, "Commission-based Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EmployerCommissionBasedJobsWithApplicantsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "One-time Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EmployerOneTimeJobsWithApplicantsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Salary-based Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EmployerSalaryBasedJobsWithApplicantsPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  const Divider(height: 25),
                  _sectionTitle("📊 Projects"),

                  ExpansionTile(
                    leading: Icon(Icons.work_outline, color: AppColors.primary),
                    title: const Text("Projects"),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    children: [
                      _expTileChild(context, "Post Project", () {
                        // PostProjectPage();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PostProjectPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "View Projects", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewPostedProjectsPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  ExpansionTile(
                    leading: Icon(
                      Icons.schedule_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Schedule Interviews (Project)"),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    children: [
                      _expTileChild(context, "Projects", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EmployerProjectsWithApplicantsPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  const Divider(height: 25),
                  _sectionTitle("📊 Finance"),
                  _sidebarItem(
                    context,
                    Icons.account_balance_wallet,
                    "My Wallet",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmployerWalletPage(),
                        ),
                      );
                    },
                  ),

                  _sidebarItem(
                    context,
                    Icons.attach_money_outlined,
                    "My Deposit",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MyDepositPage()),
                      );
                    },
                  ),

                  const Divider(height: 25),
                  _sectionTitle("👥 Employees & Salary"),

                  ExpansionTile(
                    leading: Icon(
                      Icons.people_alt_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Job Employees"),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    children: [
                      _expTileChild(context, "Commission-Based Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommissionEmployeesPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Salary-Based Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SalaryBasedEmployeesPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "One-Time Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OneTimeEmployeesPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _sidebarItem(
                    context,
                    Icons.people_alt_outlined,
                    "Project Employees",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectEmployeesPage(),
                        ),
                      );
                    },
                  ),

                  ExpansionTile(
                    leading: Icon(
                      Icons.payments_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Salary Structure"),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    children: [
                      _expTileChild(context, "Salary-based", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SalaryDuePage()),
                        );
                      }),
                         _expTileChild(context, "Commission-based", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SalaryDuePage()),
                        );
                      }),
                    ],
                  ),

                  ExpansionTile(
                    leading: Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Employees Attendance"),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    children: [
                      _expTileChild(context, "Salary-based Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SalaryBasedAttendancePage(),
                          ),
                        );
                        // SalaryBasedAttendancePage();
                      }),
                      _expTileChild(context, "Leave Requests", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LeaveRequestsPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  const Divider(height: 25),
                  _sectionTitle("👥 Leads"),
                  _sidebarItem(
                    context,
                    Icons.attach_money_outlined,
                    "Leads",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LeadsPage()),
                      );
                    },
                  ),
                  const Divider(height: 25),
                  _sectionTitle("🧭 Support & Others"),

                  ExpansionTile(
                    leading: Icon(Icons.help_outline, color: AppColors.primary),
                    title: const Text("Query Portal"),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    children: [
                      _expTileChild(context, "Query to HR", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => QueryToHrPage()),
                        );
                      }),
                      _expTileChild(context, "Query to Admin", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => QueryToAdminPage()),
                        );
                      }),
                    ],
                  ),

                  _sidebarItem(context, Icons.logout, "Logout", () async {
                    // final prefs = await SharedPreferences.getInstance();
                    await SessionManager.clearAll();
                    // await prefs.clear();
                    debugPrint("✅ SharedPreferences cleared successfully!");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Logged out successfully."),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    final bool isWebPlatform =
                        kIsWeb || MediaQuery.of(context).size.width > 800;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => isWebPlatform
                            ? const WebOnboardingPage() // your web onboarding
                            : const MobileOnboardingPage(), // your mobile onboarding
                      ),
                      (route) => false,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧱 Helper Widgets
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
        ),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30)),
      ),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage("assets/job_bgr.png"),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, Employer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Mobile: 9090909090",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  Widget _expTileChild(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 13.5)),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// 💻 WEB VERSION (FULL COLLAPSIBLE SIDEBAR)
////////////////////////////////////////////////////////////////
class EmployerSidebarWeb extends StatelessWidget {
  final bool isCollapsed;
  final ValueChanged<bool>? onToggle;

  const EmployerSidebarWeb({
    super.key,
    required this.isCollapsed,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isCollapsed ? 80 : 250,
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 0),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("🏠 General"),
                  _menuItem(context, Icons.dashboard_outlined, "Dashboard", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmployerDashboardPage(),
                      ),
                    );
                  }),
                  _expansionGroup(context, Icons.business, "My Info", [
                    _expTileChild(context, "My Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmployerProfilePage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "Details", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CompanyDetailsPage()),
                      );
                    }),
                  ]),
                  _menuItem(context, Icons.approval, "KYC", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EmployerKycUploadPage(),
                      ),
                    );
                  }),
                  _expansionGroup(
                    context,
                    Icons.note_alt_outlined,
                    "Notes for Employer",
                    [
                      _expTileChild(context, "Salary Based Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SalaryBasedRecruitmentPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "One-Time Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OneTimeRecruitmentPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Project-Based Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProjectBasedRecruitmentPage(),
                          ),
                        );
                      }),
                      _expTileChild(
                        context,
                        "Commission Based Recruitment",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommissionBasedRecruitmentPage(),
                            ),
                          );
                        },
                      ),
                      _expTileChild(context, "Wallet & Deposit Working", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WalletDepositWorkingPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _expansionGroup(
                    context,
                    Icons.notifications_active_outlined,
                    "Notifications",
                    [
                      _expTileChild(context, "Send Notification", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployerSendNotificationPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "All Notifications", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployerNotificationsPage(),
                          ),
                        );
                        // AllNotificationsPage();
                      }),
                    ],
                  ),
                  _divider(),
                  _sectionTitle("💼 Job & Recruitment"),
                  _expansionGroup(
                    context,
                    Icons.monetization_on_outlined,
                    "Post Salary-based Job",
                    [
                      _expTileChild(context, "Post Job", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployerPostSalaryBasedJob(),
                          ),
                        );
                      }),
                      _expTileChild(context, "View Posted Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SalaryBasedViewPostedJobsPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _expansionGroup(
                    context,
                    Icons.person_add_alt_1_outlined,
                    "Post One-time Recruitment",
                    [
                      _expTileChild(context, "Post Job", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployerPostOneTimeJob(),
                          ),
                        );
                      }),
                      _expTileChild(context, "View Posted Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OneTimeViewPostedJobsPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _expansionGroup(
                    context,
                    Icons.cached_outlined,
                    "Commission-based Lead Generator Job",
                    [
                      _expTileChild(context, "Post Job", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployerPostCommissionBasedJob(),
                          ),
                        );
                      }),
                      _expTileChild(context, "View Posted Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommissionBasedViewPostedJobsPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _expansionGroup(
                    context,
                    Icons.schedule_outlined,
                    "Schedule Interviews (Job)",
                    [
                      _expTileChild(context, "Commission-based Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EmployerCommissionBasedJobsWithApplicantsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "One-time Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EmployerOneTimeJobsWithApplicantsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Salary-based Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EmployerSalaryBasedJobsWithApplicantsPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _divider(),
                  _sectionTitle("📊 Projects"),
                  _expansionGroup(context, Icons.work_outline, "Projects", [
                    _expTileChild(context, "Post Project", () {
                      // PostProjectPage();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PostProjectPage(),
                        ),
                      );
                    }),

                    _expTileChild(context, "View Projects", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewPostedProjectsPage(),
                        ),
                      );
                    }),
                  ]),

                  _expansionGroup(
                    context,
                    Icons.schedule_outlined,
                    "Schedule Interviews (Project)",
                    [
                      _expTileChild(context, "Projects", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EmployerProjectsWithApplicantsPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _divider(),
                  _sectionTitle("📊 Finance"),
                  _menuItem(
                    context,
                    Icons.account_balance_wallet,
                    "My Wallet",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EmployerWalletPage()),
                      );
                    },
                  ),
                  _menuItem(
                    context,
                    Icons.attach_money_outlined,
                    "My Deposit",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MyDepositPage()),
                      );
                    },
                  ),
                  _divider(),
                  _sectionTitle("👥 Employees & Salary"),
                  _expansionGroup(
                    context,
                    Icons.people_alt_outlined,
                    "Job Employees",
                    [
                      _expTileChild(context, "Commission-Based Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommissionEmployeesPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Salary-Based Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SalaryBasedEmployeesPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "One-Time Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OneTimeEmployeesPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  _menuItem(
                    context,
                    Icons.people_alt_outlined,
                    "Project Employees",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectEmployeesPage(),
                        ),
                      );
                    },
                  ),
                  _expansionGroup(
                    context,
                    Icons.payments_outlined,
                    "Salary Structure",
                    [
                      _expTileChild(context, "Salary-based", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SalaryDuePage()),
                        );
                      }),
                       _expTileChild(context, "Commission-based", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SalaryDuePage()),
                        );
                      }),
                    ],
                  ),
                  _expansionGroup(
                    context,
                    Icons.calendar_month_outlined,
                    "Employees Attendance",
                    [
                      _expTileChild(context, "Salary-based Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SalaryBasedAttendancePage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Leave Requests", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LeaveRequestsPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _divider(),
                  _sectionTitle("👥 Leads"),
                  _menuItem(context, Icons.attach_money_outlined, "Leads", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LeadsPage()),
                    );
                  }),
                  _divider(),
                  _sectionTitle("🧭 Support & Others"),
                  _expansionGroup(context, Icons.help_outline, "Query Portal", [
                    _expTileChild(context, "Query to HR", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => QueryToHrPage()),
                      );
                    }),
                    _expTileChild(context, "Query to Admin", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => QueryToAdminPage()),
                      );
                    }),
                  ]),
                  _menuItem(context, Icons.logout, "Logout", () async {
                    // final prefs = await SharedPreferences.getInstance();
                    await SessionManager.clearAll();
                    // await prefs.clear();
                    debugPrint("✅ SharedPreferences cleared successfully!");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Logged out successfully."),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    final bool isWebPlatform =
                        kIsWeb || MediaQuery.of(context).size.width > 800;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => isWebPlatform
                            ? const WebOnboardingPage() // your web onboarding
                            : const MobileOnboardingPage(), // your mobile onboarding
                      ),
                      (route) => false,
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Collapse Toggle
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IconButton(
              icon: Icon(
                isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: AppColors.primary,
              ),
              onPressed: () => onToggle?.call(!isCollapsed),
            ),
          ),
        ],
      ),
    );
  }

  //
  // Header
  Widget _buildHeader() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
      ),
      child: ClipRect(
        // ✅ prevents overflow during width animation
        child: Row(
          mainAxisAlignment: isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/job_bgr.png"),
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Employer Panel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Simple Menu Item
  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isCollapsed ? 0 : 16,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            if (!isCollapsed) ...[
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Expansion Section
  Widget _expansionGroup(
    BuildContext context,
    IconData icon,
    String title,
    List<Widget> children,
  ) {
    if (isCollapsed) {
      // When collapsed, just show the icon (no expand)
      return Tooltip(
        message: title,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Icon(icon, color: AppColors.primary),
        ),
      );
    }
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
        ),
        childrenPadding: const EdgeInsets.only(left: 20, bottom: 6),
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.primary,
        children: children,
      ),
    );
  }

  Widget _expTileChild(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(title, style: const TextStyle(fontSize: 13.5)),
      onTap: onTap,
    );
  }

  Widget _sectionTitle(String title) {
    if (isCollapsed) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 0, 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _divider() =>
      isCollapsed ? const SizedBox.shrink() : const Divider(height: 20);
}

class EmployerDashboardWrapper extends StatefulWidget {
  final Widget child;

  const EmployerDashboardWrapper({super.key, required this.child});

  @override
  State<EmployerDashboardWrapper> createState() =>
      _EmployerDashboardWrapperState();
}

class _EmployerDashboardWrapperState extends State<EmployerDashboardWrapper> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 900;

    if (isWeb) {
      // 💻 Web Layout with Sidebar + Main Content
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Row(
          children: [
            EmployerSidebar(
              isWeb: true,
              isCollapsed: _isCollapsed,
              onToggle: (value) => setState(() => _isCollapsed = value),
            ),
            Expanded(child: widget.child),
          ],
        ),
      );
    } else {
      // 📱 Mobile Layout with Drawer
      return Scaffold(
        drawer: const EmployerSidebar(),
        backgroundColor: Colors.grey.shade100,
        body: widget.child,
      );
    }
  }
}
