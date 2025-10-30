

import 'package:flutter/material.dart';
import 'package:jobshub/extra/views/clients/client_assign_user_work_screen.dart';

class ClientAttendanceScreen extends StatelessWidget {
  const ClientAttendanceScreen({super.key});

  final List<String> assignedCandidates = const ['John Doe', 'Jane Smith', 'Alice Johnson'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: assignedCandidates.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.deepPurple),
                      title: Text(assignedCandidates[index]),
                      trailing: Switch(
                        value: true,
                        onChanged: (val) {},
                        activeColor: Colors.deepPurple,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DurationScreen()));
                },
                child: const Text('Submit Attendance', style: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }
}