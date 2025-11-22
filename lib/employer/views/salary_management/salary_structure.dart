import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class SalaryDuePage extends StatelessWidget {
  const SalaryDuePage({super.key});

  // 🔥 DEMO DATA — replace with API result later
  final List<Map<String, dynamic>> duePayments = const [
    {
      "employee_name": "Amit Sharma",
      "employee_mobile": "9876543210",
      "job_title": "Software Engineer",
      "amount": 30000,
      "start_date": "2025-10-01",
      "end_date": "2025-10-31",
    },
    {
      "employee_name": "Riya Verma",
      "employee_mobile": "9988776655",
      "job_title": "Customer Support",
      "amount": 18000,
      "start_date": "2025-10-01",
      "end_date": "2025-10-31",
    },
    {
      "employee_name": "Sagar Patel",
      "employee_mobile": "8765432109",
      "job_title": "Delivery Executive",
      "amount": 12000,
      "start_date": "2025-10-10",
      "end_date": "2025-10-25",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              automaticallyImplyLeading: !isWeb,
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "Salary to Pay",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: AppColors.primary,
              elevation: 2,
            ),
            drawer: isWeb ? null : EmployerSidebar(),

            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    const SizedBox(height: 20),
              
                    Expanded(
                      child: duePayments.isEmpty
                          ? const Center(
                              child: Text(
                                "No pending salary payments.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: duePayments.length,
                              itemBuilder: (context, index) {
                                final item = duePayments[index];
              
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 18),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 26,
                                        backgroundColor: AppColors.primary
                                            .withOpacity(0.12),
                                        child: const Icon(
                                          Icons.person,
                                          size: 28,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 18),
              
                                      // DETAILS
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item["employee_name"],
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item["job_title"],
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item["employee_mobile"],
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 22),
              
                                            // Duration
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_month,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "${item["start_date"]} \n→ ${item["end_date"]}",
                                                  style: const TextStyle(
                                                    fontSize: 13.5,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
              
                                      // AMOUNT
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "₹${item["amount"]}",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Proceed to pay ₹${item["amount"]}",
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text("Pay Now"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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
}
