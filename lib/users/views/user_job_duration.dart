import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class Job {
  final String title;
  final String company;
  DateTime startDate;
  DateTime endDate;
  bool isCompleted;

  Job({
    required this.title,
    required this.company,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
  });
}

class JobDurationScreen extends StatefulWidget {
  const JobDurationScreen({super.key});

  @override
  State<JobDurationScreen> createState() => _JobDurationScreenState();
}

class _JobDurationScreenState extends State<JobDurationScreen> {
  List<Job> jobs = [
    Job(
      title: "Flutter Developer",
      company: "Tech Solutions",
      startDate: DateTime(2025, 9, 1),
      endDate: DateTime(2025, 9, 27),
      isCompleted: true,
    ),
    Job(
      title: "UI/UX Designer",
      company: "Creative Minds",
      startDate: DateTime(2025, 9, 10),
      endDate: DateTime(2025, 10, 10),
      isCompleted: false,
    ),
  ];

  Future<void> requestExtension(Job job) async {
    DateTime? newEndDate = await showDatePicker(
      context: context,
      initialDate: job.endDate.add(const Duration(days: 1)),
      firstDate: job.endDate.add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );

    if (newEndDate != null) {
      setState(() {
        job.endDate = newEndDate;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            "${job.title} extended till ${DateFormat('yyyy-MM-dd').format(job.endDate)}",
          ),
        ),
      );
    }
  }

  void markCompleted(Job job) {
    setState(() {
      job.isCompleted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("${job.title} marked as completed"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Job Status",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: jobs.isEmpty
            ? const Center(child: Text("No jobs assigned"))
            : ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  final isExpired = DateTime.now().isAfter(job.endDate);

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                job.isCompleted
                                    ? Icons.check_circle
                                    : Icons.work_outline,
                                color: job.isCompleted
                                    ? Colors.green
                                    : AppColors.primary,
                                size: 40,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      job.company,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      "Start: ${DateFormat('yyyy-MM-dd').format(job.startDate)} | End: ${DateFormat('yyyy-MM-dd').format(job.endDate)}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Completed label
                          if (job.isCompleted)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "Completed",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ReviewEmployerScreen(
                                            jobTitle: job.title,
                                            company: job.company,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.rate_review),
                                    label: const Text("Review Employer"),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          // Expired jobs → show Request Extension
                          if (!job.isCompleted && isExpired)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => requestExtension(job),
                                    icon: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Request Extension",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          // Ongoing jobs → show Mark Completed
                          if (!job.isCompleted && !isExpired)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => markCompleted(job),
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Mark Completed",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
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
      ),
    );
  }
}

class ReviewEmployerScreen extends StatefulWidget {
  final String jobTitle;
  final String company;

  const ReviewEmployerScreen({
    super.key,
    required this.jobTitle,
    required this.company,
  });

  @override
  State<ReviewEmployerScreen> createState() => _ReviewEmployerScreenState();
}

class _ReviewEmployerScreenState extends State<ReviewEmployerScreen> {
  double rating = 4.0;
  final TextEditingController reviewController = TextEditingController();

  void submitReview() {
    String review = reviewController.text.trim();
    if (review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Please write a review before submitting.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Review for ${widget.company} submitted! Rating: $rating, Review: $review',
        ),
      ),
    );

    setState(() {
      rating = 4.0;
      reviewController.clear();
    });
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review ${widget.company}"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Rate your experience for '${widget.jobTitle}'",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (r) => setState(() => rating = r),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Write your review",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit Review",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
