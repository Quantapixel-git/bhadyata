import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/user_sidedrawer.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  String referralCode = "MAH82&";
  double walletBalance = 250.0;
  final String? acceptedJobTitle = "Flutter Developer";
  final double monthlySalary = 40000;

  final List<Map<String, dynamic>> salaryTransactions = [
    {"month": "August 2025", "daysWorked": 26, "amount": 34667},
    {"month": "September 2025", "daysWorked": 24, "amount": 32000},
    {"month": "October 2025", "daysWorked": 20, "amount": 26667},
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
    
      drawer: !kIsWeb ? AppDrawer() : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: isWide ? _buildWebLayout() : _buildMobileLayout(),
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- 📱 MOBILE LAYOUT ----------
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWalletSection(),
        const SizedBox(height: 20),
        _buildReferralSection(),
        const SizedBox(height: 24),
        _buildJobPaymentSection(),
        const SizedBox(height: 24),
        _buildHowItWorks(),
        const SizedBox(height: 16),
        _buildInfoTiles(),
      ],
    );
  }

  /// ---------- 💻 DESKTOP LAYOUT ----------
  Widget _buildWebLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1 — Wallet + Referral side by side
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildWalletSection()),
            const SizedBox(width: 20),
            Expanded(child: _buildReferralSection()),
          ],
        ),
        const SizedBox(height: 24),
        // Row 2 — Job Payment + How it Works
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildJobPaymentSection()),
            const SizedBox(width: 20),
            Expanded(child: _buildHowItWorks()),
          ],
        ),
        const SizedBox(height: 24),
        _buildInfoTiles(),
      ],
    );
  }

  /// ---------- 🪙 WALLET SECTION ----------
  Widget _buildWalletSection() {
    return _sectionContainer(
      color: Colors.amber.shade50,
      borderColor: Colors.amber.shade200,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber.shade100,
            radius: 28,
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.orange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Wallet Balance",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              Text(
                "₹${walletBalance.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------- 🤝 REFERRAL SECTION ----------
  Widget _buildReferralSection() {
    return _sectionContainer(
      color: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Invite Friends & Earn",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Invite friends and earn 250 coins once they complete their first service. They get 100 coins too!",
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              referralCode,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- 💼 JOB PAYMENT SECTION ----------
  Widget _buildJobPaymentSection() {
    if (acceptedJobTitle == null) return const SizedBox.shrink();
    return _sectionContainer(
      color: Colors.blue.shade50,
      borderColor: Colors.blue.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Salary-based Job Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            acceptedJobTitle!,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "Monthly Salary: ₹${monthlySalary.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const Divider(height: 24),
          const Text(
            "Payment History",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...salaryTransactions.map(
            (tx) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                tx["month"],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text("Days Worked: ${tx["daysWorked"]}"),
              trailing: Text(
                "₹${tx["amount"]}",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- ⚙️ HOW IT WORKS ----------
  Widget _buildHowItWorks() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "How it works?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildStep(1, "Invite your friends"),
          const SizedBox(height: 12),
          _buildStep(
            2,
            "They get 100 coins towards their first service after clicking the invitation link",
          ),
          const SizedBox(height: 12),
          _buildStep(3, "You get 250 coins after they complete the service"),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primary,
          child: Text(
            "$number",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  /// ---------- 📄 INFO TILES ----------
  Widget _buildInfoTiles() {
    return Column(
      children: [
        _infoTile("Terms & Conditions", "terms"),
        const SizedBox(height: 8),
        _infoTile("Privacy Policy", "privacy"),
      ],
    );
  }

  Widget _infoTile(String title, String type) {
    return InkWell(
      onTap: () => _showBottomSheet(title, type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- 🧱 REUSABLE SECTION CONTAINER ----------
  Widget _sectionContainer({
    required Widget child,
    Color? color,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  /// ---------- 📜 MODAL SHEETS ----------
  void _showBottomSheet(String title, String type) {
    String content = type == "terms"
        ? """
1. Referral rewards are credited after your friend completes their first service.
2. Referral code must be used during signup.
3. Only one referral code can be used per user.
4. Rewards are non-transferable and non-cashable.
5. Terms may change without prior notice."""
        : """
We value your privacy.
1. We never share personal data with third parties.
2. Data is used only to improve user experience.
3. Transactions and referrals are securely stored.
4. You can request data deletion anytime.""";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
