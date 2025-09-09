import 'package:flutter/material.dart';

class ReferralsPage extends StatelessWidget {
  const ReferralsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Referrals"), backgroundColor: Colors.blueGrey.shade700),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (_, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.group, color: Colors.blueGrey),
              title: Text("Team Lead #$index"),
              subtitle: const Text("Referred 3 freelancers"),
            ),
          );
        },
      ),
    );
  }
}
