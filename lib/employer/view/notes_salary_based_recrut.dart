import 'package:flutter/material.dart';
import 'package:jobshub/employer/view/drawer_dashboard/employer_side_bar.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class SalaryBasedRecruitmentPage extends StatelessWidget {
  const SalaryBasedRecruitmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployerDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Salary Based Recruitment",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                "Understanding Salary Based Recruitment",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "This feature allows employers to hire candidates on a salary basis through a transparent and managed process. Below is a step-by-step explanation of how it works:",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Step list
              _buildStep(
                step: "1",
                title: "Post a Job",
                description:
                    "Employers can create and post job openings for required roles. Once posted, the job will be reviewed by the HR team before it goes live.",
              ),
              _buildStep(
                step: "2",
                title: "HR Approval",
                description:
                    "The HR team reviews the job post for details, salary structure, and eligibility criteria. Once approved, the job becomes visible to candidates.",
              ),
              _buildStep(
                step: "3",
                title: "Applications & Screening",
                description:
                    "Candidates apply for your job. The HR team will review applications and shortlist qualified candidates for your review.",
              ),
              _buildStep(
                step: "4",
                title: "Scheduled Interview",
                description:
                    "Qualified candidates are transferred to the ‘Scheduled Interview’ section. You can view their profiles, directly hire them, or schedule interviews.",
              ),
              _buildStep(
                step: "5",
                title: "Update Candidate Status",
                description:
                    "After interviews, mark each candidate’s status accordingly:\n• Interview Scheduled\n• Hired (choose joining date)\n• Rejected\n• Pending",
              ),
              _buildStep(
                step: "6",
                title: "Daily Attendance",
                description:
                    "Once employees join, you must mark their attendance daily through the attendance section to maintain salary accuracy.",
              ),
              _buildStep(
                step: "7",
                title: "Salary Verification & Payment",
                description:
                    "At the end of each month, review and verify your employees’ salary structure and attendance. Then make the payment from the ‘My Deposit’ page.",
              ),
              _buildStep(
                step: "8",
                title: "Salary Status Update",
                description:
                    "Once the payment is made successfully, the system automatically updates the salary status to ‘Paid’.",
              ),
              _buildStep(
                step: "9",
                title: "Need Help?",
                description:
                    "If you have any queries or issues during the process, please contact our support team through the ‘Query Portal’.",
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
