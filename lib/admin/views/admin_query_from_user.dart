import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class EmployeeQueryToAdminPage extends StatefulWidget {
  const EmployeeQueryToAdminPage({super.key});

  @override
  State<EmployeeQueryToAdminPage> createState() =>
      _EmployeeQueryToAdminPageState();
}

class _EmployeeQueryToAdminPageState extends State<EmployeeQueryToAdminPage> {
  List<Map<String, dynamic>> queries = [
    {
      "query": "When will the salary be credited?",
      "reply": "Salary will be processed on 30th Oct",
      "date": "21 Oct 2025",
    },
    {
      "query": "Request for work-from-home next week",
      "reply": "",
      "date": "20 Oct 2025",
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
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Reply submitted successfully"),
      ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return AdminDashboardWrapper(
          child: Column(
            children: [
              // ✅ AppBar same as AdminDashboard
              AppBar(
                automaticallyImplyLeading: !isWeb, // hide drawer icon on web
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: AppColors.primary,
                title: const Text(
                  "Employee → Admin Queries",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // ✅ Page Content
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: queries.length,
                    itemBuilder: (context, index) {
                      final query = queries[index];
                      _controllers.putIfAbsent(
                        index,
                        () => TextEditingController(),
                      );

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        shadowColor: AppColors.primary.withOpacity(0.2),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🟣 Query Header
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.1),
                                    child: Icon(
                                      Icons.question_answer,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      query["query"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // 💬 Reply or Input
                              query["reply"].toString().isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              query["reply"],
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w500,
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
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "Date: ${query["date"]}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
