import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/kyc_upload.dart';
import 'package:jobshub/users/views/auth/login_screen.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/bottom_nav.dart';
import 'package:jobshub/users/views/my_salary_based_job.dart';
import 'package:jobshub/users/views/profile_screen.dart';
import 'package:jobshub/users/views/user_attendance.dart';
import 'package:jobshub/users/views/user_commision_based_jobs.dart';
import 'package:jobshub/users/views/user_contact_page.dart';
import 'package:jobshub/users/views/user_help_support_screen.dart';
import 'package:jobshub/users/views/user_leave_request.dart';
import 'package:jobshub/users/views/projects_screen.dart';
import 'package:jobshub/users/views/user_one_time_recruit.dart';
import 'package:jobshub/common/utils/AppColor.dart';

/// ✅ MAIN WRAPPER that decides which sidebar to show
class AppDrawer extends StatelessWidget {
  final bool isWeb;
  final bool isCollapsed;
  final ValueChanged<bool>? onToggle;

  const AppDrawer({
    super.key,
    this.isWeb = false,
    this.isCollapsed = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return AppDrawerWeb(isCollapsed: isCollapsed, onToggle: onToggle);
    } else {
      return const AppDrawerMobile();
    }
  }
}

////////////////////////////////////////////////////////////////
/// 📱 FULL MOBILE VERSION (with all items from original drawer)
////////////////////////////////////////////////////////////////
class AppDrawerMobile extends StatelessWidget {
  const AppDrawerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(26)),
        child: Container(
          width: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.white, AppColors.white.withOpacity(0.95)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Colors.black12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  children: [
                    _sectionTitle("👤 Dashboard"),
                    _sidebarItem(context, Icons.home_outlined, "Home", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DashBoardScreen(),
                        ),
                      );
                    }),
                    _sidebarItem(context, Icons.person_outline, "Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    }),
                    _sidebarItem(context, Icons.approval, "KYC", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KycUploadPage(),
                        ),
                      );
                    }),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.folder_copy_outlined,
                        color: Colors.black87,
                        size: 22,
                      ),
                      title: const Text(
                        "Project Applications",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      iconColor: AppColors.primary,
                      collapsedIconColor: Colors.black54,
                      childrenPadding: const EdgeInsets.only(
                        left: 30,
                        bottom: 4,
                        right: 8,
                      ),
                      children: [
                        _expTileChild(context, "View Projects", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Projects()),
                          );
                        }),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.work_outline,
                        color: Colors.black87,
                        size: 22,
                      ),
                      title: const Text(
                        "Job Applications",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      iconColor: AppColors.primary,
                      collapsedIconColor: Colors.black54,
                      childrenPadding: const EdgeInsets.only(
                        left: 30,
                        bottom: 4,
                        right: 8,
                      ),
                      children: [
                        _expTileChild(context, "Salary Based Job", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SalaryJobs()),
                          );
                        }),
                        _expTileChild(context, "One-Time Recruitment", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OneTimeRecruitment(),
                            ),
                          );
                        }),
                        _expTileChild(context, "Lead Generator Job", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CommissionJobs()),
                          );
                        }),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.black87,
                        size: 22,
                      ),
                      title: const Text(
                        "Leaves & Attendance",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      iconColor: AppColors.primary,
                      collapsedIconColor: Colors.black54,
                      childrenPadding: const EdgeInsets.only(
                        left: 20,
                        bottom: 4,
                        right: 8,
                      ),
                      children: [
                        _expTileChild(context, "Manage Leaves", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployeeLeaveRequestScreen(
                                employeeName: "Punita Gaba",
                                work: WorkAssignment(
                                  title: "Software Engineer",
                                  company: "TechCorp Pvt Ltd",
                                  employmentType: "Salary Based Job",
                                  salary: 40000,
                                ),
                              ),
                            ),
                          );
                        }),
                        _expTileChild(context, "Attendance", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployeeAttendanceScreen(
                                employeeName: "Punita Gaba",
                                joiningDate: DateTime(2024, 1, 15),
                                work: WorkAssignment(
                                  title: "Software Engineer",
                                  company: "TechCorp Pvt Ltd",
                                  employmentType: "Salary Based",
                                  salary: 40000,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const Divider(height: 25),
                    _sectionTitle("🧭 Support & Others"),
                    _sidebarItem(
                      context,
                      Icons.contact_mail_outlined,
                      "Contact Us",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UserContactUsPage(),
                          ),
                        );
                      },
                    ),
                    _sidebarItem(
                      context,
                      Icons.help_outline,
                      "Help & Support",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UserHelpSupportPage(),
                          ),
                        );
                      },
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
                        ),
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.95),
            AppColors.primary.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset(
                "assets/job_bgr.png",
                fit: BoxFit.cover,
                height: 55,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Punita Gaba",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Software Engineer",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
            ),
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
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _expTileChild(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 14.5)),
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
class AppDrawerWeb extends StatelessWidget {
  final bool isCollapsed;
  final ValueChanged<bool>? onToggle;

