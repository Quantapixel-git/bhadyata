import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/aadmin_hr_user.dart';
import 'package:jobshub/admin/views/admin_all_companies.dart';
import 'package:jobshub/admin/views/admin_all_notification.dart';
import 'package:jobshub/admin/views/admin_approved_comapniess_byhr.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_dashboard.dart';
import 'package:jobshub/admin/views/admin_employee.dart';
import 'package:jobshub/admin/views/admin_employee_kyc.dart';
import 'package:jobshub/admin/views/admin_employee_salary.dart';
import 'package:jobshub/admin/views/admin_employee_to%20_employer_rating.dart';
import 'package:jobshub/admin/views/admin_employer.dart';
import 'package:jobshub/admin/views/admin_employer_kyc.dart';
import 'package:jobshub/admin/views/admin_employer_to_project_rating.dart';
import 'package:jobshub/admin/views/admin_evenue_total.dart';
import 'package:jobshub/admin/views/admin_hr_kyc.dart';
import 'package:jobshub/admin/views/admin_hr_salary.dart';
import 'package:jobshub/admin/views/admin_query_from_employer_to_admin.dart';
import 'package:jobshub/admin/views/admin_query_from_hr_to_admin.dart';
import 'package:jobshub/admin/views/admin_query_from_user.dart';
import 'package:jobshub/admin/views/admin_revenue_profit.dart';
import 'package:jobshub/admin/views/admin_send_notification.dart';
import 'package:jobshub/admin/views/admin_stats.dart';
import 'package:jobshub/users/views/auth/login_screen.dart';
import 'package:jobshub/common/utils/AppColor.dart';

/// ✅ MAIN WRAPPER that decides which sidebar to show
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
                  ExpansionTile(
                    leading: Icon(Icons.business, color: AppColors.primary),
                    title: const Text("Company"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      ListTile(
                        title: const Text(
                          "Approved Company (by HR)",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ApprovedCompaniesPage(),
                            ),
                          );
                        },
                      ),
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
                              builder: (_) => const HRUsersPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "Employees / Users",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmployeesPage(),
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
                              builder: (_) => const EmployersPage(),
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
                          "From Employer (profit amount)",
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
                      ListTile(
                        title: const Text(
                          "From Employer (sum of employee salary & profit)",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RevenueTotalPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.payment, color: AppColors.primary),
                    title: const Text("Salary Management"),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    children: [
                      ListTile(
                        title: const Text(
                          "HR Salary (to be paid to hr)",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HRSalaryPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "Employee Salary (to be paid to employees for their work)",
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
                          "Users / Employees",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UsersKYCPage(),
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
                              builder: (_) => const EmployersKYCPage(),
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
                              builder: (_) => const HRKYCPage(),
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
                              builder: (_) =>
                                  AdminEmployeeToEmployerRatingsPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "Employer → Project Employees",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AdminEmployerToEmployeeRatingsPage(),
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
                              builder: (_) => AdminAllNotificationsPage(),
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
                          "HR Query",
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
                          "User Query",
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
                          "Employer Query",
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
                  _sidebarItem(context, Icons.logout, "Logout", () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
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
                  _expansionGroup(context, Icons.business, "Company", [
                    _expTileChild(context, "Approved Company (by HR)", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApprovedCompaniesPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "Companies", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CompaniesPage()),
                      );
                    }),
                  ]),
                  _expansionGroup(
                    context,
                    Icons.person_4_outlined,
                    "Manage Users",
                    [
                      _expTileChild(context, "HR", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HRUsersPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Employees / Users", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployeesPage(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Employers", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployersPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _expansionGroup(context, Icons.money, "Revenue Generated", [
                    _expTileChild(context, "From Employer (profit amount)", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RevenueProfitPage()),
                      );
                    }),
                    _expTileChild(
                      context,
                      "From Employer (sum of employee salary & profit)",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RevenueTotalPage()),
                        );
                      },
                    ),
                  ]),
                  _expansionGroup(context, Icons.payment, "Salary Management", [
                    _expTileChild(context, "HR Salary (to be paid to hr)", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HRSalaryPage()),
                      );
                    }),
                    _expTileChild(
                      context,
                      "Employee Salary (to be paid to employees for their work)",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmployeeSalaryPage(),
                          ),
                        );
                      },
                    ),
                  ]),
                  _expansionGroup(context, Icons.person_search, "Manage KYC", [
                    _expTileChild(context, "Users / Employees", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UsersKYCPage()),
                      );
                    }),
                    _expTileChild(context, "Employers", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmployersKYCPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "HR", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HRKYCPage()),
                      );
                    }),
                  ]),
                  _expansionGroup(context, Icons.star, "Ratings & Reviews", [
                    _expTileChild(context, "Employee → Employer", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminEmployeeToEmployerRatingsPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "Employer → Project Employees", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminEmployerToEmployeeRatingsPage(),
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
                            builder: (_) => AdminAllNotificationsPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                  _divider(),
                  _sectionTitle("🧭 Support & Others"),
                  _expansionGroup(context, Icons.help_outline, "Query Panel", [
                    _expTileChild(context, "HR Query", () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => AdminHRtoAdminQueryPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "User Query", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmployeeQueryToAdminPage(),
                        ),
                      );
                    }),
                    _expTileChild(context, "Employer Query", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmployerQueryToAdminPage(),
                        ),
                      );
                    }),
                  ]),
                  _menuItem(context, Icons.logout, "Logout", () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
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
