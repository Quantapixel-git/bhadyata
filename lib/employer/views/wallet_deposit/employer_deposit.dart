import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class MyDepositPage extends StatefulWidget {
  const MyDepositPage({super.key});

  @override
  State<MyDepositPage> createState() => _MyDepositPageState();
}

class _MyDepositPageState extends State<MyDepositPage> {
  // 🔥 DEMO TRANSACTION HISTORY
  final List<Map<String, dynamic>> transactions = [
    {
      "txn_id": 101,
      "type": "salary_payment",
      "amount": -30000,
      "date": "15 Oct 2025",
      "note": "Salary for October 2025",
      "job_id": 2,
      "employees": [
        {"id": 12, "name": "Amit Sharma"},
        {"id": 14, "name": "Riya Verma"},
      ],
    },
    {
      "txn_id": 101,
      "type": "salary_payment",
      "amount": -30000,
      "date": "15 Nov 2025",
      "note": "Salary for October 2025",
      "job_id": 2,
      "employees": [
        {"id": 12, "name": "Amit Sharma"},
        {"id": 14, "name": "Riya Verma"},
      ],
    },
    {
      "txn_id": 101,
      "type": "salary_payment",
      "amount": -30000,
      "date": "15 Nov 2025",
      "note": "Salary for October 2025",
      "job_id": 2,
      "employees": [
        {"id": 12, "name": "Amit Sharma"},
        {"id": 14, "name": "Riya Verma"},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 1000; // desktop breakpoint

        return EmployerDashboardWrapper(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              automaticallyImplyLeading: !isWeb,
              title: const Text(
                "Transaction History",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: AppColors.primary,
            ),

            drawer: isWeb ? null : EmployerSidebar(),

            body: Container(
              color: Colors.grey.shade100,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 80 : 16, // full width on desktop
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Text(
                    //   "Transaction History",
                    //   style: TextStyle(
                    //     fontSize: isWeb ? 22 : 18,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(height: 20),
                    if (transactions.isEmpty)
                      const Center(
                        child: Text(
                          "No transactions found.",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    else
                      Column(
                        children: transactions
                            .map((txn) => _transactionCard(txn, isWeb))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // -------------------- TRANSACTION CARD --------------------
  Widget _transactionCard(Map txn, bool isWeb) {
    final bool isPositive = (txn["amount"] ?? 0) > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ROW 1 — ICON + NOTE + AMOUNT
          Row(
            children: [
              Icon(
                txn["type"] == "salary_payment"
                    ? Icons.account_balance_wallet
                    : txn["type"] == "refund"
                    ? Icons.refresh
                    : Icons.payments,
                size: isWeb ? 38 : 30,
                color: isPositive ? Colors.green : Colors.redAccent,
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  txn["note"] ?? "",
                  style: TextStyle(
                    fontSize: isWeb ? 17 : 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Text(
                "${isPositive ? "+ " : "- "}₹${txn["amount"].abs()}",
                style: TextStyle(
                  fontSize: isWeb ? 17 : 15,
                  fontWeight: FontWeight.bold,
                  color: isPositive ? Colors.green : Colors.redAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // DATE
          Text(
            txn["date"],
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),

          // JOB ID
          if (txn["job_id"] != null) ...[
            const SizedBox(height: 10),
            Text(
              "Job ID: ${txn["job_id"]}",
              style: const TextStyle(fontSize: 13.5),
            ),
          ],

          // EMPLOYEES (if present)
          if (txn["employees"] != null && txn["employees"].isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text(
              "Employees:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (txn["employees"] as List)
                  .map(
                    (emp) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.person, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "${emp['name']} (ID: ${emp['id']})",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
