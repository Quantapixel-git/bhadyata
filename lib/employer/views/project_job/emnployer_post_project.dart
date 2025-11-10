import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class PostProjectPage extends StatefulWidget {
  const PostProjectPage({super.key});

  @override
  State<PostProjectPage> createState() => _PostProjectPageState();
}

class _PostProjectPageState extends State<PostProjectPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Controllers
  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _projectDescriptionController =
      TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _budgetMinController = TextEditingController();
  final TextEditingController _budgetMaxController = TextEditingController();
  final TextEditingController _skillsRequiredController =
      TextEditingController();
  final TextEditingController _experienceLevelController =
      TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _deliverablesController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _vacanciesController = TextEditingController();

  DateTime? _applicationDeadline;

  Future<void> _postProject() async {
    FocusScope.of(context).unfocus(); // Hide keyboard
    setState(() => isLoading = true);

    try {
      final url = Uri.parse(
        'https://dialfirst.in/quantapixel/badhyata/api/ProjectCreate',
      );

      final body = {
        "employer_id": 14,
        "title": _projectTitleController.text.trim(),
        "category": _categoryController.text.trim(),
        "description": _projectDescriptionController.text.trim(),
        "budget_min": double.tryParse(_budgetMinController.text) ?? 0,
        "budget_max": double.tryParse(_budgetMaxController.text) ?? 0,
        "budget_type":
            "Fixed", // You can modify based on additional input if needed
        "skills_required": _skillsRequiredController.text.trim(),
        "experience_level": _experienceLevelController.text.trim(),
        "duration": _durationController.text.trim(),
        "location": _locationController.text.trim(),
        "deliverables": _deliverablesController.text.trim(),
        "preferred_freelancer_type": "Individual", // Modify based on input
        "application_deadline": _applicationDeadline != null
            ? "${_applicationDeadline!.year}-${_applicationDeadline!.month.toString().padLeft(2, '0')}-${_applicationDeadline!.day.toString().padLeft(2, '0')}"
            : null,
        "openings": int.tryParse(_vacanciesController.text) ?? 1,
        "contact_email": _contactEmailController.text.trim(),
        "contact_phone": _contactPhoneController.text.trim(),
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Project posted successfully!"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        _formKey.currentState!.reset();
        _clearControllers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Failed to post project'),
            behavior: SnackBarBehavior.floating,
            // backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          behavior: SnackBarBehavior.floating,
          // backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _clearControllers() {
    for (final controller in [
      _projectTitleController,
      _projectDescriptionController,
      _categoryController,
      _budgetMinController,
      _budgetMaxController,
      _skillsRequiredController,
      _experienceLevelController,
      _durationController,
      _locationController,
      _deliverablesController,
      _contactEmailController,
      _contactPhoneController,
      _vacanciesController,
    ]) {
      controller.clear();
    }
    setState(() {
      _applicationDeadline = null;
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
                  // Consistent AppBar
                  AppBar(
                    iconTheme: const IconThemeData(color: Colors.white),
                    automaticallyImplyLeading: !isWeb,
                    title: const Text(
                      "Post Project",
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
                                      _projectTitleController,
                                      "Project Title",
                                    ),
                                    _buildTextField(
                                      _categoryController,
                                      "Category",
                                    ),
                                    _buildTextField(
                                      _projectDescriptionController,
                                      "Project Description",
                                      maxLines: 4,
                                    ),
                                    _buildBudgetFields(),
                                    _buildTextField(
                                      _skillsRequiredController,
                                      "Skills Required",
                                    ),
                                    _buildTextField(
                                      _experienceLevelController,
                                      "Experience Level",
                                    ),
                                    _buildTextField(
                                      _durationController,
                                      "Duration",
                                    ),
                                    _buildTextField(
                                      _locationController,
                                      "Location",
                                    ),
                                    _buildTextField(
                                      _deliverablesController,
                                      "Deliverables",
                                    ),
                                    _buildTextField(
                                      _contactEmailController,
                                      "Contact Email",
                                    ),
                                    _buildTextField(
                                      _contactPhoneController,
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
                                                _postProject();
                                              }
                                            },
                                      icon: const Icon(
                                        Icons.post_add,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      label: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          isLoading
                                              ? "Posting..."
                                              : "Post Project",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
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

              // Loading overlay
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
                          "Posting project...",
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

  Widget _buildBudgetFields() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            _budgetMinController,
            "Min Budget",
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTextField(
            _budgetMaxController,
            "Max Budget",
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
              _applicationDeadline != null
                  ? "${_applicationDeadline!.day}/${_applicationDeadline!.month}/${_applicationDeadline!.year}"
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
              setState(() => _applicationDeadline = picked);
            }
          },
        ),
      ],
    );
  }
}
