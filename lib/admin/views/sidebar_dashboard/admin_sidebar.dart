import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/banner/admin_banner_page.dart';
import 'package:jobshub/admin/views/constants/admin_commission_page.dart';
import 'package:jobshub/admin/views/constants/wallet_constants.dart';
import 'package:jobshub/admin/views/kyc_status/admin_employer_kyc.dart';
import 'package:jobshub/admin/views/kyc_status/admin_hr_kyc.dart';
import 'package:jobshub/admin/views/manage_users/admin_hr_users.dart';
import 'package:jobshub/admin/views/company/admin_all_companies.dart';
import 'package:jobshub/admin/views/notification/admin_all_notification.dart';
import 'package:jobshub/admin/views/category/admin_category_job.dart';
import 'package:jobshub/admin/views/ratings/employee_to_employer_ratings.dart';
import 'package:jobshub/admin/views/ratings/employer_to_employee_ratings.dart';
import 'package:jobshub/admin/views/sidebar_dashboard/admin_dashboard.dart';
import 'package:jobshub/admin/views/manage_users/admin_employee_users.dart';
import 'package:jobshub/admin/views/kyc_status/admin_employee_kyc.dart';
import 'package:jobshub/admin/views/salary_management/admin_employee_salary.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/admin/views/manage_users/admin_employer_users.dart';
import 'package:jobshub/admin/views/revenue_commission/admin_evenue_total.dart';
import 'package:jobshub/admin/views/query/admin_query_from_employer_to_admin.dart';
import 'package:jobshub/admin/views/query/admin_query_from_hr_to_admin.dart';
import 'package:jobshub/admin/views/query/admin_query_from_user.dart';
import 'package:jobshub/admin/views/revenue_commission/admin_revenue_profit.dart';
import 'package:jobshub/admin/views/notification/admin_send_notification.dart';
import 'package:jobshub/admin/views/chart/admin_chart.dart';
import 'package:jobshub/common/views/onboarding/mobile_onboarding_screen.dart';
import 'package:jobshub/common/views/onboarding/web_onboarding_screen.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/job_approval/hr_commission_based_job_approval.dart';
import 'package:jobshub/hr/views/job_approval/hr_one_time_job_approval.dart';
import 'package:jobshub/hr/views/job_approval/hr_salary_based_job_approval.dart';

class AdminSidebar extends StatelessWidget {
  final bool isWeb;
  final bool isCollapsed;
  final ValueChanged<bool>? onToggle;

  const AdminSidebar({
    super.key,
    this.isWeb = false,
    this.isCollapsed = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return AdminSidebarWeb(isCollapsed: isCollapsed, onToggle: onToggle);
    } else {
      return const AdminSidebarMobile();
    }
  }
}

