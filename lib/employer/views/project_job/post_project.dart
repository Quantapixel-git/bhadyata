import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
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

  // store server-side field errors (keyed by server field name)
  final Map<String, String?> _fieldErrors = {};

  @override
  void dispose() {
    // Dispose controllers
    for (final c in [
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
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _postProject() async {
    FocusScope.of(context).unfocus(); // Hide keyboard

    // clear previous server-side errors
    setState(() {
      _fieldErrors.clear();
      isLoading = true;
    });

    // basic client-side checks (title & description required)
    if (_projectTitleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter Project Title'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => isLoading = false);
      return;
    }
    if (_projectDescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter Project Description'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      // 🔑 get employer_id from session (instead of static id)
      final userIdStr = await SessionManager.getValue('employer_id');
      if (userIdStr == null || userIdStr.toString().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Employer ID not found. Please log in again.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() => isLoading = false);
        return;
      }
      // parse to int if possible, otherwise keep as string (API may accept either)
      final employerId = int.tryParse(userIdStr.toString()) ?? userIdStr;

      final url = Uri.parse(
        'https://dialfirst.in/quantapixel/badhyata/api/ProjectCreate',
      );

      // Build request body only with values present (avoid sending nulls)
      final Map<String, dynamic> body = {
        "employer_id": employerId,
        "title": _projectTitleController.text.trim(),
        "category": _categoryController.text.trim(),
        "description": _projectDescriptionController.text.trim(),
        "budget_min": _budgetMinController.text.trim().isEmpty
            ? null
            : double.tryParse(_budgetMinController.text.trim()),
        "budget_max": _budgetMaxController.text.trim().isEmpty
            ? null
            : double.tryParse(_budgetMaxController.text.trim()),
        "budget_type": "Fixed",
        "skills_required": _skillsRequiredController.text.trim(),
        "experience_level": _experienceLevelController.text.trim(),
        "duration": _durationController.text.trim(),
        "location": _locationController.text.trim(),
        "deliverables": _deliverablesController.text.trim(),
        "preferred_freelancer_type": "Individual",
        "application_deadline": _applicationDeadline != null
            ? "${_applicationDeadline!.year.toString().padLeft(4, '0')}-${_applicationDeadline!.month.toString().padLeft(2, '0')}-${_applicationDeadline!.day.toString().padLeft(2, '0')}"
            : null,
        "openings": _vacanciesController.text.trim().isEmpty
            ? null
            : int.tryParse(_vacanciesController.text.trim()),
        "contact_email": _contactEmailController.text.trim(),
        "contact_phone": _contactPhoneController.text.trim(),
      };

      // Remove nulls and empty strings (server doesn't receive unwanted fields)
      final sanitizedBody = Map<String, dynamic>.from(body)
        ..removeWhere((k, v) => v == null || (v is String && v.isEmpty));

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(sanitizedBody),
      );

      // debug logs - remove in production if needed
      // ignore: avoid_print
      print('POST ${url.toString()} -> status ${response.statusCode}');
      // ignore: avoid_print
      print('response body: ${response.body}');

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Project posted successfully!"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        _formKey.currentState?.reset();
        _clearControllers();
      } else {
        // Surface sensible server-side validation feedback if available
        String message =
            data['message']?.toString() ?? 'Failed to post project';

        if (data['errors'] != null && data['errors'] is Map) {
          final Map errorsMap = data['errors'] as Map;
          errorsMap.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              _fieldErrors[key.toString()] = value[0].toString();
            } else {
              _fieldErrors[key.toString()] = value.toString();
            }
          });
          final firstErr = _fieldErrors.values.firstWhere(
            (e) => e != null && e.isNotEmpty,
            orElse: () => null,
          );
          if (firstErr != null) message = firstErr!;
        }

        // Sometimes APIs return field messages in different keys:
        if (data['data'] != null && data['data'] is Map) {
          final Map maybeErrors = data['data'] as Map;
          maybeErrors.forEach((k, v) {
            if (v is String && v.isNotEmpty) {
              _fieldErrors[k.toString()] = v;
            }
          });
        }

        if (_fieldErrors.isNotEmpty) {
          setState(() {}); // re-render to show inline errors
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      // network / parse error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          behavior: SnackBarBehavior.floating,
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
      _fieldErrors.clear();
    });
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? fieldKey,
    bool required = true,
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
          errorText: fieldKey != null ? _fieldErrors[fieldKey] : null,
        ),
        validator: (val) {
          if (!required) return null;
          if (val == null || val.trim().isEmpty) return "Please enter $label";
          if (fieldKey == 'contact_email') {
            final email = val.trim();
            final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
            if (!emailRegex.hasMatch(email)) return 'Enter a valid email';
          }
          if (fieldKey == 'contact_phone') {
            final phone = val.trim();
            final phoneRegex = RegExp(r'^\d{7,15}$');
            if (!phoneRegex.hasMatch(phone))
              return 'Enter a valid phone number';
          }
          if (fieldKey == 'budget_min' || fieldKey == 'budget_max') {
            if (val != null &&
                val.trim().isNotEmpty &&
                double.tryParse(val.trim()) == null) {
              return 'Enter a valid number';
            }
          }
          if (fieldKey == 'openings') {
            if (val != null &&
                val.trim().isNotEmpty &&
                int.tryParse(val.trim()) == null) {
              return 'Enter a valid integer';
            }
          }
          return null;
        },
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
            fieldKey: 'budget_min',
            required: false,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTextField(
            _budgetMaxController,
            "Max Budget",
            keyboardType: TextInputType.number,
            fieldKey: 'budget_max',
            required: false,
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
              errorText: _fieldErrors['application_deadline'],
            ),
            child: Text(
              _applicationDeadline != null
                  ? "${_applicationDeadline!.day.toString().padLeft(2, '0')}/${_applicationDeadline!.month.toString().padLeft(2, '0')}/${_applicationDeadline!.year}"
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
              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
            );
            if (picked != null) {
              setState(() => _applicationDeadline = picked);
            }
          },
        ),
      ],
    );
  }

  String _formatDateForDisplay(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";

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
                                      fieldKey: 'title',
                                      required: true,
                                    ),
                                    _buildTextField(
                                      _categoryController,
                                      "Category",
                                      fieldKey: 'category',
                                      required: false,
                                    ),
                                    _buildTextField(
                                      _projectDescriptionController,
                                      "Project Description",
                                      maxLines: 4,
                                      fieldKey: 'description',
                                      required: true,
                                    ),
                                    _buildBudgetFields(),
                                    _buildTextField(
                                      _skillsRequiredController,
                                      "Skills Required",
                                      fieldKey: 'skills_required',
                                      required: false,
                                    ),
                                    _buildTextField(
                                      _experienceLevelController,
                                      "Experience Level",
                                      fieldKey: 'experience_level',
                                      required: false,
                                    ),
                                    _buildTextField(
                                      _durationController,
                                      "Duration",
                                      fieldKey: 'duration',
                                      required: false,
                                    ),
                                    _buildTextField(
                                      _locationController,
                                      "Location",
                                      fieldKey: 'location',
                                      required: false,
                                    ),
                                    _buildTextField(
                                      _deliverablesController,
                                      "Deliverables",
                                      fieldKey: 'deliverables',
                                      required: false,
                                    ),
                                    _buildTextField(
                                      _contactEmailController,
                                      "Contact Email",
                                      keyboardType: TextInputType.emailAddress,
                                      fieldKey: 'contact_email',
                                      required: false,
                                    ),
                                    _buildTextField(
                                      _contactPhoneController,
                                      "Contact Phone",
                                      keyboardType: TextInputType.phone,
                                      fieldKey: 'contact_phone',
                                      required: false,
                                    ),
                                    _buildTextField(
                                      _vacanciesController,
                                      "Number of Vacancies",
                                      keyboardType: TextInputType.number,
                                      fieldKey: 'openings',
                                      required: false,
                                    ),
                                    const SizedBox(height: 14),
                                    _buildDatePicker(context),
                                    const SizedBox(height: 24),
                                    ElevatedButton.icon(
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              // First run client-side validators
                                              final ok =
                                                  _formKey.currentState
                                                      ?.validate() ??
                                                  false;
                                              if (!ok) return;
                                              _postProject();
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
}
