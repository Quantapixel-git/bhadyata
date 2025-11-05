import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_side_bar.dart';

class MyDepositPage extends StatefulWidget {
  const MyDepositPage({super.key});

  @override
  State<MyDepositPage> createState() => _MyDepositPageState();
}

class _MyDepositPageState extends State<MyDepositPage> {
  final List<Map<String, dynamic>> transactions = [
    {
      "title": "Salary Payment - Amit Sharma",
      "amount": "- ₹30,000",
      "date": "15 Oct 2025",
      "type": "Salary Payment",
    },
    {
      "title": "Initial Deposit - Commission Based",
      "amount": "- ₹5,000",
      "date": "10 Oct 2025",
      "type": "Deposit",
    },
    {
      "title": "Refund - Commission Based",
      "amount": "+ ₹5,000",
      "date": "05 Oct 2025",
      "type": "Refund",
    },
  ];

  void _onSalaryPayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Proceed to pay salaries..."),
      ),
    );
  }

  void _onDepositPayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Proceed to pay refundable deposit..."),
      ),
    );
  }

  void _onOneTimePayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Proceed to pay one-time recruitment fee..."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              // ✅ AppBar — consistent with AdminDashboard
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "My Deposit",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // ✅ Main content
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 💳 Payment Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Make a Payment",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _paymentButton(
                                    "Pay for Salary (Salary-Based Employees)",
                                    Icons.account_balance_wallet_outlined,
                                    Colors.green,
                                    _onSalaryPayment,
                                  ),
                                  const SizedBox(height: 10),
                                  _paymentButton(
                                    "Pay Refundable Initial Deposit (Commission-Based)",
                                    Icons.monetization_on_outlined,
                                    Colors.orange,
                                    _onDepositPayment,
                                  ),
                                  const SizedBox(height: 10),
                                  _paymentButton(
                                    "Pay for One-Time Recruitment",
                                    Icons.people_alt_outlined,
                                    Colors.blueAccent,
                                    _onOneTimePayment,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // 🧾 Transaction History Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Transaction History",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: transactions.length,
                                    separatorBuilder: (_, __) => const Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    itemBuilder: (context, index) {
                                      final txn = transactions[index];
                                      final isPositive = txn["amount"]
                                          .toString()
                                          .contains("+");

                                      return ListTile(
                                        leading: Icon(
                                          txn["type"] == "Salary Payment"
                                              ? Icons.account_balance_wallet
                                              : txn["type"] == "Refund"
                                              ? Icons.refresh
                                              : Icons.payment,
                                          color: isPositive
                                              ? Colors.green
                                              : Colors.redAccent,
                                        ),
                                        title: Text(
                                          txn["title"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.5,
                                          ),
                                        ),
                                        subtitle: Text(
                                          txn["date"],
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        trailing: Text(
                                          txn["amount"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isPositive
                                                ? Colors.green
                                                : Colors.redAccent,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔁 Reusable Payment Button
  Widget _paymentButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.9),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
