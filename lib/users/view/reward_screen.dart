import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jobshub/users/view/user_sidedrawer.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  bool _isExpanded = false;
  bool _showPrivacy = false;

  String referralCode = "MAH82&";
  double walletBalance = 250.0;

  // Example accepted salary-based job info
  final String? acceptedJobTitle = "Flutter Developer";
  final double monthlySalary = 40000;
  final List<Map<String, dynamic>> salaryTransactions = [
    {"month": "August 2025", "daysWorked": 26, "amount": 34667},
    {"month": "September 2025", "daysWorked": 24, "amount": 32000},
    {"month": "October 2025", "daysWorked": 20, "amount": 26667},
  ];

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _buildWebUI(context) : _buildMobileUI(context);
  }

  /// ================= MOBILE UI =================
  Widget _buildMobileUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          "Rewards & Wallet",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            iconSize: 40, // 👈 change size here
            icon: const Icon(
              Icons.menu,
              color: Colors.white, // 👈 change color here
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),

      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
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
            _buildTermsTile(context),
            const SizedBox(height: 8),
            _buildPrivacyTile(context),
          ],
        ),
      ),
    );
  }

  /// ================= WEB UI =================
  Widget _buildWebUI(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWalletSection(),
                    const SizedBox(height: 24),
                    _buildReferralSection(),
                    const SizedBox(height: 32),
                    _buildJobPaymentSection(),
                    const SizedBox(height: 32),
                    _buildHowItWorks(),
                    const SizedBox(height: 16),
                    _buildTermsTile(context, isWeb: true),
                    const SizedBox(height: 8),
                    _buildPrivacyTile(context, isWeb: true),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= WALLET SECTION =================
  Widget _buildWalletSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Wallet Balance",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 4),
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
          ),
        ],
      ),
    );
  }

  /// ================= REFERRAL SECTION =================
  Widget _buildReferralSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
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
            "Invite your friends and get 250 coins after they complete their first service. They get 100 coins as a gift from us.",
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    referralCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= JOB PAYMENT SECTION =================
  Widget _buildJobPaymentSection() {
    if (acceptedJobTitle == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
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
          const SizedBox(height: 6),
          Text(
            "Monthly Salary: ₹${monthlySalary.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const Text(
            "Payment History",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...salaryTransactions.map((tx) {
            return ListTile(
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
            );
          }),
        ],
      ),
    );
  }

  /// ================= HOW IT WORKS =================
  Widget _buildHowItWorks() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
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
            number.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  /// ================= TERMS & PRIVACY =================
  Widget _buildTermsTile(BuildContext context, {bool isWeb = false}) {
    return InkWell(
      onTap: () => _showBottomSheet(context, "Terms & Conditions"),
      borderRadius: BorderRadius.circular(12),
      child: _infoTile("Terms & Conditions"),
    );
  }

  Widget _buildPrivacyTile(BuildContext context, {bool isWeb = false}) {
    return InkWell(
      onTap: () => _showBottomSheet(context, "Privacy Policy"),
      borderRadius: BorderRadius.circular(12),
      child: _infoTile("Privacy Policy"),
    );
  }

  Widget _infoTile(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        ],
      ),
    );
  }

  /// ================= BOTTOM SHEETS =================
  void _showBottomSheet(BuildContext context, String title) {
    String content = title == "Terms & Conditions"
        ? """1. Referral rewards are given only after your friend completes their first service.  
2. Referral code must be applied during signup.  
3. Each user can use one referral code only.  
4. Rewards cannot be exchanged for cash.  
5. Program terms may change anytime."""
        : """We respect your privacy.  
1. We do not share your personal data with third parties.  
2. Your information is only used to improve our services.  
3. All transactions and referral data are securely stored.  
4. You may contact support for data deletion requests.""";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
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
        );
      },
    );
  }
}
