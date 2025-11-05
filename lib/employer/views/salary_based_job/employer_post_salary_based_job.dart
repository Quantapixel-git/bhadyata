import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_side_bar.dart';

class EmployerPostSalaryBasedJob extends StatefulWidget {
  const EmployerPostSalaryBasedJob({super.key});

  @override
  State<EmployerPostSalaryBasedJob> createState() =>
      _EmployerPostSalaryBasedJobState();
}

class _EmployerPostSalaryBasedJobState
    extends State<EmployerPostSalaryBasedJob> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Controllers
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _salaryMinController = TextEditingController();
  final TextEditingController _salaryMaxController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _responsibilitiesController =
      TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vacanciesController = TextEditingController();

  DateTime? _deadline;

  String jobType = 'Full-Time';
  String salaryType = 'Monthly';

  final List<String> jobTypes = ['Full-Time', 'Part-Time', 'Internship'];
  final List<String> salaryTypes = ['Monthly', 'Yearly', 'Weekly'];

  Future<void> _postSalaryBasedJob() async {
    FocusScope.of(context).unfocus(); // hide keyboard
    setState(() => isLoading = true);
    print("🔹 Starting job post process...");

    try {
      final url = Uri.parse(
        'https://dialfirst.in/quantapixel/badhyata/api/SalaryBasedJobCreate',
      );

      final body = {
        "employer_id": 14,
        "title": _jobTitleController.text.trim(),
        "category": _categoryController.text.trim(),
        "job_type": jobType,
        "experience_required": _experienceController.text.trim(),
        "qualification": _qualificationController.text.trim(),
        "skills": _skillsController.text.trim(),
        "salary_min": double.tryParse(_salaryMinController.text) ?? 0,
        "salary_max": double.tryParse(_salaryMaxController.text) ?? 0,
        "salary_type": salaryType,
        "location": _locationController.text.trim(),
        "job_description": _jobDescriptionController.text.trim(),
        "responsibilities": _responsibilitiesController.text.trim(),
        "benefits": _benefitsController.text.trim(),
        "openings": int.tryParse(_vacanciesController.text) ?? 1,
        "application_deadline": _deadline != null
            ? "${_deadline!.year}-${_deadline!.month.toString().padLeft(2, '0')}-${_deadline!.day.toString().padLeft(2, '0')}"
            : null,
        "contact_email": _emailController.text.trim(),
        "contact_phone": _phoneController.text.trim(),
        "status": "Active",
      };

      print("🧾 Request body: ${jsonEncode(body)}");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("📬 Response status: ${response.statusCode}");
      print("📥 Raw response body: ${response.body}");

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data["success"] == true) {
        print("✅ Job posted successfully!");
        _formKey.currentState!.reset();
        _clearControllers();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            content: Text("✅ Job posted successfully!"),
          ),
        );
      } else {
        print("❌ Failed to post job. Message: ${data['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Text("${data['message'] ?? 'Failed to post job'}"),
          ),
        );
      }
    } catch (e) {
      print("🔥 Exception occurred while posting job: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text("Error: $e"),
        ),
      );
    } finally {
      setState(() => isLoading = false);
      print("🏁 Job post process completed.");
    }
  }

  void _clearControllers() {
    for (final c in [
      _jobTitleController,
      _jobDescriptionController,
      _categoryController,
      _experienceController,
      _qualificationController,
      _skillsController,
      _salaryMinController,
      _salaryMaxController,
      _locationController,
      _responsibilitiesController,
      _benefitsController,
      _emailController,
      _phoneController,
      _vacanciesController,
    ]) {
      c.clear();
    }
    setState(() {
      _deadline = null;
      jobType = jobTypes[0];
      salaryType = salaryTypes[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Stack(
            children: [
              Column(
                children: [
                  AppBar(
                    iconTheme: const IconThemeData(color: Colors.white),
                    automaticallyImplyLeading: !isWeb,
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
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade100,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 650),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _buildTextField(
                                      _jobTitleController,
                                      "Job Title",
                                    ),
                                    _buildTextField(
                                      _categoryController,
                                      "Job Category",
                                    ),
                                    _buildDropdown(
                                      "Job Type",
                                      jobType,
                                      jobTypes,
                                      (val) {
                                        setState(() => jobType = val!);
                                      },
                                    ),
                                    _buildTextField(
                                      _experienceController,
                                      "Experience Required",
                                    ),
                                    _buildTextField(
                                      _qualificationController,
                                      "Qualification",
                                    ),
                                    _buildTextField(
                                      _skillsController,
                                      "Skills",
                                    ),
                                    _buildSalaryFields(),
                                    _buildDropdown(
                                      "Salary Type",
                                      salaryType,
                                      salaryTypes,
                                      (val) {
                                        setState(() => salaryType = val!);
                                      },
                                    ),
                                    _buildTextField(
                                      _locationController,
                                      "Location",
                                    ),
                                    _buildTextField(
                                      _jobDescriptionController,
                                      "Job Description",
                                      maxLines: 3,
                                    ),
                                    _buildTextField(
                                      _responsibilitiesController,
                                      "Responsibilities",
                                    ),
                                    _buildTextField(
                                      _benefitsController,
                                      "Benefits",
                                    ),
                                    _buildTextField(
                                      _emailController,
                                      "Contact Email",
                                    ),
                                    _buildTextField(
                                      _phoneController,
                                      "Contact Phone",
                                    ),
                                    _buildTextField(
                                      _vacanciesController,
                                      "Number of Vacancies",
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 14),
                                    _buildDatePicker(context),
                                    const SizedBox(height: 24),
                                    ElevatedButton.icon(
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _postSalaryBasedJob();
                                              }
                                            },
                                      icon: const Icon(Icons.post_add, color: Colors.white, size: 25,),
                                      label: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          isLoading ? "Posting..." : "Post Job",
                                          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
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
                      ),
                    ),
                  ),
                ],
              ),

              /// 🔄 Loading overlay
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 12),
                        Text(
                          "Posting job...",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (val) =>
            val == null || val.isEmpty ? "Please enter $label" : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: items
            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSalaryFields() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            _salaryMinController,
            "Min Salary",
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTextField(
            _salaryMaxController,
            "Max Salary",
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: "Application Deadline",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              _deadline != null
                  ? "${_deadline!.day}/${_deadline!.month}/${_deadline!.year}"
                  : "Select Date",
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              setState(() => _deadline = picked);
            }
          },
        ),
      ],
    );
  }
}
