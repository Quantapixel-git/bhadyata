import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/users/applicans_page.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/users/user_application_page.dart';
import 'package:jobshub/users/user_contact_page.dart';
import 'package:jobshub/users/user_help_support_screen.dart';
import 'package:jobshub/users/user_leave_request.dart';
import 'package:jobshub/users/work_assignment_screen.dart';
import 'package:jobshub/utils/AppColor.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // 🔹 Global Key for Scaffold
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = kIsWeb && constraints.maxWidth > 800;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawer: const AppDrawer(),
          appBar: !isWeb
              ? AppBar(
                  elevation: 0,
                  title: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "Search for jobs or services",
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () =>
                        _scaffoldKey.currentState?.openDrawer(), // ✅ works now
                  ),
                  backgroundColor: AppColors.primary,
                )
              : null, // No AppBar for Web
          // 🔹 Fullscreen Body
          body: SizedBox.expand(
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 60 : 0,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        if (!isWeb) _buildPromoBanner(),
                        if (!isWeb) const SizedBox(height: 20),
                        if (!isWeb) _buildQuickSteps(context),
                        if (!isWeb) const SizedBox(height: 20),

                        // 🔹 Web Search Bar
                        if (isWeb)
                          Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              width: 600,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search jobs or services...",
                                  prefixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 40),

                        // 🔹 Trending Jobs
                        Text(
                          "Trending Jobs",
                          style: TextStyle(
                            fontSize: isWeb ? 26 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (isWeb)
                          GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.8,
                            children: [
                              _HoverJobCategory(
                                "Designer",
                                Icons.design_services,
                              ),
                              _HoverJobCategory("Developer", Icons.code),
                              _HoverJobCategory(
                                "Delivery",
                                Icons.delivery_dining,
                              ),
                              _HoverJobCategory("Teacher", Icons.school),
                              _HoverJobCategory("Driver", Icons.local_taxi),
                            ],
                          )
                        else
                          SizedBox(
                            height: 90,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                _jobCategory("Designer", Icons.design_services),
                                _jobCategory("Developer", Icons.code),
                                _jobCategory("Delivery", Icons.delivery_dining),
                                _jobCategory("Teacher", Icons.school),
                                _jobCategory("Driver", Icons.local_taxi),
                              ],
                            ),
                          ),

                        const SizedBox(height: 40),

                        // 🔹 Featured Jobs
                        Text(
                          "Featured Jobs",
                          style: TextStyle(
                            fontSize: isWeb ? 26 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (isWeb)
                          GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.3,
                            children: [
                              _HoverJobCard(
                                "UI/UX Designer",
                                "Google",
                                "Remote",
                              ),
                              _HoverJobCard(
                                "Flutter Developer",
                                "Microsoft",
                                "Bangalore",
                              ),
                              _HoverJobCard(
                                "Delivery Executive",
                                "Zomato",
                                "Mumbai",
                              ),
                            ],
                          )
                        else
                          SizedBox(
                            height: 160,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                _jobCard("UI/UX Designer", "Google", "Remote"),
                                _jobCard(
                                  "Flutter Developer",
                                  "Microsoft",
                                  "Bangalore",
                                ),
                                _jobCard(
                                  "Delivery Executive",
                                  "Zomato",
                                  "Mumbai",
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Get Your Dream Job",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "One stop solution for all your career and freelancing needs.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          Icon(Icons.work, size: 48, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildQuickSteps(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Get Hired in 3 Easy Steps",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _StepWidget(icon: Icons.person, text: "Create Profile"),
              Icon(Icons.arrow_forward_ios, size: 16),
              _StepWidget(icon: Icons.work, text: "Apply Jobs"),
              Icon(Icons.arrow_forward_ios, size: 16),
              _StepWidget(icon: Icons.check_circle, text: "Get Hired"),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Job Category (Mobile + Web)
  static Widget _jobCategory(
    String title,
    IconData icon, {
    bool isWeb = false,
  }) {
    return Container(
      width: isWeb ? 160 : 80,
      margin: EdgeInsets.only(right: isWeb ? 16 : 12),
      decoration: BoxDecoration(
        color: isWeb ? AppColors.primary : AppColors.primary.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isWeb ? 40 : 30, color: Colors.white),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(fontSize: isWeb ? 16 : 12, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 🔹 Job Card (Mobile + Web)
  static Widget _jobCard(
    String title,
    String company,
    String location, {
    bool isWeb = false,
  }) {
    return Container(
      width: isWeb ? 250 : 200,
      margin: EdgeInsets.only(right: isWeb ? 20 : 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWeb ? Colors.white : AppColors.primary.withOpacity(0.9),
        border: isWeb ? Border.all(color: Colors.grey.shade200) : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isWeb
            ? [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isWeb ? 18 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(company, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(location, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text("Apply"),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Step Widget
class _StepWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  const _StepWidget({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

/// 🔹 Hover Job Category (Web)
class _HoverJobCategory extends StatelessWidget {
  final String title;
  final IconData icon;
  const _HoverJobCategory(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 Hover Job Card (Web)
class _HoverJobCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  const _HoverJobCard(this.title, this.company, this.location);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(company, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(location, style: const TextStyle(color: Colors.black54)),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text("Apply"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// 🔹 Drawer (Shared for Web & Mobile)
//
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb && MediaQuery.of(context).size.width > 800;

    return Container(
      width: isWeb ? 260 : 220,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: isWeb
            ? [BoxShadow(color: Colors.black12, blurRadius: 8)]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: isWeb ? Colors.white : AppColors.white,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: isWeb ? AppColors.primary : Colors.white,
                  child: Image.asset("assets/job_bgr.png"),
                ),
              ],
            ),
          ),

          // 🔹 Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  context,
                  icon: Icons.work,
                  text: "Work Assignment",
                  page: WorkAssignmentScreen(),
                ),
                  _drawerItem(
                  context,
                  icon: Icons.work,
                  text: "Manage Leaves",
                  page: EmployeeLeaveRequestScreen(employeeName: "John Doe"),
                ),
                _drawerItem(
                  context,
                  icon: Icons.assignment,
                  text: "My Applications",
                  page: MyApplicationsPage(),
                ),
                _drawerItem(
                  context,
                  icon: Icons.contact_page,
                  text: "Contact Us",
                  page: UserContactUsPage(),
                ),
                _drawerItem(
                  context,
                  icon: Icons.help,
                  text: "Help Support",
                  page: UserHelpSupportPage(),
                ),
              ],
            ),
          ),

          // 🔹 Logout (Bottom)
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black87),
            title: const Text("Logout", style: TextStyle(color: Colors.black87)),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Widget page,
  }) {
    final bool isWeb = kIsWeb && MediaQuery.of(context).size.width > 800;

    return ListTile(
      leading: Icon(icon, color: isWeb ? Colors.black87 : Colors.black87),
      title: Text(
        text,
        style: TextStyle(color: isWeb ? Colors.black87 : Colors.black87),
      ),
      hoverColor: isWeb ? Colors.grey.shade200 : null,
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    );
  }
}

class StartNowPage extends StatelessWidget {
  const StartNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Get Started"),
      ),
      body: const Center(
        child: Text(
          "Welcome! Let's get started 🚀",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
