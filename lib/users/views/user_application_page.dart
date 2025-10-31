import 'package:flutter/material.dart';
import 'package:jobshub/users/views/home_page.dart';
import 'package:jobshub/users/views/kyc_screen.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/user_sidedrawer.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class UserMyApplicationsPage extends StatelessWidget {
  const UserMyApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> appliedJobs = [
      {
        "title": "Flutter Developer",
        "company": "Microsoft",
        "location": "Bangalore",
        "status": "Under Review",
        "salary": "₹12 - 15 LPA",
        "workType": "Full-time",
        "appliedOn": "5 Sep 2025",
      },
      {
        "title": "Marketing Manager",
        "company": "Flipkart",
        "location": "Delhi",
        "status": "Interview Scheduled",
        "salary": "₹9 - 12 LPA",
        "workType": "Hybrid",
        "appliedOn": "2 Sep 2025",
      },
      {
        "title": "UI Designer",
        "company": "Canva",
        "location": "Remote",
        "status": "Applied",
        "salary": "\$60k - \$80k",
        "workType": "Remote",
        "appliedOn": "1 Sep 2025",
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth > 600;
        final int crossAxisCount = isWeb ? 2 : 1;
        final double horizontalPadding = isWeb ? 80 : 16;

        return Scaffold(
          appBar: isWeb
          ? null : AppBar(
            title:
            const Text(
              "My Applications",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primary,
            centerTitle: isWeb,
          ),
          body: Row(
            children: [
               const AppDrawer(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: isWeb ? 3 : 3.5,
                    ),
                    itemCount: appliedJobs.length,
                    itemBuilder: (context, index) {
                      final job = appliedJobs[index];
                      return _HoverApplicationCard(
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
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HoverApplicationCard extends StatefulWidget {
  final Map<String, String> job;
  final bool isWeb;
  final VoidCallback onTap;

  const _HoverApplicationCard({
    required this.job,
    required this.isWeb,
    required this.onTap,
  });

  @override
  State<_HoverApplicationCard> createState() => _HoverApplicationCardState();
}

class _HoverApplicationCardState extends State<_HoverApplicationCard> {
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
            : [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            child: const Icon(Icons.work, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.job["title"] ?? "",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("${widget.job["company"]} • ${widget.job["location"]}"),
                const SizedBox(height: 6),
                Text(
                  "Status: ${widget.job["status"]}",
                  style: TextStyle(
                    color: widget.job["status"] == "Applied"
                        ? Colors.orange
                        : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onTap,
            icon: const Icon(Icons.arrow_forward_ios, color: AppColors.primary),
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
    final bool isWeb = MediaQuery.of(context).size.width > 900;

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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.1),
                                child: const Icon(Icons.work,
                                    color: AppColors.primary, size: 32),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(job["title"]!,
                                        style: TextStyle(
                                            fontSize: isWeb ? 28 : 22,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${job["company"]} • ${job["location"]}",
                                      style: TextStyle(
                                          fontSize: isWeb ? 18 : 14,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Status / Chips Card
                        _WebCard(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              _HoverChip(
                                label: job["status"] ?? "Applied",
                                color: Colors.blue,
                              ),
                              _HoverChip(
                                label: "💰 ${job["salary"] ?? "Not specified"}",
                                color: Colors.green,
                              ),
                              _HoverChip(
                                label: "🕒 ${job["workType"] ?? "N/A"}",
                                color: Colors.orange,
                              ),
                              _HoverChip(
                                label: "📅 ${job["appliedOn"] ?? "Unknown"}",
                                color: Colors.purple,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Job Description Card
                        _WebCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Job Description",
                                  style: TextStyle(
                                      fontSize: isWeb ? 22 : 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Text(
                                job["description"] ??
                                    "This is a detailed description of the job role. "
                                        "It includes key responsibilities, skills required, and other details.",
                                style: TextStyle(
                                    fontSize: isWeb ? 16 : 14,
                                    color: Colors.black87,
                                    height: 1.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 120), // leave space for sticky button
                      ],
                    ),
                  ),
                ),

                // Sticky Apply Button
                Align(
                  alignment:
                      isWeb ? Alignment.bottomRight : Alignment.bottomCenter,
                  child: SizedBox(
                    width: isWeb ? 280 : double.infinity,
                    child: _HoverApplyButton(
                      label: "Apply Now",
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => KycStepperPage()),
                          (route) => false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Applied for ${job["title"]}")),
                        );
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
  }
}

/// Hoverable Card (for web design look)
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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

/// Hoverable Chip
class _HoverChip extends StatelessWidget {
  final String label;
  final Color color;
  const _HoverChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Chip(
        label: Text(label),
        backgroundColor: color.withOpacity(0.1),
        labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

/// Hoverable Apply Button
class _HoverApplyButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _HoverApplyButton({required this.label, required this.onTap});

  @override
  State<_HoverApplyButton> createState() => _HoverApplyButtonState();
}

class _HoverApplyButtonState extends State<_HoverApplyButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform:
            _hovering ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

// Hoverable Button Widget
class _HoverButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _HoverButton({required this.label, required this.onTap});

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    Widget button = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: _hovered && isWeb ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity(),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    if (isWeb) {
      button = MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: button,
      );
    }

    return button;
  }
}
