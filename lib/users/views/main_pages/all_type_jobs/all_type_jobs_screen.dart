import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';
import 'package:jobshub/users/views/main_pages/all_type_jobs/commision_based_job.dart';
import 'package:jobshub/users/views/main_pages/all_type_jobs/onetime_recrutment_ui.dart';
import 'package:jobshub/users/views/main_pages/all_type_jobs/projects_ui.dart';
import 'package:jobshub/users/views/main_pages/all_type_jobs/salary_based_job_ui.dart';
import 'package:jobshub/common/utils/app_color.dart';

class AllJobsPage extends StatelessWidget {
  const AllJobsPage({super.key});

  @override
  Widget build(BuildContext context) {

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
        "subtitle": "Earn money for every lead or sale.",
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth > 900;
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),

          // ✅ Drawer only for mobile
          drawer: isWeb ? null : AppDrawer(),

          // ✅ AppBar only for mobile
          appBar: isWeb
              ? null
              : AppBar(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  centerTitle: true,
                  title: const Text(
                    "All Jobs",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  leading: Builder(
                    builder: (context) => IconButton(
                      iconSize: 34,
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ),

          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 50 : 20,
                  vertical: isWeb ? 40 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🌟 Header (only on web)
                    if (isWeb)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Explore Opportunities",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // 🌟 Carousel Section
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: isWeb ? 320 : 160,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: isWeb ? 0.8 : 0.9,
                          autoPlayInterval: const Duration(seconds: 4),
                          autoPlayAnimationDuration: const Duration(
                            milliseconds: 900,
                          ),
                        ),
                        items: carouselImages.map((imageUrl) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(imageUrl, fit: BoxFit.contain),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black54,
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      "Choose Your Job Type",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Find opportunities that match your skills and goals.",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 35),

                    // 🌈 Job Type Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 30),
                      itemCount: jobCategories.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: isWeb ? 480 : 600,
                        crossAxisSpacing: 25,
                        mainAxisSpacing: 25,
                        childAspectRatio: isWeb ? 1.4 : 1.8,
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
                            MaterialPageRoute(
                              builder: (_) => job["page"] as Widget,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
      child: AnimatedScale(
        scale: hovering ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
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
                blurRadius: hovering ? 20 : 10,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 46),
                  const Spacer(),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.5,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    opacity: hovering ? 1 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Container(
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
      ),
    );
  }
}
