import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jobshub/users/view/commision_based_job.dart';
import 'package:jobshub/users/view/onetime_recrutment_ui.dart';
import 'package:jobshub/users/view/projects_ui.dart';
import 'package:jobshub/users/view/salary_based_job_ui.dart';
import 'package:jobshub/users/view/user_sidedrawer.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class AllJobsPage extends StatelessWidget {
  const AllJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 800;

    final jobCategories = [
      {
        "title": "Salary-Based Jobs",
        "subtitle": "Monthly salary roles in trusted companies.",
        "gradient": [Colors.blue.shade400, Colors.blue.shade700],
        "icon": Icons.work_outline_rounded,
        "page": const SalaryAllJobsPage(),
      },
      {
        "title": "Commission-Based Leads",
        "subtitle": "Earn money for every lead or sale you generate.",
        "gradient": [Colors.green.shade400, Colors.teal.shade700],
        "icon": Icons.trending_up_rounded,
        "page": const CommissionAllJobsPage(),
      },
      {
        "title": "One-Time Recruitment",
        "subtitle": "Short-term & event-based job opportunities.",
        "gradient": [Colors.orange.shade400, Colors.deepOrange.shade700],
        "icon": Icons.access_time_filled_rounded,
        "page": const OneTimeRecruitmentAllJobsPage(),
      },
      {
        "title": "Freelance Projects",
        "subtitle": "Work flexibly on exciting project-based jobs.",
        "gradient": [Colors.purple.shade400, Colors.deepPurple.shade700],
        "icon": Icons.folder_copy_rounded,
        "page": const AllProjectsPage(),
      },
    ];

    final carouselImages = [
      "assets/job_bgr.png",
      "assets/job_bgr.png",
      "assets/job_bgr.png",
      "assets/job_bgr.png",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Explore Opportunities",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 26),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWeb ? 60 : 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            // 🌟 Carousel Section
            CarouselSlider(
              options: CarouselOptions(
                height: isWeb ? 300 : 120,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: isWeb ? 0.1 : 0.35,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 900),
              ),
              items: carouselImages.map((imageUrl) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(imageUrl, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.05),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            const Text(
              "Choose Your Job Type",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text(
              "Find opportunities that match your skills.",
              style: TextStyle(fontSize: 15, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // 🌈 Job Type Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: jobCategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWeb
                      ? 2
                      : 1, // ✅ fewer columns for more space
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: isWeb ? 1.3 : 1.99, // ✅ larger cards
                ),
                itemBuilder: (context, index) {
                  final job = jobCategories[index];
                  return _JobTypeCard(
                    title: job["title"] as String,
                    subtitle: job["subtitle"] as String,
                    gradient: job["gradient"] as List<Color>,
                    icon: job["icon"] as IconData,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => job["page"] as Widget),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobTypeCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData icon;
  final VoidCallback onTap;

  const _JobTypeCard({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_JobTypeCard> createState() => _JobTypeCardState();
}

class _JobTypeCardState extends State<_JobTypeCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: widget.gradient.last.withOpacity(0.35),
              blurRadius: hovering ? 18 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(widget.icon, color: Colors.white, size: 42),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 13.5,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                AnimatedOpacity(
                  opacity: hovering ? 1 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "View Jobs →",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
