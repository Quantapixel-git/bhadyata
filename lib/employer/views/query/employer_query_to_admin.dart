import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class QueryToAdminPage extends StatefulWidget {
  const QueryToAdminPage({super.key});

  @override
  State<QueryToAdminPage> createState() => _QueryToAdminPageState();
}

class _QueryToAdminPageState extends State<QueryToAdminPage> {
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateStr; // fallback if parsing fails
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  List<dynamic> _queries = [];
  final String baseUrl = "https://dialfirst.in/quantapixel/badhyata/api/";

  // 📨 Submit Query API
  Future<void> _submitQuery() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final body = {
      "sender_id": 14,
      "sender_role": "employer",
      "subject": _subjectController.text.trim(),
      "message": _messageController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}GeneralQueryCreate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            data['success'] == true
                ? "✅ ${data['message']}"
                : "⚠️ ${data['message']}",
          ),
        ),
      );

      if (data['success'] == true) {
        _subjectController.clear();
        _messageController.clear();
        _fetchQueries(); // refresh list
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Error: $e"),
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  // 📋 Fetch Queries API
  Future<void> _fetchQueries() async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}GeneralQueryList"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"sender_role": "employer"}),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() => _queries = data['data']);
      }
    } catch (e) {
      debugPrint("Error fetching queries: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchQueries();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Query to Admin",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
                bottom: const TabBar(
                  indicatorColor: Colors.white,
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(text: "Write Query"),
                    Tab(text: "My Queries"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  // 📝 Tab 1: Write Query
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 650),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16),
                              const Text(
                                "Submit Your Query to Admin",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _subjectController,
                                decoration: const InputDecoration(
                                  labelText: "Subject",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) =>
                                    v!.isEmpty ? "Please enter subject" : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _messageController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  labelText: "Message",
                                  border: OutlineInputBorder(),
                                  alignLabelWithHint: true,
                                ),
                                validator: (v) =>
                                    v!.isEmpty ? "Please enter message" : null,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _isLoading
                                      ? null
                                      : () => _submitQuery(),
                                  icon: const Icon(Icons.send, size: 25),
                                  label: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      _isLoading ? "Sending..." : "Send Query",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 📜 Tab 2: My Queries
                  RefreshIndicator(
                    onRefresh: _fetchQueries,
                    child: _queries.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Text(
                                "No previous queries found.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _queries.length,
                            itemBuilder: (context, index) {
                              final q = _queries[index];
                              return Card(
                                margin: const EdgeInsets.only(
                                  bottom: 12,
                                  top: 4,
                                ),
                                child: ListTile(
                                  title: Text(q['subject']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(q['message']),
                                      const SizedBox(height: 6),
                                      if (q['reply_message'] != null)
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(
                                            top: 6.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            "💬 Reply: ${q['reply_message']}",
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Created: ${_formatDate(q['created_at'])}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    q['status'].toString().toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: q['status'] == 'open'
                                          ? Colors.orange
                                          : Colors.green,
                                    ),
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
      },
    );
  }
}
