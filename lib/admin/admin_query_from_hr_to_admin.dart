import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_sidebar.dart';
import 'package:jobshub/hr/view/drawer_dashboard/hr_sidebar.dart';

class adminHRtoadminQueryPage extends StatefulWidget {
  const adminHRtoadminQueryPage({super.key});

  @override
  State<adminHRtoadminQueryPage> createState() => _adminHRtoadminQueryPageState();
}

class _adminHRtoadminQueryPageState extends State<adminHRtoadminQueryPage> {
  List<Map<String, dynamic>> queries = [
    {
      "query": "Please approve the new project budget",
      "reply": "Approved and updated",
      "date": "2025-10-20",
    },
    {
      "query": "Request to hire a new HR assistant",
      "reply": "",
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
        const SnackBar(content: Text("Reply submitted")));
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
    return Scaffold(
      appBar: AppBar(title: const Text("HR → Admin Queries"), centerTitle: true),
      drawer: AdminSidebar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: queries.length,
        itemBuilder: (context, index) {
          final query = queries[index];

          if (!_controllers.containsKey(index)) {
            _controllers[index] = TextEditingController();
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Query: ${query["query"]}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  query["reply"].isNotEmpty
                      ? Text(
                          "Reply: ${query["reply"]}",
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500),
                        )
                      : TextField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            hintText: "Write your reply...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send, color: Colors.blue),
                              onPressed: () => _sendReply(index),
                            ),
                          ),
                        ),
                  const SizedBox(height: 4),
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
    );
  }
}
