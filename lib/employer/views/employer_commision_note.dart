import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/drawer_dashboard/employer_side_bar.dart';

class CommissionBasedRecruitmentPage extends StatelessWidget {
  const CommissionBasedRecruitmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              // ✅ AppBar same logic as AdminDashboard
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // hide drawer icon on web
                title: const Text(
                  "Commission-Based Recruitment",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // ✅ Main Content
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: _buildContent(isWeb),
                ),
              ),
            ],
          ),
        );
      },
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
                "Understanding Commission-Based Recruitment",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Commission-Based Recruitment enables employers to hire lead generators or sales professionals who are paid based on performance, verified leads, or closed deals. This model promotes accountability and performance-driven results.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Steps
              _buildStep(
                step: "1",
                title: "Post a Commission-Based Job",
                description:
                    "Define your commission structure, product/service details, and performance expectations. Once submitted, our HR team will review your post before it goes live.",
              ),
              _buildStep(
                step: "2",
                title: "HR Review & Approval",
                description:
                    "The HR team verifies your post to ensure clear commission terms and fair compliance before publishing it for candidates.",
              ),
              _buildStep(
                step: "3",
                title: "Receive & Review Applications",
                description:
                    "Interested lead generators or sales candidates will apply. You can review their profiles, communication skills, and experience level.",
              ),
              _buildStep(
                step: "4",
                title: "Select or Train Candidates",
                description:
                    "You can either directly onboard candidates or organize short product training to explain commission rules and expectations.",
              ),
              _buildStep(
                step: "5",
                title: "Track Leads & Performance",
                description:
                    "Once hired, candidates can begin generating leads or sales. You can track performance and verify submissions through your employer dashboard.",
              ),
              _buildStep(
                step: "6",
                title: "Commission Payment",
                description:
                    "Make commission payouts after verifying leads or confirmed sales. Payments are one-time and not part of a monthly salary structure.",
              ),
              _buildStep(
                step: "7",
                title: "Need Assistance?",
                description:
                    "For queries related to payment or candidate performance, reach out via the ‘Query Portal’ or contact our HR support team.",
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- STEP CARD ----------
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
