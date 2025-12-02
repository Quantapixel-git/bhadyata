import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_routes.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/common/views/onboarding/mobile_onboarding_screen.dart';
import 'package:jobshub/common/views/onboarding/web_onboarding_screen.dart';
import 'package:jobshub/hr/views/attendance/hr_employees_attendance_page.dart';
import 'package:jobshub/hr/views/company/hr_companies.dart';
import 'package:jobshub/hr/views/hr_details/hr_detail.dart';
import 'package:jobshub/hr/views/hr_details/hr_profile.dart';
import 'package:jobshub/hr/views/job_applicants/hr_commission_based_job_with_applicants.dart';
import 'package:jobshub/hr/views/job_applicants/hr_one_time_job_with_applicants.dart';
import 'package:jobshub/hr/views/job_applicants/hr_project_with_applicants.dart';
import 'package:jobshub/hr/views/job_applicants/hr_salary_based_job_with_applicants.dart';
import 'package:jobshub/hr/views/job_approval/hr_commission_based_job_approval.dart';
import 'package:jobshub/hr/views/job_approval/hr_one_time_job_approval.dart';
import 'package:jobshub/hr/views/job_approval/hr_salary_based_job_approval.dart';
import 'package:jobshub/hr/views/manage_users/hr_employees.dart';
import 'package:jobshub/hr/views/manage_users/hr_employer_list.dart';
import 'package:jobshub/hr/views/project_approval/project_approval.dart';
import 'package:jobshub/hr/views/query/hr_admin_query_page.dart';
import 'package:jobshub/hr/views/query/hr_employee_query_page.dart';
import 'package:jobshub/hr/views/ratings/employee_to_employer_ratings.dart';
import 'package:jobshub/hr/views/ratings/employer_to_employee_ratings.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_dashboard.dart';
import 'package:jobshub/hr/views/notification/hr_send_notification_page.dart';
import 'package:jobshub/hr/views/notification/hr_view_notifications_page.dart';
import 'package:jobshub/hr/views/kyc/upload_kyc_hr.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/leads/hr_leads.dart';

class HrSidebar extends StatelessWidget {
  final bool isWeb;
  final bool isCollapsed;
  final ValueChanged<bool>? onToggle;

  const HrSidebar({
    super.key,
    this.isWeb = false,
    this.isCollapsed = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return HrSidebarWeb(isCollapsed: isCollapsed, onToggle: onToggle);
    } else {
      return const HrSidebarMobile();
    }
  }
}