////////////////////////////////////////////////////////////////
/// 📱 FULL MOBILE VERSION (with all items from original sidebar)
////////////////////////////////////////////////////////////////
class AdminSidebarMobile extends StatelessWidget {
  const AdminSidebarMobile({super.key});

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
                  _sidebarItem(context, Icons.dashboard, "Dashboard", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminDashboard()),
                    );
                  }),
                  _sidebarItem(context, Icons.pie_chart, "Chart", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminStats()),
                    );
                  }),
                  _sidebarItem(context, Icons.category, "Category", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminCategoryPage()),
                    );
                  }),
                  _sidebarItem(
                    context,
                    Icons.imagesearch_roller_rounded,
                    "Banner",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AdminBannerPage()),
                      );
                    },
                  ),
                  _sidebarItem(
                    context,
                    Icons.percent_outlined,
                    "Commission Percent",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminCommissionPage(),
                        ),
                      );
                    },
                  ),
                  _sidebarItem(context, Icons.numbers, "Wallet constants", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminWalletPage()),
                    );
                  }),
                  ExpansionTile(
                    leading: Icon(Icons.business, color: AppColors.primary),
                    title: const Text("Company"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      ListTile(
                        title: const Text(
                          "Companies",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CompaniesPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon(
                      Icons.checklist_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      "All Jobs",
                      style: TextStyle(fontSize: 14),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      ListTile(
                        title: const Text(
                          "Salary-based Jobs",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HrSalaryBasedViewPostedJobsPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "One-time Recruitment",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HrOneTimeViewPostedJobsPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "Commission-based Jobs",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HrCommissionBasedJobsApproval(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

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
                          "HR",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HrUsersPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "Employees",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmployeeUsersPage(),
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
                              builder: (_) => const EmployerUsersPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.money, color: AppColors.primary),
                    title: const Text("Revenue Generated"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      ListTile(
                        title: const Text(
                          "From Employer",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RevenueProfitPage(),
                            ),
                          );
                        },
                      ),
                      // ListTile(
                      //   title: const Text(
                      //     "From Employer (sum of employee salary & profit)",
                      //     style: TextStyle(fontSize: 13.5),
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => RevenueTotalPage(),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.payment, color: AppColors.primary),
                    title: const Text("Salary Management"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      // ListTile(
                      //   title: const Text(
                      //     "HR Salary (to be paid to hr)",
                      //     style: TextStyle(fontSize: 13.5),
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => const HRSalaryPage(),
                      //       ),
                      //     );
                      //   },
                      // ),
                      ListTile(
                        title: const Text(
                          "Salary based Employees",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmployeeSalaryPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon(
                      Icons.person_search,
                      color: AppColors.primary,
                    ),
                    title: const Text("Manage KYC"),
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
                              builder: (_) => const EmployeeKYCPage(),
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
                              builder: (_) => const EmployerKYCPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "HR",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HrKYCPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.star, color: AppColors.primary),
                    title: const Text("Ratings & Reviews"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      ListTile(
                        title: const Text(
                          "Employee → Employer",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployeeToEmployerRatingsPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "Employer → Employees",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployerToEmployeeRatingsPage(),
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
                      ListTile(
                        title: const Text(
                          "Send Notification",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminSendNotificationPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "View Notifications",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminViewNotificationsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 25),
                  _sectionTitle("🧭 Support & Others"),
                  ExpansionTile(
                    leading: Icon(Icons.help_outline, color: AppColors.primary),
                    title: const Text("Query Panel"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      ListTile(
                        title: const Text(
                          "Query from HR",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminHRtoAdminQueryPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "Query from Employee",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployeeQueryToAdminPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "Query from Employer",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployerQueryToAdminPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  _sidebarItem(context, Icons.logout, "Logout", () async {
                    // final prefs = await SharedPreferences.getInstance();

                    // // 🧹 Clear all stored preferences
                    // await prefs.clear();
                    await SessionManager.clearAll();
                    // 🖨️ Optional: Log in console for debugging
                    debugPrint("SharedPreferences cleared successfully!");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Logged out successfully."),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // 🔁 Navigate back to login screen
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
                "Welcome, Admin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Email: admin@gmail.com",
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
class AdminSidebarWeb extends StatelessWidget {
  final bool isCollapsed;
  final ValueChanged<bool>? onToggle;

  const AdminSidebarWeb({super.key, required this.isCollapsed, this.onToggle});

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
                  _menuItem(context, Icons.dashboard, "Dashboard", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminDashboard()),
                    );
                  }),
                  _menuItem(context, Icons.pie_chart, "Chart", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminStats()),
                    );
                  }),
                  _menuItem(context, Icons.category, "Category", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminCategoryPage()),
                    );
                  }),
                  _menuItem(
                    context,
                    Icons.imagesearch_roller_rounded,
                    "Banner",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AdminBannerPage()),
                      );
                    },
                  ),
                  _menuItem(
                    context,
                    Icons.percent_outlined,
                    "Commission Percent",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminCommissionPage(),
                        ),
                      );
                    },
                  ),
                  _menuItem(context, Icons.numbers, "Wallet Constants", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminWalletPage()),
                    );
                  }),
                  _expansionGroup(context, Icons.business, "Company", [
                    // _expTileChild(context, "Approved Company (by HR)", () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => ApprovedCompaniesPage(),
                    //     ),
                    //   );
                    // }),
                    _expTileChild(context, "Companies", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CompaniesPage()),
                      );
                    }),
                  ]),
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
                  _expansionGroup(
                    context,
                    Icons.person_4_outlined,
                    "Manage Users",
                    [
                      _expTileChild(context, "HR", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HrUsersPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Employees", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployeeUsersPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Employers", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployerUsersPage(),
                          ),
                        );
                      }),
                    ],
                  ),

                  _expansionGroup(context, Icons.money, "Revenue Generated", [
                    _expTileChild(context, "From Employer", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RevenueProfitPage()),
                      );
                    }),
                  ]),
                  _expansionGroup(context, Icons.payment, "Salary Management", [
                    _expTileChild(context, "Salary based Employees", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmployeeSalaryPage(),
                        ),
                      );
                    }),
                  ]),
                  _expansionGroup(context, Icons.person_search, "Manage KYC", [
                    _expTileChild(context, "Employees", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmployeeKYCPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "Employers", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmployerKYCPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "HR", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HrKYCPage()),
                      );
                    }),
                  ]),
                  _expansionGroup(context, Icons.star, "Ratings & Reviews", [
                    _expTileChild(context, "Employee → Employer", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmployeeToEmployerRatingsPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "Employer → Employees", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmployerToEmployeeRatingsPage(),
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
                            builder: (_) => AdminSendNotificationPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "View Notifications", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdminViewNotificationsPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _divider(),
                  _sectionTitle("🧭 Support & Others"),
                  _expansionGroup(context, Icons.help_outline, "Query Panel", [
                    _expTileChild(context, "Query from HR", () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => AdminHRtoAdminQueryPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "Query from Employee", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmployeeQueryToAdminPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "Query from Employer", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmployerQueryToAdminPage(),
                        ),
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
                  "Admin Panel",
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

class AdminDashboardWrapper extends StatefulWidget {
  final Widget child;

  const AdminDashboardWrapper({super.key, required this.child});

  @override
  State<AdminDashboardWrapper> createState() => _AdminDashboardWrapperState();
}

class _AdminDashboardWrapperState extends State<AdminDashboardWrapper> {
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
            AdminSidebar(
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
        drawer: const AdminSidebar(),
        backgroundColor: Colors.grey.shade100,
        body: widget.child,
      );
    }
  }
}
