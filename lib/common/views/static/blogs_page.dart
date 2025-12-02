import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class BlogsPage extends StatelessWidget {
  const BlogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Demo blog data
    final List<Map<String, String>> blogList = [
      {
        "title": "How BADHYATA Helps Companies Hire Faster",
        "summary":
            "Learn how our intelligent HR tools streamline hiring with automated workflows and faster job approvals.",
        "image":
            "https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=900",
        "date": "28 Nov 2025",
      },
      {
        "title": "Top 5 Tips for Employees to Improve Productivity",
        "summary":
            "Boost your daily productivity with these actionable, science-backed suggestions used by top performers.",
        "image":
            "https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=900",
        "date": "10 Nov 2025",
      },
      {
        "title": "How HRs Can Manage Projects More Efficiently",
        "summary":
            "Project management for HR is changing fast. Learn new strategies for 2025 to keep things on track.",
        "image":
            "https://images.unsplash.com/photo-1551434678-e076c223a692?w=900",
        "date": "01 Dec 2025",
      },
      {
        "title": "The Future of Work: Remote, Hybrid & More",
        "summary":
            "Explore the future trends in the workplace and how companies can stay ahead of the curve.",
        "image":
            "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900",
        "date": "18 Oct 2025",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff3f4f8),
      appBar: AppBar(
        elevation: 0.8,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              "BADHYATA",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(width: 12),
            Container(width: 1, height: 22, color: Colors.grey.shade300),
            const SizedBox(width: 12),
            const Text(
              "Blogs",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      // Main Body
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 900;
            final int crossAxisCount = isWide
                ? 3
                : (constraints.maxWidth > 600 ? 2 : 1);
        
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------- Header Section --------
                      Text(
                        "Latest Articles",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Insights, tips & knowledge shared by our experts.",
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 24),
        
                      // -------- Grid of Blogs --------
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1,
                        ),
                        itemCount: blogList.length,
                        itemBuilder: (context, index) {
                          final blog = blogList[index];
        
                          return _blogCard(
                            title: blog["title"]!,
                            summary: blog["summary"]!,
                            image: blog["image"]!,
                            date: blog["date"]!,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------- Blog Card Widget ----------------

  Widget _blogCard({
    required String title,
    required String summary,
    required String date,
    required String image,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // --- Blog Image ---
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Image.network(image, fit: BoxFit.cover),
          ),

          // --- Blog Text Content ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  summary,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // --- Read More Button ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Read More",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
