import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/drawer_dashboard/employer_side_bar.dart';

class WalletDepositWorkingPage extends StatelessWidget {
  const WalletDepositWorkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              // ✅ Consistent AppBar like AdminDashboard
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // hide drawer icon on web
                title: const Text(
                  "Wallet & Deposit Working",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // ✅ Page content
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

  // ---------- MAIN CONTENT ----------
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
                "Understanding Wallet & Deposit System",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "The Wallet & Deposit System enables employers to manage and release salary payments securely for employees hired under the Salary-Based Recruitment model. It ensures transparency, timely payments, and easy financial tracking.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Steps
              _buildStep(
                step: "1",
                title: "Deposit Money into Wallet",
                description:
                    "Employers can add funds to their company wallet using UPI, Debit Card, Credit Card, or Net Banking. Deposited balance appears instantly in your wallet section.",
              ),
              _buildStep(
                step: "2",
                title: "Salary Deduction Logic",
                description:
                    "After verifying employee attendance and work completion, the system automatically calculates each employee’s payable salary for the month.",
              ),
              _buildStep(
                step: "3",
                title: "Salary Payment from Deposit Wallet",
                description:
                    "Once verified, the total payable salary amount is deducted from your deposit wallet, ensuring payments are made only to active and verified employees.",
              ),
              _buildStep(
                step: "4",
                title: "Salary Status Update",
                description:
                    "After successful payment, each employee’s salary status is automatically updated to ‘Paid’ in your employer dashboard for full transparency.",
              ),
              _buildStep(
                step: "5",
                title: "Wallet History & Transparency",
                description:
                    "All transactions — including Deposits, Deductions, Refunds, or Bonuses — are logged with date, amount, and description for complete traceability.",
              ),
              _buildStep(
                step: "6",
                title: "Low Balance Alerts",
                description:
                    "If your wallet balance runs low, the system notifies you before salary processing. You must top up to ensure timely salary payments.",
              ),
              _buildStep(
                step: "7",
                title: "Need Assistance?",
                description:
                    "For payment failures or wallet-related issues, contact our Finance Support Team via the ‘Query Portal’.",
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