////////////////////////////////////////////////////////////////
/// 📱 FULL MOBILE VERSION (with all items from original sidebar)
////////////////////////////////////////////////////////////////
class HrSidebarMobile extends StatelessWidget {
  const HrSidebarMobile({super.key});

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
                        MaterialPageRoute(builder: (_) => HrDashboard()),
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
                              builder: (_) => const HrProfilePage(),
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
                            MaterialPageRoute(builder: (_) => HrDetailsPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  _sidebarItem(context, Icons.approval, "KYC", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HrKycUploadPage(),
                      ),
                    );
                  }),
                  ExpansionTile(
                    leading: Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Attendance"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      _expTileChild(context, "Salary-based Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployeesAttendancePage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  ExpansionTile(
                    leading: Icon(Icons.star, color: AppColors.primary),
                    title: const Text("Ratings & Reviews"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      _expTileChild(context, "Employee → Employer", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const EmployeeToEmployerRatingsPage(),
                          ),
                        );
                      }),
                      _expTileChild(
                        context,
                        "Employer → Project Employees",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const EmployerToEmployeeRatingsPage(),
                            ),
                          );
                        },
                      ),
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
                            builder: (_) => const HrSendNotificationPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "View Notifications", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViewNotificationsPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  const Divider(height: 25),
                  _sectionTitle("🧭 Companies & Users"),
                  _sidebarItem(context, Icons.business, "Companies", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HrCompanies()),
                    );
                  }),

                  ExpansionTile(
                    leading: Icon(
                      Icons.person_4_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Manage Users"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      ListTile(
                        title: const Text(
                          "Employees",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HrEmployeeUsersPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "Employers",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HrEmployerUsersPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 25),
                  _sectionTitle("🧭 Jobs & Projects"),
                  ExpansionTile(
                    leading: Icon(
                      Icons.checklist_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text("Jobs Approval"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      _expTileChild(context, "Salary-based Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrSalaryBasedViewPostedJobsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "One-time Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrOneTimeViewPostedJobsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Commission-based jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrCommissionBasedJobsApproval(),
                          ),
                        );
                      }),
                    ],
                  ),

                  _sidebarItem(
                    context,
                    Icons.checklist_outlined,
                    "Projects Approval",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HrProjectApproval()),
                      );
                    },
                  ),
                  const Divider(height: 25),
                  _sectionTitle("🧭 Applicants"),
                  ExpansionTile(
                    leading: Icon(
                      Icons.person_search,
                      color: AppColors.primary,
                    ),
                    title: const Text("Jobs Applicants"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      _expTileChild(context, "Salary-based Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrSalaryBasedJobApplicantsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "One-time Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OneTimeJobsWithApplicantsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Commission-based jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrCommissionBasedJobApplicants(),
                          ),
                        );
                      }),
                    ],
                  ),

                  _sidebarItem(
                    context,
                    Icons.person_search,
                    "Project Applicants",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HrProjectApplicants(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 25),
                  _sectionTitle("🧭 Leads"),
                  _sidebarItem(context, Icons.business, "Leads", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HrLeadsPage()),
                    );
                  }),

                  const Divider(height: 25),
                  _sectionTitle("🧭 Support & Others"),

                  ExpansionTile(
                    leading: Icon(Icons.help_outline, color: AppColors.primary),
                    title: const Text("Query Portal"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      _expTileChild(context, "Query from Employee", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HrEmployeeQueryPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Query to Admin", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HrQueryToAdminPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  _sidebarItem(context, Icons.logout, "Logout", () async {
                    await SessionManager.clearAll();
                    debugPrint("✅ SharedPreferences cleared successfully!");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Logged out successfully."),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes
                          .home, // '/onboarding' (handled in main.dart to choose web/mobile)
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
                "Welcome, HR",
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
class HrSidebarWeb extends StatelessWidget {
  final bool isCollapsed;
  final ValueChanged<bool>? onToggle;

  const HrSidebarWeb({super.key, required this.isCollapsed, this.onToggle});

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
                      MaterialPageRoute(builder: (_) => HrDashboard()),
                    );
                  }),
                  _expansionGroup(context, Icons.business, "My Info", [
                    _expTileChild(context, "My Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HrProfilePage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "Details", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HrDetailsPage()),
                      );
                    }),
                  ]),
                  _menuItem(context, Icons.approval, "KYC", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HrKycUploadPage(),
                      ),
                    );
                  }),
                  _expansionGroup(
                    context,
                    Icons.calendar_month_outlined,
                    "Attendance",
                    [
                      _expTileChild(context, "Salary-based Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployeesAttendancePage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _expansionGroup(context, Icons.star, "Ratings & Reviews", [
                    _expTileChild(context, "Employee → Employer", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmployeeToEmployerRatingsPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "Employer → Employees", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmployerToEmployeeRatingsPage(),
                        ),
                      );
                    }),
                  ]),
                  _expansionGroup(
                    context,
                    Icons.notifications_active_outlined,
                    "Notifications",
                    [
                      _expTileChild(context, "Send Notification", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HrSendNotificationPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "View Notifications", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViewNotificationsPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  const Divider(height: 25),
                  _sectionTitle("🧭 Companies & Users"),
                  _menuItem(context, Icons.business, "Companies", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HrCompanies()),
                    );
                  }),
                  _expansionGroup(
                    context,
                    Icons.person_4_outlined,
                    "Manage Users",
                    [
                      _expTileChild(context, "Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrEmployeeUsersPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Employers", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrEmployerUsersPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  const Divider(height: 25),
                  _sectionTitle("🧭 Jobs & Projects"),
                  _expansionGroup(
                    context,
                    Icons.checklist_outlined,
                    "Jobs Approval",
                    [
                      _expTileChild(context, "Salary-based Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrSalaryBasedViewPostedJobsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "One-time Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrOneTimeViewPostedJobsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Commission-based jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrCommissionBasedJobsApproval(),
                          ),
                        );
                      }),
                    ],
                  ),

                  _menuItem(
                    context,
                    Icons.checklist_outlined,
                    "Projects Approval",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HrProjectApproval()),
                      );
                    },
                  ),
                  const Divider(height: 25),
                  _sectionTitle("🧭 Applicants"),
                  _expansionGroup(
                    context,
                    Icons.person_search,
                    "Jobs Applicants",
                    [
                      _expTileChild(context, "Salary-based Jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrSalaryBasedJobApplicantsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "One-time Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OneTimeJobsWithApplicantsPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Commission-based jobs", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HrCommissionBasedJobApplicants(),
                          ),
                        );
                      }),
                    ],
                  ),

                  _menuItem(
                    context,
                    Icons.person_search,
                    "Project Applicants",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HrProjectApplicants(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 25),
                  _sectionTitle("🧭 Leads"),
                  _menuItem(context, Icons.business, "Leads", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HrLeadsPage()),
                    );
                  }),

                  _divider(),
                  _sectionTitle("🧭 Support & Others"),
                  _expansionGroup(context, Icons.help_outline, "Query Portal", [
                    _expTileChild(context, "Query from Employee", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HrEmployeeQueryPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "Query to Admin", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HrQueryToAdminPage(),
                        ),
                      );
                    }),
                  ]),
                  _menuItem(context, Icons.logout, "Logout", () async {
                    await SessionManager.clearAll();
                    debugPrint("✅ SharedPreferences cleared successfully!");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Logged out successfully."),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
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
                  "HR Panel",
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

class HrDashboardWrapper extends StatefulWidget {
  final Widget child;

  const HrDashboardWrapper({super.key, required this.child});

  @override
  State<HrDashboardWrapper> createState() => _HrDashboardWrapperState();
}

class _HrDashboardWrapperState extends State<HrDashboardWrapper> {
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
            HrSidebar(
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
        drawer: const HrSidebar(),
        backgroundColor: Colors.grey.shade100,
        body: widget.child,
      );
    }
  }
}
