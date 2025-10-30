import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/hr/view/drawer_dashboard/hr_sidebar.dart';
// import 'package:jobshub/hr/view/drawer_dashboard/hr_dashboard_wrapper.dart';

class EmployeeQueryPage extends StatefulWidget {
  const EmployeeQueryPage({super.key});

  @override
  State<EmployeeQueryPage> createState() => _EmployeeQueryPageState();
}

class _EmployeeQueryPageState extends State<EmployeeQueryPage> {
  // Demo data — replace with API later
  List<Map<String, dynamic>> queries = [
    {
      "query": "When will we get the salary update?",
      "reply": "Salary will be credited on 30th Oct",
      "date": "2025-10-21",
    },
    {
      "query": "How do I apply for leave?",
      "reply": "Submit leave request via HR portal",
      "date": "2025-10-18",
    },
    {
      "query": "Can we work from home next week?",
      "reply": "", // Pending reply
      "date": "2025-10-19",
    },
  ];

  final Map<int, TextEditingController> _controllers = {};

  void _sendReply(int index) {
    final text = _controllers[index]?.text ?? "";
    if (text.isEmpty) return;

    setState(() {
      queries[index]["reply"] = text;
    });

    _controllers[index]?.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Reply submitted successfully")),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Employee Queries",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 2,
        ),
        drawer: HrSidebar(),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: queries.length,
          itemBuilder: (context, index) {
            final query = queries[index];
            _controllers.putIfAbsent(index, () => TextEditingController());

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
                    // 🔹 Query Text
                    Text(
                      "Query:",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(query["query"], style: const TextStyle(fontSize: 14)),

                    const SizedBox(height: 10),

                    // 🔹 Reply Section
                    query["reply"].isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.reply,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    query["reply"],
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : TextField(
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              hintText: "Write your reply...",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: AppColors.primary,
                                ),
                                onPressed: () => _sendReply(index),
                              ),
                            ),
                          ),

                    const SizedBox(height: 8),

                    // 🔹 Date Info
                    Text(
                      "Date: ${query["date"]}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
