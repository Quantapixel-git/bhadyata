import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class SalaryAllJobsPage extends StatefulWidget {
  const SalaryAllJobsPage({super.key});

  @override
  State<SalaryAllJobsPage> createState() => _SalaryAllJobsPageState();
}

class _SalaryAllJobsPageState extends State<SalaryAllJobsPage> {
  String selectedCategory = "All";
  String selectedLocation = "All";
  final TextEditingController searchController = TextEditingController();

  final List<String> categories = [
    "All",
    "IT & Software",
    "Marketing",
    "Finance",
    "Design",
    "HR",
    "Sales",
  ];

  final List<String> locations = [
    "All",
    "Remote",
    "Delhi",
    "Mumbai",
    "Bangalore",
    "Pune",
  ];

  final List<Map<String, dynamic>> jobs = [
    {
      "title": "Flutter Developer",
      "company": "TechNova Pvt Ltd",
      "location": "Remote",
      "salary": "₹40,000 - ₹70,000/month",
      "type": "IT & Software",
    },
    {
      "title": "Marketing Executive",
      "company": "GrowMore Agency",
      "location": "Bangalore",
      "salary": "₹25,000 - ₹50,000/month",
      "type": "Marketing",
    },
    {
      "title": "Finance Analyst",
      "company": "FinEdge",
      "location": "Delhi",
      "salary": "₹50,000 - ₹90,000/month",
      "type": "Finance",
    },
    {
      "title": "UI/UX Designer",
      "company": "CreativePixels",
      "location": "Pune",
      "salary": "₹35,000 - ₹60,000/month",
      "type": "Design",
    },
    {
      "title": "Sales Associate",
      "company": "BrightWorks",
      "location": "Mumbai",
      "salary": "₹20,000 - ₹45,000/month",
      "type": "Sales",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    final filteredJobs = jobs.where((job) {
      final query = searchController.text.toLowerCase();
      final matchesCategory =
          selectedCategory == "All" || job["type"] == selectedCategory;
      final matchesLocation =
          selectedLocation == "All" || job["location"] == selectedLocation;
      final matchesSearch =
          job["title"].toLowerCase().contains(query) ||
          job["company"].toLowerCase().contains(query);
      return matchesCategory && matchesLocation && matchesSearch;
    }).toList();

    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      // appBar: AppBar(
      //   elevation: 3,
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //     ),
      //   ),
      //   title: const Text(
      //     "Salary-Based Jobs",
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       // color: Colors.white,
      //       letterSpacing: 0.5,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
       appBar: AppBar(
        elevation: 3,
        backgroundColor: AppColors.primary,
        title: const Text(
          "Salary-Based Jobs",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 🔍 Search + Filters Section
          // 🔍 Indeed-Style Search Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧠 Search Row (Job + Location fields)
                Column(
                  children: [
                    // What Field
                    TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: "What (Job title, keywords, or company)",
                        prefixIcon: const Icon(
                          Icons.work_outline,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Where Field
                    GestureDetector(
                      onTap: () {
                        _showLocationPicker(context);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: selectedLocation == "All"
                                ? "Where (Location)"
                                : selectedLocation,
                            prefixIcon: const Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Category filter chips
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),

                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedCategory == category;
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        elevation: 1,
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🧾 Job Cards Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: filteredJobs.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "No matching jobs found",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final isWeb = constraints.maxWidth > 800;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWeb ? 3 : 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: isWeb ? 1.2 : 1.5,
                        ),
                        itemCount: filteredJobs.length,
                        itemBuilder: (context, index) {
                          final job = filteredJobs[index];
                          return _JobCard(job: job);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: locations.map((loc) {
                  final isSelected = selectedLocation == loc;
                  return ChoiceChip(
                    label: Text(loc),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) {
                      setState(() => selectedLocation = loc);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _JobCard extends StatefulWidget {
  final Map<String, dynamic> job;
  const _JobCard({required this.job});

  @override
  State<_JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<_JobCard> {
  bool hovering = false;
  bool applied = false;

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: hovering
            ? (Matrix4.identity()..scale(1.03))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: hovering
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Title
            Text(
              job["title"],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),

            // Company
            Text(
              job["company"],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            // Location Row
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  job["location"],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const Spacer(),

            // Salary
            Text(
              job["salary"],
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 12),

            // Apply Button
            ElevatedButton.icon(
              onPressed: applied
                  ? null
                  : () {
                      setState(() => applied = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.primary,
                          content: Text(
                            "Applied for '${job["title"]}' successfully!",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
              icon: Icon(
                applied ? Icons.check_circle_outline : Icons.send,
                size: 18,
              ),
              label: Text(applied ? "Applied" : "Apply Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: applied
                    ? Colors.grey.shade400
                    : AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 42),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
