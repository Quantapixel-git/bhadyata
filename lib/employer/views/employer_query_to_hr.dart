import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/drawer_dashboard/employer_side_bar.dart';

class QueryToHrPage extends StatefulWidget {
  const QueryToHrPage({super.key});

  @override
  State<QueryToHrPage> createState() => _QueryToHrPageState();
}

class _QueryToHrPageState extends State<QueryToHrPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _submitQuery() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Query sent to HR successfully!")),
      );
      _subjectController.clear();
      _messageController.clear();
    }
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
          child: Column(
            children: [
              // ✅ AppBar (no Scaffold)
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb, // hide menu icon on web
                title: const Text(
                  "Query to HR",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // ✅ Main body
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Submit Your Query to HR",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // 📝 Subject
                              TextFormField(
                                controller: _subjectController,
                                decoration: const InputDecoration(
                                  labelText: "Subject",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) => value!.isEmpty
                                    ? "Please enter a subject"
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // 💬 Message
                              TextFormField(
                                controller: _messageController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  labelText: "Message",
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) => value!.isEmpty
                                    ? "Please enter your message"
                                    : null,
                              ),
                              const SizedBox(height: 28),

                              // 🚀 Send Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _submitQuery,
                                  icon: const Icon(Icons.send),
                                  label: const Text("Send Query"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
}
