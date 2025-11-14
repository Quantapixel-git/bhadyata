import 'package:flutter/material.dart';
// import 'package:jobshub/common/utils/app_color.dart';

class OneTimeRecruitmentAllJobsPage extends StatefulWidget {
  const OneTimeRecruitmentAllJobsPage({super.key});

  @override
  State<OneTimeRecruitmentAllJobsPage> createState() =>
      _OneTimeRecruitmentAllJobsPageState();
}

class _OneTimeRecruitmentAllJobsPageState
    extends State<OneTimeRecruitmentAllJobsPage> {
  String selectedCategory = "All";
  String selectedLocation = "All";
  final TextEditingController searchController = TextEditingController();

  final List<String> categories = [
    "All",
    "Event",
    "Marketing",
    "Data Entry",
    "Labor",
    "Admin Support",
    "Promotions",
  ];

  final List<String> locations = [
    "All",
    "Remote",
    "Delhi",
    "Mumbai",
    "Bangalore",
    "Pune",
    "Hyderabad",
    "Chennai",
  ];

  final List<Map<String, dynamic>> jobs = [
    {
      "title": "Event Helper (1-Day Job)",
      "company": "Star Events Co.",
      "location": "Pune, India",
      "date": "2 Nov 2025",
      "pay": "₹1,200 / Day",
      "type": "Event",
      "desc":
          "Assist in event setup, manage guests, and coordinate logistics. Suitable for college students or part-timers.",
    },
    {
      "title": "Promotional Staff",
      "company": "Glow Marketing Pvt Ltd",
      "location": "Delhi, India",
      "date": "5–6 Nov 2025",
      "pay": "₹800 / Day + Incentives",
      "type": "Promotions",
      "desc":
          "Distribute flyers and promote new brand products at malls. Only 2-day work.",
    },
    {
      "title": "Data Collection Agent (Field)",
      "company": "Census India",
      "location": "Hyderabad, India",
      "date": "10–12 Nov 2025",
      "pay": "₹3,000 for project",
      "type": "Data Entry",
      "desc":
          "Collect demographic data from households. Requires Android phone and communication skills.",
    },
    {
      "title": "Warehouse Loading Assistant",
      "company": "QuickShift Logistics",
      "location": "Bangalore, India",
      "date": "31 Oct 2025",
      "pay": "₹1,000 / Day + Meals",
      "type": "Labor",
      "desc":
          "Assist in warehouse loading/unloading for one day. Physically active work.",
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
          selectedLocation == "All" ||
          job["location"].toString().toLowerCase().contains(
            selectedLocation.toLowerCase(),
          );
      final matchesSearch =
          job["title"].toLowerCase().contains(query) ||
          job["company"].toLowerCase().contains(query);
      return matchesCategory && matchesLocation && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "One-Time Recruitment",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 🔍 Search + Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search field (What)
                TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "What (role, keywords, or company)...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Where field (tap to choose location)
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
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Category chips
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
                        selectedColor: Colors.orange,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
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

          // 🧾 Job Cards
          Expanded(
            child: filteredJobs.isEmpty
                ? const Center(
                    child: Text(
                      "No one-time recruitment jobs found.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 40 : 16,
                      vertical: 10,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWeb ? 3 : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isWeb ? 1.25 : 1.5,
                    ),
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];
                      return _OneTimeJobCard(job: job);
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
                    selectedColor: Colors.orange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
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

class _OneTimeJobCard extends StatefulWidget {
  final Map<String, dynamic> job;
  const _OneTimeJobCard({required this.job});

  @override
  State<_OneTimeJobCard> createState() => _OneTimeJobCardState();
}

class _OneTimeJobCardState extends State<_OneTimeJobCard> {
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
            ? (Matrix4.identity()..scale(1.02))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: hovering ? Colors.orange.withOpacity(0.3) : Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 6),
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 6),

            // Company Name
            Text(
              job["company"],
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 6),

            // Location
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
            const SizedBox(height: 8),

            // Description
            Expanded(
              child: Text(
                job["desc"],
                style: const TextStyle(color: Colors.black87, height: 1.3),
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(height: 8),

            // Date + Pay
            Text(
              "📅 Date: ${job["date"]}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              "💰 Pay: ${job["pay"]}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Apply Button
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
                backgroundColor: applied ? Colors.grey.shade400 : Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
