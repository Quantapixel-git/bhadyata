import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/drawer_dashboard/employer_side_bar.dart';

class OneTimeRecruitmentPage extends StatelessWidget {
  const OneTimeRecruitmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployerDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "One-Time Recruitment",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWeb = constraints.maxWidth >= 900;
            return _buildContent(isWeb);
          },
        ),
      ),
    );
  }

  Widget _buildContent(bool isWeb) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Understanding One-Time Recruitment",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "This feature allows employers to hire candidates for one-time or project-based jobs. Attendance and salary tracking are not managed through the app. Below is a clear explanation of how it works:",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              _buildStep(
                step: "1",
                title: "Post a Job",
                description:
                    "Employers can post job openings for short-term or one-time projects. Once submitted, the job is reviewed by the HR team before publishing.",
              ),
              _buildStep(
                step: "2",
                title: "HR Approval",
                description:
                    "The HR team checks job details and eligibility before approval. Once verified, it becomes visible to candidates.",
              ),
              _buildStep(
                step: "3",
                title: "Applications & Screening",
                description:
                    "Candidates apply for your job post. The HR team screens applications and shortlists potential candidates.",
              ),
              _buildStep(
                step: "4",
                title: "Interview / Selection",
                description:
                    "You can view shortlisted profiles, communicate, and hire suitable candidates directly or schedule interviews if needed.",
              ),
              _buildStep(
                step: "5",
                title: "Update Candidate Status",
                description:
                    "After reviewing candidates, update their hiring status:\n• Hired (select joining date)\n• Rejected\n• Pending",
              ),
              _buildStep(
                step: "6",
                title: "Need Help?",
                description:
                    "For any doubts or issues, reach out to our HR or Support Team through the ‘Query Portal’.",
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required String step,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 16,
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14.5,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
