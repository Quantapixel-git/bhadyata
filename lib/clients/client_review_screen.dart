import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

class CandidateReviewsScreen extends StatelessWidget {
  const CandidateReviewsScreen({super.key});

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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Candidate Reviews",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: reviews.isEmpty
            ? const Center(child: Text("No reviews available"))
            : ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
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
                },
              ),
      ),
    );
  }
}
