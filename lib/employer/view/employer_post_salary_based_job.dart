import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/view/drawer_dashboard/employer_side_bar.dart';

class PostSalaryJobPage extends StatefulWidget {
  const PostSalaryJobPage({super.key});

  @override
  State<PostSalaryJobPage> createState() => _PostSalaryJobPageState();
}

class _PostSalaryJobPageState extends State<PostSalaryJobPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  String jobType = "Full-time"; // Default dropdown value

  void _postJob() {
    if (_formKey.currentState!.validate()) {
      final jobTitle = _jobTitleController.text.trim();

      // TODO: Call API to post job

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Job '$jobTitle' posted successfully!"),
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
            "Post Salary-Based Job",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Job Title
                    TextFormField(
                      controller: _jobTitleController,
                      decoration: const InputDecoration(
                        labelText: "Job Title",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Please enter job title" : null,
                    ),
                    const SizedBox(height: 14),

                    // Job Description
                    TextFormField(
                      controller: _jobDescriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Job Description",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Please enter job description" : null,
                    ),
                    const SizedBox(height: 14),

                    // Job Type Dropdown
                    DropdownButtonFormField<String>(
                      value: jobType,
                      decoration: const InputDecoration(
                        labelText: "Job Type",
                        border: OutlineInputBorder(),
                      ),
                      items: ["Full-time", "Part-time", "Internship"]
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          jobType = val!;
                        });
                      },
                    ),
                    const SizedBox(height: 14),

                    // Salary
                    TextFormField(
                      controller: _salaryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Salary (per month)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Please enter salary" : null,
                    ),
                    const SizedBox(height: 14),

                    // Location
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: "Location",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Please enter location" : null,
                    ),
                    const SizedBox(height: 14),

                    // Experience
                    TextFormField(
                      controller: _experienceController,
                      decoration: const InputDecoration(
                        labelText: "Experience Required (e.g., 2-5 years)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Please enter experience" : null,
                    ),
                    const SizedBox(height: 24),

                    // Post Job Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.post_add),
                        label: const Text("Post Job"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _postJob,
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
