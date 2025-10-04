import 'package:flutter/material.dart';
import 'package:jobshub/users/home_page.dart';
import 'package:jobshub/utils/AppColor.dart';

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

class WorkAssignmentScreen extends StatefulWidget {
  const WorkAssignmentScreen({super.key});

  @override
  State<WorkAssignmentScreen> createState() => _WorkAssignmentScreenState();
}

class _WorkAssignmentScreenState extends State<WorkAssignmentScreen> {
  List<Work> assignedWorks = [
    Work(
      title: "Software Developer",
      company: "Tech Solutions",
      duration: "3 days",
    ),
    Work(
      title: "UI/UX Designer",
      company: "Creative Minds",
      duration: "5 days",
    ),
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Work Assignment",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (assignedWorks.isEmpty) {
            return const Center(child: Text("No assigned works"));
          }

          // Mobile layout
          if (constraints.maxWidth <= 600) {
            return ListView.builder(
              shrinkWrap:false,
              padding: const EdgeInsets.all(16),
              itemCount: assignedWorks.length,
              itemBuilder: (context, index) {
                return WorkCard(
                  work: assignedWorks[index],
                  onAccept: () => acceptWork(index),
                  onReject: () => rejectWork(index),
                  isWeb: false,
                );
              },
            );
          } else {
            // Web/Desktop layout
            int crossAxisCount = (constraints.maxWidth ~/ 400).clamp(2, 4);
            return Row(
              children: [
                const AppDrawer(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: assignedWorks.length,
                      itemBuilder: (context, index) {
                        return WorkCard(
                          work: assignedWorks[index],
                          onAccept: () => acceptWork(index),
                          onReject: () => rejectWork(index),
                          isWeb: true,
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
class WorkCard extends StatelessWidget {
  final Work work;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool isWeb;

  const WorkCard({
    super.key,
    required this.work,
    required this.onAccept,
    required this.onReject,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                work.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Company: ${work.company}"),
              Text("Duration: ${work.duration}"),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: work.accepted ? null : onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(work.accepted ? "Accepted" : "Accept"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Reject"),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final card = Card(
      elevation: isWeb ? 6 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black26,
      child: cardContent,
    );

    if (isWeb) {
      // ✅ Add hover animation only for web
      return MouseRegion(
        onEnter: (_) {},
        onExit: (_) {},
        child: card,
      );
    }

    return card; // ✅ Mobile gets a plain card
  }
}

