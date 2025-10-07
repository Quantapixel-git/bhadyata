import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';
import 'package:jobshub/clients/client_sidebar.dart';

class ClientCandiReviewScreen extends StatelessWidget {
  ClientCandiReviewScreen({super.key});

  final List<Map<String, dynamic>> reviews = const [
    {
      "candidate": "John Doe",
      "job": "Mobile App Development",
      "rating": 4.5,
      "review": "Very professional and delivered on time."
    },
    {
      "candidate": "Jane Smith",
      "job": "UI/UX Design",
      "rating": 5.0,
      "review": "Creative and detail-oriented designer!"
    },
    {
      "candidate": "Mike Johnson",
      "job": "Backend Developer",
      "rating": 4.0,
      "review": "Good work, but needs minor improvements."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 800;

    Widget buildReviewCard(Map<String, dynamic> review) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, color: AppColors.primary, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review["candidate"],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Job: ${review["job"]}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < review["rating"].floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                review["review"],
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        if (isWeb) {
          // Use GridView for web
          return Padding(
            padding: const EdgeInsets.all(16),
            child: reviews.isEmpty
                ? const Center(child: Text("No reviews available"))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns for web
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3, // adjust based on content
                    ),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) =>
                        buildReviewCard(reviews[index]),
                  ),
          );
        } else {
          // ListView for mobile
          return Padding(
            padding: const EdgeInsets.all(16),
            child: reviews.isEmpty
                ? const Center(child: Text("No reviews available"))
                : ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) =>
                        buildReviewCard(reviews[index]),
                  ),
          );
        }
      },
    );

    if (isWeb) {
      return Scaffold(
        body: Row(
          children: [
            ClientSidebar(projects: []), // permanent sidebar
            Expanded(
              child: Column(
                children: [
                  AppBar(
                    title: const Text(
                      "Candidate Reviews",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  Expanded(child: content),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Candidate Reviews",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
        drawer: ClientSidebar(projects: []), // drawer for mobile
        body: content,
      );
    }
  }
}
