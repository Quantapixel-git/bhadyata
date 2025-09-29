import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

// ------------------ Work Model ------------------
class Work {
  final String title;
  final String company;
  final String duration;
  bool accepted;

  Work({
    required this.title,
    required this.company,
    required this.duration,
    this.accepted = false,
  });
}

// ------------------ Work Assignment Screen ------------------
class WorkAssignmentScreen extends StatefulWidget {
  const WorkAssignmentScreen({super.key});

  @override
  State<WorkAssignmentScreen> createState() => _WorkAssignmentScreenState();
}

class _WorkAssignmentScreenState extends State<WorkAssignmentScreen> {
  List<Work> assignedWorks = [
    Work(title: "Software Developer", company: "Tech Solutions", duration: "3 days"),
    Work(title: "UI/UX Designer", company: "Creative Minds", duration: "5 days"),
    Work(title: "Flutter Developer", company: "AppWorks", duration: "7 days"),
  ];

  void acceptWork(int index) {
    setState(() {
      assignedWorks[index].accepted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${assignedWorks[index].title} accepted!")),
    );
  }

  void rejectWork(int index) {
    final work = assignedWorks[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reject Work"),
        content: Text("Are you sure you want to reject ${work.title}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                assignedWorks.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${work.title} rejected!")),
              );
            },
            child: const Text("Reject"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Work Assignment",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: AppColors.primary,
      ),
      body: assignedWorks.isEmpty
          ? const Center(child: Text("No assigned works"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: assignedWorks.length,
              itemBuilder: (context, index) {
                final work = assignedWorks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(work.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text("Company: ${work.company}"),
                        Text("Duration: ${work.duration}"),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: work.accepted ? null : () => acceptWork(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(work.accepted ? "Accepted" : "Accept"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => rejectWork(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text("Reject"),
                              ),
                            ),
                          ],
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

