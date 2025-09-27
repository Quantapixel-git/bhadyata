import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jobshub/users/user_assigned_projects_screen.dart';
import 'package:jobshub/users/applicans_page.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/users/user_browser_project.dart';
import 'package:jobshub/utils/AppColor.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ✅ Web layout (larger screens or web)
        if (kIsWeb && constraints.maxWidth > 800) {
          return const HomePageWeb();
        }
        // ✅ Mobile layout (your existing UI)
        return const HomePageMobile();
      },
    );
  }
}

//
// 🔹 Mobile Home Page (your existing design)
//
class HomePageMobile extends StatelessWidget {
  const HomePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// 🔹 Drawer Added
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 246, 32, 175), Color.fromARGB(255, 178, 82, 188)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: const Text("John Doe"),
              accountEmail: const Text("johndoe@email.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: AppColors.primary),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primary),
              title: const Text("Projects"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BrowseProjectsScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.work, color: AppColors.primary),
              title: const Text("User Work"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserAssignedProjectsScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.assignment, color: AppColors.primary),
              title: const Text("My Applications"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyApplicationsPage()),
                );
              },
            ),

             ListTile(
              leading: const Icon(Icons.contact_page, color: AppColors.primary),
              title: const Text("Contact Us"),
              onTap: () {
              },
            ),

             ListTile(
              leading: const Icon(Icons.terminal_sharp, color: AppColors.primary),
              title: const Text("Terms & Conditions"),
              onTap: () {
              },
            ),

             ListTile(
              leading: const Icon(Icons.notifications, color: AppColors.primary),
              title: const Text("Notifications"),
              onTap: () {
              },
            ),
             ListTile(
              leading: const Icon(Icons.reviews, color: AppColors.primary),
              title: const Text("Review"),
              onTap: () {
              },
            ),
             ListTile(
              leading: const Icon(Icons.help, color: AppColors.primary),
              title: const Text("Help Support"),
              onTap: () {
              },
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildPromoBanner(),
            const SizedBox(height: 20),
            _buildQuickSteps(context),
            const SizedBox(height: 20),
            _buildFeaturedJobs(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 🔹 Header with AppBar + Search
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
           colors: [AppColors.primary, Color.fromARGB(255, 228, 85, 159)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search for jobs or services",
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Trending Jobs",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildJobCategory("Designer", Icons.design_services),
                _buildJobCategory("Developer", Icons.code),
                _buildJobCategory("Delivery", Icons.delivery_dining),
                _buildJobCategory("Teacher", Icons.school),
                _buildJobCategory("Driver", Icons.local_taxi),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Get Your Dream Job",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                  "One stop solution for all your career and freelancing needs.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          const Icon(Icons.work, size: 48, color: AppColors.primary),
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
          const Text("Get Hired in 3 Easy Steps",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _StepWidget(icon: Icons.person, text: "Create Profile"),
              Icon(Icons.arrow_forward_ios, size: 16,),
              _StepWidget(icon: Icons.work, text: "Apply Jobs"),
              Icon(Icons.arrow_forward_ios, size: 16,),
              _StepWidget(icon: Icons.check_circle, text: "Get Hired"),
            ],
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StartNowPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Start Now",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedJobs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Featured Jobs"),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _jobCard("UI/UX Designer", "Google", "Remote"),
              _jobCard("Flutter Developer", "Microsoft", "Bangalore"),
              _jobCard("Delivery Executive", "Zomato", "Mumbai"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );

  static Widget _buildJobCategory(String title, IconData icon) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.white),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.white),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _jobCard(String title, String company, String location) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text("Apply",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

//
// 🔹 Web Home Page
//
class HomePageWeb extends StatelessWidget {
  const HomePageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search jobs or services...",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          /// 🔹 Left Drawer Sidebar
          Container(
            width: 220,
            color: AppColors.primary,
            child: ListView(
              children: [
                const DrawerHeader(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: AppColors.primary),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.work, color: AppColors.primary),
                  title: const Text("Projects"),
                  onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => BrowseProjectsScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment, color: AppColors.primary),
                  title: const Text("User Work"),
                  onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => UserAssignedProjectsScreen()));

                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment_turned_in,
                      color: AppColors.primary),
                  title: const Text("My Applications"),
                  onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MyApplicationsPage()));

                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout"),
                  onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));

                  },
                ),
              ],
            ),
          ),

          /// 🔹 Main Content
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Trending Jobs",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _jobCategoryCard("Designer", Icons.design_services),
                        _jobCategoryCard("Developer", Icons.code),
                        _jobCategoryCard("Delivery", Icons.delivery_dining),
                        _jobCategoryCard("Teacher", Icons.school),
                        _jobCategoryCard("Driver", Icons.local_taxi),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text("Featured Jobs",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _jobCard("UI/UX Designer", "Google", "Remote"),
                        _jobCard("Flutter Developer", "Microsoft", "Bangalore"),
                        _jobCard("Delivery Executive", "Zomato", "Mumbai"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _jobCategoryCard(String title, IconData icon) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: AppColors.primary),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  static Widget _jobCard(String title, String company, String location) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(company, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(location),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {},
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text("Apply"),
            ),
          ),
        ],
      ),
    );
  }
}

//
// 🔹 Step Widget
//
class _StepWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  const _StepWidget({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class StartNowPage extends StatelessWidget {
  const StartNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primary, title: const Text("Get Started")),
      body: const Center(
        child: Text("Welcome! Let's get started 🚀",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
