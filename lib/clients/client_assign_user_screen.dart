import 'package:flutter/material.dart';
import 'package:jobshub/users/project_model.dart';

class ClientAssignUserScreen extends StatefulWidget {
  final ProjectModel project;

  const ClientAssignUserScreen({super.key, required this.project});

  @override
  State<ClientAssignUserScreen> createState() => _ClientAssignUserScreenState();
}

class _ClientAssignUserScreenState extends State<ClientAssignUserScreen> {
  String? assignedUser; // track which applicant is assigned

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assign Work',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),),
      body: widget.project.applicants.isEmpty
          ? const Center(child: Text("No applicants yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.project.applicants.length,
              itemBuilder: (context, index) {
                final user = widget.project.applicants[index];
                final isAssigned = assignedUser == user['name'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  color: isAssigned ? Colors.green.shade50 : null,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Applicant info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  isAssigned ? Colors.green : Colors.blue,
                              child: Text(
                                user['name']![0],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['name']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isAssigned
                                          ? Colors.green.shade800
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Applied for: ${widget.project.title}",
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Proposal
                        Text(
                          "\"${user['proposal']}\"",
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 8),

                        // Work info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Category: ${widget.project.category}"),
                            Text("Budget: ₹${widget.project.budget}"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${widget.project.paymentType}: ${widget.project.paymentValue}${widget.project.paymentType == 'Commission' ? '%' : ''}"),
                            Text("Deadline: ${widget.project.deadline.toLocal()}".split(' ')[0]),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Approve button OR Assigned badge
                        Align(
                          alignment: Alignment.centerRight,
                          child: isAssigned
                              ? Chip(
                                  label: const Text(
                                    "✅ Assigned",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                )
                              : ElevatedButton.icon(
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text("Approve"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      assignedUser = user['name'];
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${user['name']} has been assigned to ${widget.project.title}!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                ),
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
