import 'package:flutter/material.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/user_sidedrawer.dart';
import 'package:jobshub/common/utils/AppColor.dart';

//
// 🔹 Jobs Page (Categories)
//
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"title": "IT Jobs", "icon": Icons.computer},
      {"title": "Marketing Jobs", "icon": Icons.campaign},
      {"title": "Healthcare Jobs", "icon": Icons.health_and_safety},
      {"title": "Finance Jobs", "icon": Icons.account_balance},
      {"title": "Design Jobs", "icon": Icons.design_services},
      {"title": "Education Jobs", "icon": Icons.school},
      {"title": "Logistics Jobs", "icon": Icons.local_shipping},
      {"title": "Government Jobs", "icon": Icons.account_balance_wallet},
      {"title": "Customer Service", "icon": Icons.headset_mic},
      {"title": "Sales Jobs", "icon": Icons.store},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth > 600;
        return Scaffold(
          appBar: isWeb
              ? null
              : AppBar(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  centerTitle: true,
                  title: const Text(
                    "Jobs",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  leading: Builder(
                    builder: (context) => IconButton(
                      iconSize: 40, // 👈 larger menu icon
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ),

          drawer: AppDrawer(),
          body: Column(
            children: [
              // 🔹 Search Bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 80 : 16,
                  vertical: 16,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: isWeb ? 500 : double.infinity,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for jobs...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: isWeb ? Colors.grey.shade100 : Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 🔹 Categories Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 80 : 16,
                    vertical: 16,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWeb ? 4 : 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: isWeb ? 1.3 : 1.1,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _HoverJobCard(
                      title: category["title"],
                      icon: category["icon"],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                JobsCategoryPage(category: category["title"]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//
// 🔹 Hover Card for Category
//
class _HoverJobCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _HoverJobCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_HoverJobCard> createState() => _HoverJobCardState();
}

class _HoverJobCardState extends State<_HoverJobCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: _isHovered && isWeb
          ? (Matrix4.identity()..scale(1.05))
          : Matrix4.identity(),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isHovered && isWeb
            ? [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, size: 40, color: AppColors.white),
          const SizedBox(height: 10),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );

    if (isWeb) {
      card = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: card,
      );
    }

    return GestureDetector(onTap: widget.onTap, child: card);
  }
}

//
// 🔹 Jobs Category Page
//
class JobsCategoryPage extends StatelessWidget {
  final String category;
  const JobsCategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 600;
    final Map<String, List<Map<String, String>>> jobsData = {
      "IT Jobs": [
        {
          "title": "Flutter Developer",
          "company": "Microsoft",
          "location": "Bangalore",
          "salary": "₹10 - 15 LPA",
          "type": "Full-time",
          "description":
              "Develop mobile applications using Flutter and Dart, Develop mobile applications using Flutter and Dart, Develop mobile applications using Flutter and Dart., Develop mobile applications using Flutter and Dart. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        },
        {
          "title": "Backend Engineer",
          "company": "Amazon",
          "location": "Hyderabad",
          "salary": "₹12 - 18 LPA",
          "type": "Hybrid",
          "description": "Build and maintain scalable backend services.",
        },
      ],
      "Marketing Jobs": [
        {
          "title": "Marketing Manager",
          "company": "Flipkart",
          "location": "Delhi",
          "salary": "₹8 - 12 LPA",
          "type": "Full-time",
          "description": "Lead marketing campaigns and strategy.",
        },
      ],
    };

    final jobs = jobsData[category] ?? [];

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primary, title: Text(category)),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWeb ? 80 : 16,
          vertical: 16,
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 3 : 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: isWeb ? 2.5 : 3.5,
          ),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return _HoverJobCardCategory(
              job: job,
              isWeb: isWeb,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => JobDetailPage(job: job)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

//
// 🔹 Hoverable Job Card in Category
//
class _HoverJobCardCategory extends StatefulWidget {
  final Map<String, String> job;
  final bool isWeb;
  final VoidCallback onTap;
  const _HoverJobCardCategory({
    required this.job,
    required this.isWeb,
    required this.onTap,
  });

  @override
  State<_HoverJobCardCategory> createState() => _HoverJobCardCategoryState();
}

class _HoverJobCardCategoryState extends State<_HoverJobCardCategory> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: _isHovered && widget.isWeb
          ? (Matrix4.identity()..scale(1.03))
          : Matrix4.identity(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: _isHovered && widget.isWeb
            ? [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.job["title"] ?? "",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            widget.job["company"] ?? "",
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                widget.job["location"] ?? "",
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: widget.onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text("View"),
            ),
          ),
        ],
      ),
    );

    if (widget.isWeb) {
      card = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: card,
      );
    }

    return GestureDetector(onTap: widget.onTap, child: card);
  }
}

class JobDetailPage extends StatelessWidget {
  final Map<String, String> job;
  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth > 900;

        return Scaffold(
          appBar: AppBar(
            title: Text(job["title"]!),
            backgroundColor: AppColors.primary,
            centerTitle: true,
            elevation: 0,
          ),
          backgroundColor: Colors.grey.shade100,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header Card
                            _WebCard(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.1),
                                    child: const Icon(
                                      Icons.work,
                                      color: AppColors.primary,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          job["title"]!,
                                          style: TextStyle(
                                            fontSize: isWeb ? 32 : 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "${job["company"]} • ${job["location"]}",
                                          style: TextStyle(
                                            fontSize: isWeb ? 18 : 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Chips Section
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                _HoverChip(
                                  label: job["type"] ?? "N/A",
                                  color: Colors.orange,
                                ),
                                _HoverChip(
                                  label: job["salary"] ?? "Not specified",
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),

                            // Job Description Card
                            _WebCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Job Description",
                                    style: TextStyle(
                                      fontSize: isWeb ? 24 : 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    job["description"] ??
                                        "No description provided",
                                    style: TextStyle(
                                      fontSize: isWeb ? 18 : 16,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 120,
                            ), // leave space for button
                          ],
                        ),
                      ),
                    ),

                    // Sticky Apply Button
                    Align(
                      alignment: isWeb
                          ? Alignment.bottomRight
                          : Alignment.bottomCenter,
                      child: SizedBox(
                        width: isWeb ? 250 : double.infinity,
                        child: _HoverApplyButton(
                          label: "Apply Now",
                          onTap: () {
                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => KycStepperPage()),
                            //     (route) => false);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //       content: Text("Applied for ${job["title"]}")),
                            // );
                          },
                        ),
                      ),
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

/// Reusable card with hover effect for web feel
class _WebCard extends StatefulWidget {
  final Widget child;
  const _WebCard({required this.child});

  @override
  State<_WebCard> createState() => _WebCardState();
}

class _WebCardState extends State<_WebCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: _hovering ? 16 : 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

// Hoverable Chip for Web
class _HoverChip extends StatefulWidget {
  final String label;
  final Color color;

  const _HoverChip({required this.label, required this.color});

  @override
  State<_HoverChip> createState() => _HoverChipState();
}

class _HoverChipState extends State<_HoverChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.color.withOpacity(0.2)
              : widget.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: widget.color.withOpacity(0.4)),
        ),
        child: Text(
          widget.label,
          style: TextStyle(color: widget.color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// Hoverable Apply Button for Web
class _HoverApplyButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _HoverApplyButton({required this.label, required this.onTap});

  @override
  State<_HoverApplyButton> createState() => _HoverApplyButtonState();
}

class _HoverApplyButtonState extends State<_HoverApplyButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered
                ? AppColors.primary.withOpacity(0.8)
                : AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
          ),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
