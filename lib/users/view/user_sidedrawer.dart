import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/users/view/alltype_jobs_page.dart';
import 'package:jobshub/users/view/auth/login_screen.dart';
import 'package:jobshub/users/view/my_salary_based_job.dart';
import 'package:jobshub/users/view/profile_screen.dart';
import 'package:jobshub/users/view/reward_screen.dart';
import 'package:jobshub/users/view/user_attendance.dart';
import 'package:jobshub/users/view/user_commision_based_jobs.dart';
import 'package:jobshub/users/view/user_contact_page.dart';
import 'package:jobshub/users/view/user_help_support_screen.dart';
import 'package:jobshub/users/view/user_leave_request.dart';
import 'package:jobshub/users/view/projects_screen.dart';
import 'package:jobshub/users/view/user_one_time_recruit.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _applicationsExpanded = false; // 🔹 for Expand/Collapse

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb && MediaQuery.of(context).size.width > 800;

    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(26)),
        child: Container(
          width: isWeb ? 270 : 240,
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
              // 🔹 Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.95),
                      AppColors.primary.withOpacity(0.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(26),
                  ),
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
              ),

              const SizedBox(height: 10),
              const Divider(height: 1, color: Colors.black12),

              // 🔹 Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  children: [
                    _drawerItem(
                      context,
                      icon: Icons.person_outline,
                      text: "Profile",
                      page: const ProfileScreen(),
                    ),

                    // 🔹 Expandable Applications Section
                    // 🔹 Expandable Applications Section (Now split into Project & Job Applications)
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
                        _subItem(
                          context,
                          text: "View Projects",
                          page: Projects(),
                        ),
                      ],
                    ),
                    
                    // 🔹 Job Applications Section
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
                        _subItem(
                          context,
                          text: "Salary Based Job",
                          page: SalaryJobs(),
                        ),
                        _subItem(
                          context,
                          text: "One-Time Recruitment",
                          page: OneTimeRecruitment(),
                        ),
                        _subItem(
                          context,
                          text: "Lead Generator Job",
                          page: CommissionJobs(),
                        ),
                      ],
                    ),

                    ExpansionTile(
                      leading: const Icon(
                        Icons.work_outline,
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
                        _subItem(
                          context,
                          text: "Manage Leaves",
                          page: EmployeeLeaveRequestScreen(
                            employeeName: "Punita Gaba",
                            work: WorkAssignment(
                              title: "Software Engineer",
                              company: "TechCorp Pvt Ltd",
                              employmentType: "Salary Based Job",
                              salary: 40000,
                            ),
                          ),
                        ),
                        _subItem(
                          context,
                          text: "Attendance",
                          page: EmployeeAttendanceScreen(
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
                      ],
                    ),

                    _drawerItem(
                      context,
                      icon: Icons.contact_mail_outlined,
                      text: "Contact Us",
                      page: const UserContactUsPage(),
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.help_outline,
                      text: "Help & Support",
                      page: const UserHelpSupportPage(),
                    ),
                  ],
                ),
              ),

              // 🔹 Logout
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Main Drawer Item
  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Widget page,
  }) {
    final bool isWeb = kIsWeb && MediaQuery.of(context).size.width > 800;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        child: ListTile(
          leading: Icon(icon, color: Colors.black87, size: 22),
          title: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          hoverColor: isWeb ? Colors.grey.shade200 : Colors.grey.shade100,
        ),
      ),
    );
  }

  // 🔹 Sub-item inside ExpansionTile
  Widget _subItem(
    BuildContext context, {
    required String text,
    required Widget page,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40),
      title: Text(
        text,
        style: const TextStyle(color: Colors.black87, fontSize: 14.5),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
