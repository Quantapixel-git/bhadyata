import 'package:flutter/material.dart';

class HrEmployerDetail extends StatelessWidget {
  final Map<String, String> employer;

  const HrEmployerDetail({super.key, required this.employer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(employer['name'] ?? 'Employer Details'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employer['name'] ?? '',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
                const SizedBox(height: 12),
                _detailRow("Company", employer['company']),
                _detailRow("Email", employer['email']),
                _detailRow("Phone", employer['phone']),
                const SizedBox(height: 20),
                const Text(
                  "About Employer:",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                const Text(
                  "This employer manages multiple job postings. You can include data like total hires, job count, and registration date here.",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? ''),
        ],
      ),
    );
  }
}
