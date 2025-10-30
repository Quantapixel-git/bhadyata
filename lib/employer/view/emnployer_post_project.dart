import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/view/drawer_dashboard/employer_side_bar.dart';

class PostProjectPage extends StatefulWidget {
  const PostProjectPage({super.key});

  @override
  State<PostProjectPage> createState() => _PostProjectPageState();
}

class _PostProjectPageState extends State<PostProjectPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _projectDescriptionController =
      TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();

  void _postProject() {
    if (_formKey.currentState!.validate()) {
      final title = _projectTitleController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Project '$title' posted successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return EmployerDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Post Project",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Project Title
                    TextFormField(
                      controller: _projectTitleController,
                      decoration: const InputDecoration(
                        labelText: "Project Title",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? "Enter project title"
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // Project Description
                    TextFormField(
                      controller: _projectDescriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Project Description",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? "Enter project description"
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // Deadline
                    TextFormField(
                      controller: _deadlineController,
                      decoration: const InputDecoration(
                        labelText: "Deadline (e.g., 25 Oct 2025)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? "Enter project deadline"
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // Assigned To
                    TextFormField(
                      controller: _assignedToController,
                      decoration: const InputDecoration(
                        labelText: "Assign To (Employee Name)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Enter assignee" : null,
                    ),
                    const SizedBox(height: 24),

                    // Post Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.post_add),
                        label: const Text("Post Project"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _postProject,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
