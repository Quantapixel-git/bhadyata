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

class WorkCard extends StatefulWidget {
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
  State<WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<WorkCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: isHovered ? 12 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.work.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Company: ${widget.work.company}"),
            Text("Duration: ${widget.work.duration}"),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: MouseRegion(
                    cursor: widget.work.accepted
                        ? SystemMouseCursors.basic
                        : SystemMouseCursors.click,
                    child: ElevatedButton(
                      onPressed: widget.work.accepted ? null : widget.onAccept,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((
                          states,
                        ) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.green.shade700;
                          return Colors.green;
                        }),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: Text(widget.work.accepted ? "Accepted" : "Accept"),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ElevatedButton(
                      onPressed: widget.onReject,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((
                          states,
                        ) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.red.shade700;
                          return Colors.red;
                        }),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: const Text("Reject"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return widget.isWeb
        ? MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: isHovered
                  ? Matrix4.translationValues(0, -5, 0)
                  : Matrix4.identity(),
              child: card,
            ),
          )
        : card;
  }
}
