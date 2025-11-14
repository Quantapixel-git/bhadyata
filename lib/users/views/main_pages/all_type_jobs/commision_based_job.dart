import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class CommissionAllJobsPage extends StatefulWidget {
  const CommissionAllJobsPage({super.key});

  @override
  State<CommissionAllJobsPage> createState() => _CommissionAllJobsPageState();
}

class _CommissionAllJobsPageState extends State<CommissionAllJobsPage> {
  String selectedCategory = "All";
  String selectedLocation = "All";
  final TextEditingController searchController = TextEditingController();

  final List<String> categories = [
    "All",
    "Sales",
    "Insurance",
    "Real Estate",
    "Marketing",
    "Finance",
    "Retail",
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
      "title": "Insurance Lead Generator",
      "company": "HDFC Life",
      "location": "Remote",
      "commission": "Up to ₹2,000 per policy",
      "type": "Insurance",
    },
    {
      "title": "Real Estate Agent",
      "company": "DreamHomes Realty",
      "location": "Delhi",
      "commission": "2% per sale",
      "type": "Real Estate",
    },
    {
      "title": "Affiliate Marketing Partner",
      "company": "PromoMax India",
      "location": "Remote",
      "commission": "₹500 per sale",
      "type": "Marketing",
    },
    {
      "title": "Credit Card Lead Agent",
      "company": "FinServe Pvt Ltd",
      "location": "Bangalore",
      "commission": "₹300 per approved card",
      "type": "Finance",
    },
    {
      "title": "Retail Product Promoter",
      "company": "BrightRetail",
      "location": "Mumbai",
      "commission": "₹150 per lead",
      "type": "Retail",
    },
  ];

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        elevation: 3,
        backgroundColor: AppColors.primary,
        title: const Text(
          "Commission-Based Jobs",
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
          // 🔍 Search + Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "What (Job title, keywords, or company)",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showLocationPicker(context),
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
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                          setState(() => selectedCategory = category);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🧾 Job Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: filteredJobs.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "No matching commission jobs found",
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
                          return _CommissionJobCard(job: job);
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
          child: Wrap(
            runSpacing: 10,
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
        );
      },
    );
  }
}

class _CommissionJobCard extends StatefulWidget {
  final Map<String, dynamic> job;
  const _CommissionJobCard({required this.job});

  @override
  State<_CommissionJobCard> createState() => _CommissionJobCardState();
}

class _CommissionJobCardState extends State<_CommissionJobCard> {
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
            Text(
              job["title"],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              job["company"],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
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
            Text(
              job["commission"],
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: applied
                  ? null
                  : () {
                      setState(() => applied = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
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
