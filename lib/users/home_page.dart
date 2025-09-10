import 'package:flutter/material.dart';
import 'package:jobshub/users/user_assigned_projects_screen.dart';
import 'package:jobshub/users/applicans_page.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/users/user_browser_project.dart';
import 'package:jobshub/users/user_model.dart';
import 'package:jobshub/users/user_work_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔹 Drawer Added
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: const Text("John Doe"),
              accountEmail: const Text("johndoe@email.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text("Projects"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile page later
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BrowseProjectsScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
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

            /// My Applications
            ListTile(
              leading: const Icon(Icons.work, color: Colors.blue),
              title: const Text("My Applications"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to My Applications page later
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyApplicationsPage()),
                );
              },
            ),

            const Divider(),

            /// Logout
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
            /// 🔹 Header with Search Bar
            _buildHeader(context),

            const SizedBox(height: 16),

            /// 🔹 Promo Banner
            _buildPromoBanner(),

            const SizedBox(height: 20),

            /// 🔹 Quick Steps
            _buildQuickSteps(context),

            const SizedBox(height: 20),

            /// 🔹 Featured Jobs
            _buildFeaturedJobs(),

            const SizedBox(height: 20),

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
          colors: [Color(0xFF1976D2), Color(0xFF42A5F5)], // Blue gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ✅ AppBar inside header
          AppBar(
            backgroundColor: Colors.transparent, // transparent over gradient
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
                  Scaffold.of(context).openDrawer(); // opens drawer
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// Section Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Trending Jobs",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// Trending Jobs Icons
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

  /// 🔹 Promo Banner
  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
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
          const Icon(Icons.work, size: 48, color: Colors.blue),
        ],
      ),
    );
  }

  /// 🔹 Quick Steps
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
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
              _StepWidget(icon: Icons.work, text: "Apply Jobs"),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
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
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Start Now",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Featured Jobs Section
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

  /// 🔹 Section Title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 🔹 Job Category Icon Widget
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
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 🔹 Job Card
  Widget _jobCard(String title, String company, String location) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(company, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.blue),
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
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Steps Widget
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
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue, size: 24),
        ),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

/// 🔹 Page to Navigate when "Start Now" is clicked
class StartNowPage extends StatelessWidget {
  const StartNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
