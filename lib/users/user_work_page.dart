import 'package:flutter/material.dart';

class UserWorksPage extends StatelessWidget {
  final bool kycApproved;

  // Mock data
  final List<Map<String, String>> works = [
    {"title": "Marketing Campaign", "type": "Salary"},
    {"title": "Onboarding Assistance", "type": "Commission"},
    {"title": "Social Media Manager", "type": "Salary"},
  ];

  UserWorksPage({super.key, required this.kycApproved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Works"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: kycApproved
            ? ListView.builder(
                itemCount: works.length,
                itemBuilder: (context, index) {
                  final work = works[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      leading: const Icon(Icons.work_outline,
                          color: Colors.blue),
                      title: Text(work["title"]!),
                      subtitle: Text(work["type"]!),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Apply to work
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Applied for ${work["title"]}"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                        ),
                        child: const Text("Apply"),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 20),
                    const Text(
                      "Complete your KYC to view available works",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to KYC page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Go to KYC"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
