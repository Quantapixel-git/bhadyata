import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

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

  // --- NEW: category state ---
  List<String> _categories = [];
  String? _selectedCategory;
  bool _catLoading = true;

  // Controllers
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  // REMOVED: final TextEditingController _categoryController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // --- NEW: load categories from API ---
  Future<void> _loadCategories() async {
    setState(() => _catLoading = true);
    try {
      final uri = Uri.parse(
          'https://dialfirst.in/quantapixel/badhyata/api/getallcategory');
      final res = await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final decoded = jsonDecode(res.body);
        if ((decoded['status'] == 1) && decoded['data'] is List) {
          final List data = decoded['data'];
          final names = data
              .map((e) => (e['category_name'] ?? '').toString())
              .where((s) => s.isNotEmpty)
              .toSet() // de-dupe just in case
              .toList()
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

          setState(() {
            _categories = names;
            _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
          });
        } else {
          // fallback: empty list
          setState(() {
            _categories = [];
            _selectedCategory = null;
          });
        }
      } else {
        setState(() {
          _categories = [];
          _selectedCategory = null;
        });
      }
    } catch (_) {
      setState(() {
        _categories = [];
        _selectedCategory = null;
      });
    } finally {
      if (mounted) setState(() => _catLoading = false);
    }
  }

  Future<void> _postSalaryBasedJob() async {
  FocusScope.of(context).unfocus();
  setState(() => isLoading = true);

  try {
    // 🔑 get employer_id from session
    final userIdStr = await SessionManager.getValue('employer_id');
    if (userIdStr == null || userIdStr.toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Employer ID not found. Please log in again."),
        ),
      );
      setState(() => isLoading = false);
      return;
    }
    // If your API expects a number, keep it as int where possible
    final employerId = int.tryParse(userIdStr.toString()) ?? userIdStr;

    final url = Uri.parse(
      'https://dialfirst.in/quantapixel/badhyata/api/SalaryBasedJobCreate',
    );

    final body = {
      "employer_id": employerId, // ✅ dynamic from session
      "title": _jobTitleController.text.trim(),
      "category": _selectedCategory ?? "",
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

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        data["success"] == true) {
      _formKey.currentState!.reset();
      _clearControllers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          // backgroundColor: Colors.green,
          content: Text("Job posted successfully!"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          // backgroundColor: Colors.red,
          content: Text("${data['message'] ?? 'Failed to post job'}"),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        // backgroundColor: Colors.red,
        content: Text("Error: $e"),
      ),
    );
  } finally {
    setState(() => isLoading = false);
  }
}

  void _clearControllers() {
    for (final c in [
      _jobTitleController,
      _jobDescriptionController,
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
      // keep selected category as is; you can also reset:
      // _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
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
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _buildTextField(_jobTitleController, "Job Title"),
                                    // --- NEW: Category dropdown field ---
                                    _buildCategoryField(),
                                    _buildDropdown(
                                      "Job Type",
                                      jobType,
                                      jobTypes,
                                      (val) => setState(() => jobType = val!),
                                    ),
                                    _buildTextField(_experienceController, "Experience Required"),
                                    _buildTextField(_qualificationController, "Qualification"),
                                    _buildTextField(_skillsController, "Skills"),
                                    _buildSalaryFields(),
                                    _buildDropdown(
                                      "Salary Type",
                                      salaryType,
                                      salaryTypes,
                                      (val) => setState(() => salaryType = val!),
                                    ),
                                    _buildTextField(_locationController, "Location"),
                                    _buildTextField(_jobDescriptionController, "Job Description", maxLines: 3),
                                    _buildTextField(_responsibilitiesController, "Responsibilities"),
                                    _buildTextField(_benefitsController, "Benefits"),
                                    _buildTextField(_emailController, "Contact Email"),
                                    _buildTextField(_phoneController, "Contact Phone"),
                                    _buildTextField(_vacanciesController, "Number of Vacancies", keyboardType: TextInputType.number),
                                    const SizedBox(height: 14),
                                    _buildDatePicker(context),
                                    const SizedBox(height: 24),
                                    ElevatedButton.icon(
                                      onPressed: (isLoading || _catLoading)
                                          ? null
                                          : () {
                                              if (_formKey.currentState!.validate()) {
                                                _postSalaryBasedJob();
                                              }
                                            },
                                      icon: const Icon(Icons.post_add, color: Colors.white, size: 25),
                                      label: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          isLoading ? "Posting..." : "Post Job",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
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
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 12),
                        Text("Posting job...",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
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

  // --- NEW: Category dropdown builder ---
  Widget _buildCategoryField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: _catLoading ? "Loading categories..." : "Job Category",
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: _categories
            .map((name) => DropdownMenuItem<String>(
                  value: name,
                  child: Text(name),
                ))
            .toList(),
        onChanged: _catLoading
            ? null
            : (val) {
                setState(() => _selectedCategory = val);
              },
        validator: (_) {
          if (_selectedCategory == null || _selectedCategory!.isEmpty) {
            return "Please select Job Category";
          }
          return null;
        },
      ),
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
