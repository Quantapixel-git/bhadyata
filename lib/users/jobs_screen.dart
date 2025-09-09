import 'package:flutter/material.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Jobs"),
      ),
      body: Column(
        children: [
          // 🔹 Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for jobs...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.blue.shade50,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🔹 Grid of Categories
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final String title = category["title"] as String;
                final IconData icon = category["icon"] as IconData;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobsCategoryPage(category: title),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 40, color: Colors.blue),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class JobsCategoryPage extends StatelessWidget {
  final String category;

  const JobsCategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Mock job data by category with more info
    final Map<String, List<Map<String, String>>> jobsData = {
      "IT Jobs": [
        {
          "title": "Flutter Developer",
          "company": "Microsoft",
          "location": "Bangalore",
          "salary": "₹10 - 15 LPA",
          "type": "Full-time",
          "description": "Develop mobile applications using Flutter and Dart."
        },
        {
          "title": "Backend Engineer",
          "company": "Amazon",
          "location": "Hyderabad",
          "salary": "₹12 - 18 LPA",
          "type": "Hybrid",
          "description": "Build and maintain scalable backend services."
        },
      ],
      "Marketing Jobs": [
        {
          "title": "Marketing Manager",
          "company": "Flipkart",
          "location": "Delhi",
          "salary": "₹8 - 12 LPA",
          "type": "Full-time",
          "description": "Lead marketing campaigns and strategy."
        },
      ],
    };

    final jobs = jobsData[category] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.work, color: Colors.blue),
            ),
            title: Text(job["title"]!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${job["company"]} • ${job["location"]}"),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.blue),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobDetailPage(job: job),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class JobDetailPage extends StatelessWidget {
  final Map<String, String> job;

  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job["title"]!),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job["title"]!,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(job["company"]!,
                style: const TextStyle(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.blue),
                const SizedBox(width: 5),
                Text(job["location"]!,
                    style:
                        const TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.monetization_on,
                    size: 18, color: Colors.green),
                const SizedBox(width: 5),
                Text(job["salary"] ?? "Not specified",
                    style:
                        const TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.orange),
                const SizedBox(width: 5),
                Text(job["type"] ?? "N/A",
                    style:
                        const TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Job Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(job["description"] ?? "No description provided",
                style: const TextStyle(fontSize: 15)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Applied for ${job["title"]}")),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text("Apply Now",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
