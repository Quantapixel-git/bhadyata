// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';
import 'package:jobshub/common/utils/app_color.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth > 900;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: isWeb
              ? null
              : AppBar(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  centerTitle: true,
                  title: const Text(
                    "Rewards & Wallet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  leading: Builder(
                    builder: (context) => IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
          drawer: !isWeb ? AppDrawer() : null,

          // FULL-WIDTH BODY
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  if (isWeb)
                    Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Rewards & Wallet",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Responsive two-column layout on wide screens
                  LayoutBuilder(
                    builder: (c, inner) {
                      final bool wide = inner.maxWidth > 1100;

                      if (wide) {
                        // LEFT: Salary History
                        // RIGHT: Wallet -> Invite -> How it works
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildJobPaymentSection()),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  _buildWalletSection(),
                                  const SizedBox(height: 16),
                                  _buildReferralSection(),
                                  const SizedBox(height: 16),
                                  _buildHowItWorks(),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Mobile: stack vertically in the order user likely expects
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWalletSection(),
                            const SizedBox(height: 16),
                            _buildReferralSection(),
                            const SizedBox(height: 16),
                            _buildHowItWorks(),
                            const SizedBox(height: 20),
                            _buildJobPaymentSection(),
                          ],
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 32),
                  _buildInfoTiles(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
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
                "₹${250.0.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Withdraw', style: TextStyle(color: Colors.white),),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black, width: 1.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                   
                    onPressed: () {},
                    child: const Text(
                      'Add Money',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
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
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    referralCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Referral code copied')),
                    );
                  },
                  icon: const Icon(Icons.copy, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- 💼 JOB PAYMENT / SALARY HISTORY ----------
  Widget _buildJobPaymentSection() {
    if (acceptedJobTitle == null) return const SizedBox.shrink();
    return _sectionContainer(
      color: Colors.white,
      borderColor: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Salary Payment History",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            acceptedJobTitle!,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "Monthly Salary: ₹${40000.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const Divider(height: 24),
          const Text(
            "Payment History",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...salaryTransactions.map(
            (tx) => Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx['month'],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Days worked: ${tx['daysWorked']}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${tx['amount']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 6),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('View Slip'),
                      ),
                    ],
                  ),
                ],
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

  /// ---------- 🧱 SECTION CONTAINER ----------
  Widget _sectionContainer({
    required Widget child,
    Color? color,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity, // ensure full width within parent
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

    final isWide = MediaQuery.of(context).size.width > 900;
    if (!isWide) {
      // On mobile/tablet: full-screen bottom sheet
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    } else {
      // On web/desktop: show a centered card-like dialog that is wider
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'info',
        pageBuilder: (context, a1, a2) => const SizedBox.shrink(),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 24,
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.close),
                                ),
                              ],
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
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      );
    }
  }
}
