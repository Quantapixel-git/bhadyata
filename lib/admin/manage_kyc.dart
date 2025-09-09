import 'package:flutter/material.dart';

class ManageKyc extends StatelessWidget {
  const ManageKyc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Approve KYC"), backgroundColor: Colors.blue.shade700),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Example
        itemBuilder: (_, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.person, size: 36, color: Colors.blue),
              title: Text("User John Doe #$index"),
              subtitle: const Text("Submitted KYC documents"),
              trailing: Wrap(
                spacing: 12,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      // Approve KYC
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      // Reject KYC
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