  const AppDrawerWeb({super.key, required this.isCollapsed, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isCollapsed ? 80 : 270,
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.white, AppColors.white.withOpacity(0.95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
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
                  _sectionTitle("👤 Dashboard"),

                  _menuItem(context, Icons.home_outlined, "Home", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DashBoardScreen(),
                      ),
                    );
                  }),
                  _menuItem(context, Icons.person_outline, "Profile", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  }),
                    _menuItem(context, Icons.approval, "KYC", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KycUploadPage()),
                    );
                  }),
                  _expansionGroup(
                    context,
                    Icons.folder_copy_outlined,
                    "Project Applications",
                    [
                      _expTileChild(context, "View Projects", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Projects()),
                        );
                      }),
                    ],
                  ),
                  _expansionGroup(
                    context,
                    Icons.work_outline,
                    "Job Applications",
                    [
                      _expTileChild(context, "Salary Based Job", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SalaryJobs()),
                        );
                      }),
                      _expTileChild(context, "One-Time Recruitment", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OneTimeRecruitment(),
                          ),
                        );
                      }),
                      _expTileChild(context, "Lead Generator Job", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CommissionJobs()),
                        );
                      }),
                    ],
                  ),
                  _expansionGroup(
                    context,
                    Icons.calendar_today_outlined,
                    "Leaves & Attendance",
                    [
                      _expTileChild(context, "Manage Leaves", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployeeLeaveRequestScreen(
                              employeeName: "Punita Gaba",
                              work: WorkAssignment(
                                title: "Software Engineer",
                                company: "TechCorp Pvt Ltd",
                                employmentType: "Salary Based Job",
                                salary: 40000,
                              ),
                            ),
                          ),
                        );
                      }),
                      _expTileChild(context, "Attendance", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployeeAttendanceScreen(
                              employeeName: "Punita Gaba",
                              joiningDate: DateTime(2024, 1, 15),
                              work: WorkAssignment(
                                title: "Software Engineer",
                                company: "TechCorp Pvt Ltd",
                                employmentType: "Salary Based",
                                salary: 40000,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  _divider(),
                  _sectionTitle("🧭 Support & Others"),
                  _menuItem(
                    context,
                    Icons.contact_mail_outlined,
                    "Contact Us",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UserContactUsPage(),
                        ),
                      );
                    },
                  ),
                  _menuItem(context, Icons.help_outline, "Help & Support", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserHelpSupportPage(),
                      ),
                    );
                  }),
                  _menuItem(context, Icons.logout, "Logout", () async {
                    // final prefs = await SharedPreferences.getInstance();
                    await SessionManager.clearAll();
                    // await prefs.clear();
                    debugPrint("✅ SharedPreferences cleared successfully!");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Logged out successfully."),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
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

  Widget _buildHeader() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.95),
            AppColors.primary.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(26)),
      ),
      child: ClipRect(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Punita Gaba",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Software Engineer",
                      style: TextStyle(
                        // color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

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
            Icon(icon, color: Colors.black87, size: 22),
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

  Widget _expansionGroup(
    BuildContext context,
    IconData icon,
    String title,
    List<Widget> children,
  ) {
    if (isCollapsed) {
      return Tooltip(
        message: title,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Icon(icon, color: Colors.black87),
        ),
      );
    }
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.black87, size: 22),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
        ),
        childrenPadding: const EdgeInsets.only(left: 20, bottom: 6),
        iconColor: AppColors.primary,
        collapsedIconColor: Colors.black54,
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

class AppDrawerWrapper extends StatefulWidget {
  final Widget child;

  const AppDrawerWrapper({super.key, required this.child});

  @override
  State<AppDrawerWrapper> createState() => _AppDrawerWrapperState();
}

class _AppDrawerWrapperState extends State<AppDrawerWrapper> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb && MediaQuery.of(context).size.width > 800;

    if (isWeb) {
      // 💻 Web Layout with Sidebar + Main Content
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Row(
          children: [
            AppDrawer(
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
        drawer: const AppDrawer(),
        backgroundColor: Colors.grey.shade100,
        body: widget.child,
      );
    }
  }
}
