import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class EmployerPostCommissionBasedJob extends StatefulWidget {
  const EmployerPostCommissionBasedJob({super.key});

  @override
  State<EmployerPostCommissionBasedJob> createState() =>
      _EmployerPostCommissionBasedJobState();
}

class _EmployerPostCommissionBasedJobState
    extends State<EmployerPostCommissionBasedJob> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // ----- Category state (NEW) -----
  List<String> _categories = [];
  String? _selectedCategory;
  bool _catLoading = true;

  // Controllers
  final TextEditingController _jobTitleController = TextEditingController();
  // REMOVED: final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _commissionRateController =
      TextEditingController();
  final TextEditingController _commissionTypeController =
      TextEditingController();
  final TextEditingController _targetLeadsController = TextEditingController();
  final TextEditingController _potentialEarningsController =
      TextEditingController();
  final TextEditingController _leadTypeController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _workModeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _perksController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vacanciesController = TextEditingController();

  DateTime? _applicationDeadline;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Fetch categories (name list)
  Future<void> _loadCategories() async {
    setState(() => _catLoading = true);
    try {
      final uri = Uri.parse(
        'https://dialfirst.in/quantapixel/badhyata/api/getallcategory',
      );
      final res = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final decoded = jsonDecode(res.body);
        if (decoded['status'] == 1 && decoded['data'] is List) {
          final names =
              (decoded['data'] as List)
                  .map((e) => (e['category_name'] ?? '').toString())
                  .where((s) => s.isNotEmpty)
                  .toSet()
                  .toList()
                ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
          setState(() {
            _categories = names;
            _selectedCategory = _categories.isNotEmpty
                ? _categories.first
                : null;
          });
        } else {
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

  Future<void> _postCommissionBasedJob() async {
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
      final employerId = int.tryParse(userIdStr.toString()) ?? userIdStr;

      final url = Uri.parse(
        'https://dialfirst.in/quantapixel/badhyata/api/CommissionBasedJobCreate',
      );

      final body = {
        "employer_id": employerId, // ✅ from session
        "title": _jobTitleController.text.trim(),
        "category": _selectedCategory ?? "", // send category NAME
        "commission_rate": double.tryParse(_commissionRateController.text) ?? 0,
        "commission_type": _commissionTypeController.text.trim(),
        "target_leads": int.tryParse(_targetLeadsController.text) ?? 0,
        "potential_earning":
            double.tryParse(_potentialEarningsController.text) ?? 0,
        "lead_type": _leadTypeController.text.trim(),
        "industry": _industryController.text.trim(),
        "work_mode": _workModeController.text.trim(),
        "location": _locationController.text.trim(),
        "job_description": _jobDescriptionController.text.trim(),
        "requirements": _requirementsController.text.trim(),
        "perks": _perksController.text.trim(),
        "openings": int.tryParse(_vacanciesController.text) ?? 1,
        "application_deadline": _applicationDeadline != null
            ? "${_applicationDeadline!.year}-${_applicationDeadline!.month.toString().padLeft(2, '0')}-${_applicationDeadline!.day.toString().padLeft(2, '0')}"
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
            content: Text("Commission-based Job posted successfully!"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("${data['message'] ?? 'Failed to post job'}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
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
      _commissionRateController,
      _commissionTypeController,
      _targetLeadsController,
      _potentialEarningsController,
      _leadTypeController,
      _industryController,
      _workModeController,
      _locationController,
      _jobDescriptionController,
      _requirementsController,
      _perksController,
      _emailController,
      _phoneController,
      _vacanciesController,
    ]) {
      c.clear();
    }
    setState(() {
      _applicationDeadline = null;
      // keep selected category as-is (or reset)
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
                      "Post Commission-Based Job",
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
                                    // --- Category dropdown (NEW) ---
                                    _buildCategoryField(),
                                    _buildTextField(
                                      _commissionRateController,
                                      "Commission Rate (%)",
                                      keyboardType: TextInputType.number,
                                    ),
                                    _buildTextField(
                                      _commissionTypeController,
                                      "Commission Type",
                                    ),
                                    _buildTextField(
                                      _targetLeadsController,
                                      "Target Leads",
                                      keyboardType: TextInputType.number,
                                    ),
                                    _buildTextField(
                                      _potentialEarningsController,
                                      "Potential Earning",
                                      keyboardType: TextInputType.number,
                                    ),
                                    _buildTextField(
                                      _leadTypeController,
                                      "Lead Type",
                                    ),
                                    _buildTextField(
                                      _industryController,
                                      "Industry",
                                    ),
                                    _buildTextField(
                                      _workModeController,
                                      "Work Mode",
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
                                      _requirementsController,
                                      "Requirements",
                                    ),
                                    _buildTextField(_perksController, "Perks"),
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
                                      onPressed: (isLoading || _catLoading)
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _postCommissionBasedJob();
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

  // Category dropdown UI
  Widget _buildCategoryField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: _catLoading ? "Loading categories..." : "Category",
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: _categories
            .map(
              (name) =>
                  DropdownMenuItem<String>(value: name, child: Text(name)),
            )
            .toList(),
        onChanged: _catLoading
            ? null
            : (val) => setState(() => _selectedCategory = val),
        validator: (_) {
          if (_selectedCategory == null || _selectedCategory!.isEmpty) {
            return "Please select Category";
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
