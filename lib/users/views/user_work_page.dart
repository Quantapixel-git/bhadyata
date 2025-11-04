import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class UserWorkScreen extends StatefulWidget {
  final String projectTitle;
  final String description;
  final String category;
  final double budget;
  final String paymentType;
  final double paymentValue;
  final DateTime deadline;

  const UserWorkScreen({
    super.key,
    required this.projectTitle,
    required this.description,
    required this.category,
    required this.budget,
    required this.paymentType,
    required this.paymentValue,
    required this.deadline,
  });

  @override
  State<UserWorkScreen> createState() => _UserWorkScreenState();
}

class _UserWorkScreenState extends State<UserWorkScreen> {
  bool isCompleted = false;

  void markComplete() {
    setState(() {
      isCompleted = true;
    });

    // Show a nice snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(" Project marked as completed!"),

        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Work on Project'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Banner
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green.shade100 : AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.timelapse,
                    color: isCompleted ? Colors.green : AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isCompleted
                          ? "This project is completed ✅"
                          : "You are working on this project ⏳",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCompleted
                            ? Colors.green.shade900
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Project Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.projectTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Category: ${widget.category}"),
                        Text("Budget: ₹${widget.budget}"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.paymentType}: ${widget.paymentValue}"
                          "${widget.paymentType == 'Commission' ? '%' : ''}",
                        ),
                        Text(
                          "Deadline: ${widget.deadline.toLocal()}".split(
                            ' ',
                          )[0],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Action Button
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.done, color: Colors.white),
                label: Text(
                  isCompleted ? "Completed" : "Mark as Complete",
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.grey : Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                onPressed: isCompleted ? null : markComplete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
