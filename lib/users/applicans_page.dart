import 'package:flutter/material.dart';

class MyApplicationsPage extends StatelessWidget {
  const MyApplicationsPage({super.key});

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("My Applications"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appliedJobs.length,
        itemBuilder: (context, index) {
          final job = appliedJobs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.work, color: Colors.blue),
              ),
              title: Text(
                job["title"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text("${job["company"]} • ${job["location"]}"),
                  const SizedBox(height: 4),
                  Text(
                    "Status: ${job["status"]}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => JobDetailPage(job: job)),
                );
              },
            ),
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
      appBar: AppBar(title: Text(job["title"]!), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Info
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.work, color: Colors.blue, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job["title"]!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("${job["company"]} • ${job["location"]}"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Status
            Chip(
              label: Text(job["status"] ?? "Applied"),
              backgroundColor: Colors.green.shade100,
              labelStyle: const TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 20),

            // Job details
            Text(
              "💰 Salary: ${job["salary"]}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              "🕒 Work Type: ${job["workType"]}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              "📅 Applied On: ${job["appliedOn"]}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            const Text(
              "Job Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "This is a detailed description of the job role. "
              "It includes key responsibilities, skills required, and other details "
              "about the position.",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),

            const Spacer(),

          
          ],
        ),
      ),
    );
  }
}
