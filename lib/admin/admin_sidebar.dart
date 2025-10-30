import 'package:flutter/material.dart';
import 'package:jobshub/admin/aadmin_hr_user.dart';
import 'package:jobshub/admin/admin_all_companies.dart';
import 'package:jobshub/admin/admin_all_notification.dart';
import 'package:jobshub/admin/admin_approved_comapniess_byhr.dart';
import 'package:jobshub/admin/admin_dashboard.dart';
import 'package:jobshub/admin/admin_employee.dart';
import 'package:jobshub/admin/admin_employee_kyc.dart';
import 'package:jobshub/admin/admin_employee_salary.dart';
import 'package:jobshub/admin/admin_employee_to%20_employer_rating.dart';
import 'package:jobshub/admin/admin_employer.dart';
import 'package:jobshub/admin/admin_employer_kyc.dart';
import 'package:jobshub/admin/admin_employer_to_project_rating.dart';
import 'package:jobshub/admin/admin_evenue_total.dart';
import 'package:jobshub/admin/admin_hr_kyc.dart';
import 'package:jobshub/admin/admin_hr_salary.dart';
import 'package:jobshub/admin/admin_query_from_employer_to_admin.dart';
import 'package:jobshub/admin/admin_query_from_hr_to_admin.dart';
import 'package:jobshub/admin/admin_query_from_user.dart';
import 'package:jobshub/admin/admin_revenue_profit.dart';
import 'package:jobshub/admin/admin_send_notification.dart';
import 'package:jobshub/admin/admin_stats.dart';
// import 'package:jobshub/hr/view/employee_to_employer_ratings_page.dart';
// import 'package:jobshub/hr/view/hr_employer_to_employee_ratings_page.dart';
import 'package:jobshub/users/view/auth/login_screen.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class AdminSidebar extends StatelessWidget {
  final String selectedPage; // current active page
  final bool isWeb; // layout flag

  const AdminSidebar({
    super.key,
    this.selectedPage = "Dashboard",
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.grey[50],
        elevation: 4,
        child: Column(
          children: [
            // ---------- HEADER ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage("assets/job_bgr.png"),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Admin Panel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Email: admin@gmail.com",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ---------- SECTIONS ----------
            // ---------- SECTIONS ----------
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _sectionTitle("🏠 General"),
                  _sidebarItem(
                    context,
                    Icons.dashboard,
                    "Dashboard",
                    const AdminDashboardPage(),
                  ),
                  _sidebarItem(context, Icons.pie_chart, "Chart", AdminStats()),
                  // ---------- Company (Expandable) ----------
                  ExpansionTile(
                    leading: Icon(Icons.business, color: AppColors.primary),
                    title: const Text(
                      "Company",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                  SizedBox(height: 5),
                  // _sidebarItem(
                  //   context,
                  //   Icons.report,
                  //   "Job Status",
                  //   JobStatusScreen(),
                  // ),

                  // ---------- Manage Users (Expandable) ----------
                  ExpansionTile(
                    leading: Icon(
                      Icons.person_4_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      "Manage Users",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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

                  SizedBox(height: 5),
                  // ---------- Revenue Generated ----------
                  // ---------- Revenue Generated (Expandable) ----------
                  ExpansionTile(
                    leading: Icon(Icons.money, color: AppColors.primary),
                    title: const Text(
                      "Revenue Generated",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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

                  SizedBox(height: 5),
                  // ---------- Salary Management ----------
                  // ---------- Salary Management (Expandable) ----------
                  ExpansionTile(
                    leading: Icon(Icons.payment, color: AppColors.primary),
                    title: const Text(
                      "Salary Management",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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

                  SizedBox(height: 5),
                  // ---------- Manage KYC (Expandable) ----------
                  ExpansionTile(
                    leading: Icon(
                      Icons.person_search,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      "Manage KYC",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                  SizedBox(height: 5),
                  // ---------- Ratings & Reviews (Expandable) ----------
                  ExpansionTile(
                    leading: Icon(Icons.star, color: AppColors.primary),
                    title: const Text(
                      "Ratings & Reviews",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                              builder: (_) => adminEmployeeToEmployerRatingsPage(),
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
                              builder: (_) => adminEmployerToEmployeeRatingsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // ---------- Notifications (Expandable) ----------
                  ExpansionTile(
                    leading: Icon(
                      Icons.notifications,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      "Notifications",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                              builder: (_) => adminSendNotificationPage(),
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
                              builder: (_) => adminAllNotificationsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const Divider(height: 25),
                  _sectionTitle("🧭 Support & Others"),

                  // ---------- Query ----------
                  ExpansionTile(
                    leading: Icon(
                      Icons.question_answer,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      "Query Panel",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                              builder: (_) => adminHRtoadminQueryPage(),
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
                              builder: (_) => employerQueryToAdminPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  _sidebarItem(context, Icons.logout, "Log out", LoginScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Section Title ----------
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

  // ---------- Sidebar Item ----------
  Widget _sidebarItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: AppColors.primary.withOpacity(0.1),
        tileColor: Colors.white,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}
