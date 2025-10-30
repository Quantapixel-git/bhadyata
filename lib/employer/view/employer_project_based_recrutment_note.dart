import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/view/drawer_dashboard/employer_side_bar.dart';

class ProjectBasedRecruitmentPage extends StatelessWidget {
  const ProjectBasedRecruitmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployerDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Project-Based Recruitment",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
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
                "Understanding Project-Based Recruitment",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Project-Based Recruitment is ideal for short-term or task-specific hiring. Employers can onboard skilled professionals for defined durations or deliverables without managing monthly salary or attendance.",
                style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 20),

              _buildStep(
                step: "1",
                title: "Create a Project Job Post",
                description:
                    "Start by posting your project requirements including duration, deliverables, and expected payout. Once submitted, our HR team reviews it for approval.",
              ),
              _buildStep(
                step: "2",
                title: "HR Verification",
                description:
                    "The HR team verifies the project’s details to ensure clarity, fairness, and compliance. Approved projects are listed for candidates.",
              ),
              _buildStep(
                step: "3",
                title: "Receive and Review Applications",
                description:
                    "Interested professionals will apply to your project. You can review profiles, skills, and past work experience.",
              ),
              _buildStep(
                step: "4",
                title: "Select or Interview Candidates",
                description:
                    "You may directly hire suitable candidates or conduct brief interviews for clarity before assigning the project.",
              ),
              _buildStep(
                step: "5",
                title: "Project Completion & Payment",
                description:
                    "Once the project is completed and approved by you, make the one-time payment based on agreed deliverables.",
              ),
              _buildStep(
                step: "6",
                title: "Need Assistance?",
                description:
                    "For payment or communication-related queries, reach out through the ‘Query Portal’ or contact our HR support team.",
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
