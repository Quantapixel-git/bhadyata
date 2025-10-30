import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/view/drawer_dashboard/hr_sidebar.dart';
// import 'package:jobshub/hr/view/drawer_dashboard/hr_dashboard_wrapper.dart';

class AdminQueryPage extends StatefulWidget {
  const AdminQueryPage({super.key});

  @override
  State<AdminQueryPage> createState() => _AdminQueryPageState();
}

class _AdminQueryPageState extends State<AdminQueryPage> {
  final TextEditingController _queryController = TextEditingController();

  // Demo data — replace with API
  List<Map<String, dynamic>> queries = [
    {
      "employeeName": "Admin",
      "query": "New job is having some problem.",
      "replies": ["Ok HR"],
      "date": "2025-10-21",
    },
    {
      "employeeName": "Admin",
      "query": "Salary of last month employees are pending.",
      "replies": [],
      "date": "2025-10-18",
    },
  ];

  void _sendQuery() {
    if (_queryController.text.isEmpty) return;

    setState(() {
      queries.insert(0, {
        "employeeName": "All Employees",
        "query": _queryController.text.trim(),
        "replies": [],
        "date": DateTime.now().toString().split(' ')[0],
      });
    });

    _queryController.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Query sent to employees")));
  }

  @override
  Widget build(BuildContext context) {
    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Admin Queries",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 2,
        ),
        drawer: HrSidebar(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // 🔹 Query Input Field
              // TextField(
              //   controller: _queryController,
              //   decoration: InputDecoration(
              //     hintText: "Send query to employees...",
              //     hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     suffixIcon: IconButton(
              //       icon: Icon(Icons.send, color: AppColors.primary),
              //       onPressed: _sendQuery,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 12),

              // 🔹 Query List
              Expanded(
                child: ListView.builder(
                  itemCount: queries.length,
                  itemBuilder: (context, index) {
                    final query = queries[index];
                    final List replies = query["replies"] ?? [];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🟩 Query Text
                            Text(
                              "Query:",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              query["query"],
                              style: const TextStyle(fontSize: 14),
                            ),

                            const SizedBox(height: 10),

                            // 🟨 Replies Section
                            if (replies.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.reply,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Replies:",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ...replies.map<Widget>(
                                      (r) => Padding(
                                        padding: const EdgeInsets.only(
                                          left: 26.0,
                                        ),
                                        child: Text(
                                          "- $r",
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 8),

                            // 🕓 Date Info
                            Text(
                              "Date: ${query["date"]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
