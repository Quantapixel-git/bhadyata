import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class EmployerPostOneTimeJob extends StatefulWidget {
  const EmployerPostOneTimeJob({super.key});

  @override
  State<EmployerPostOneTimeJob> createState() => _EmployerPostOneTimeJobState();
}

class _EmployerPostOneTimeJobState extends State<EmployerPostOneTimeJob> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // --- Category State (NEW) ---
  List<String> _categories = [];
  String? _selectedCategory;
  bool _catLoading = true;

  // Controllers
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _paymentAmountController =
      TextEditingController();
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

  @override
  void dispose() {
    _jobTitleController.dispose();
    _jobDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _durationController.dispose();
    _paymentAmountController.dispose();
    _locationController.dispose();
    _jobDescriptionController.dispose();
    _requirementsController.dispose();
    _perksController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _vacanciesController.dispose();
    super.dispose();
  }

  // parse a TimeOfDay from localized string like "9:30 AM" or "09:30"
  TimeOfDay? _parseTimeOfDayFromString(String s) {
    try {
      final cleaned = s.trim();
      final ampmMatch = RegExp(r'([AaPp][Mm])$').firstMatch(cleaned);
      if (ampmMatch != null) {
        // likely format "9:30 AM" or "09:30 PM"
        final parts = cleaned
            .split(RegExp(r'[:\s]'))
            .where((p) => p.isNotEmpty)
            .toList();
        if (parts.length >= 2) {
          int hour = int.parse(parts[0]);
          final min = int.parse(parts[1]);
          final ampm = parts.length > 2
              ? parts[2].toLowerCase()
              : (cleaned.toLowerCase().contains('pm') ? 'pm' : 'am');
          if (ampm == 'pm' && hour != 12) hour += 12;
          if (ampm == 'am' && hour == 12) hour = 0;
          return TimeOfDay(hour: hour, minute: min);
        }
      } else {
        // try "HH:MM"
        final parts = cleaned.split(':');
        if (parts.length >= 2) {
          final hour = int.parse(parts[0]);
          final min = int.parse(parts[1]);
          return TimeOfDay(hour: hour, minute: min);
        }
      }
    } catch (_) {}
    return null;
  }

  // compute duration string using TimeOfDay objects
  String _computeDurationString(TimeOfDay? start, TimeOfDay? end) {
    if (start == null || end == null) return '';
    final today = DateTime.now();
    final dtStart = DateTime(
      today.year,
      today.month,
      today.day,
      start.hour,
      start.minute,
    );
    var dtEnd = DateTime(
      today.year,
      today.month,
      today.day,
      end.hour,
      end.minute,
    );
    if (dtEnd.isBefore(dtStart)) dtEnd = dtEnd.add(const Duration(days: 1));
    final dur = dtEnd.difference(dtStart);
    final h = dur.inHours;
    final m = dur.inMinutes % 60;
    if (h > 0 && m > 0) return '${h}h ${m}m';
    if (h > 0) return '${h}h';
    return '${m}m';
  }

  // convert TimeOfDay to 24-hour HH:mm string
  String _to24Hour(TimeOfDay? t) {
    if (t == null) return '';
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  // --- Fetch categories (NEW) ---
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
        if ((decoded['status'] == 1) && decoded['data'] is List) {
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

  Future<void> _postOneTimeJob() async {
    FocusScope.of(context).unfocus(); // hide keyboard
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
      // If your API expects a number, parse it (fallback to string if parsing fails)
      final employerId = int.tryParse(userIdStr.toString()) ?? userIdStr;

      // parse times to TimeOfDay so we can send machine-friendly values
      final startTOD = _parseTimeOfDayFromString(_startTimeController.text);
      final endTOD = _parseTimeOfDayFromString(_endTimeController.text);

      // compute duration machine-friendly if needed (e.g., minutes)
      String durationDisplay = _durationController.text.trim();

      final url = Uri.parse(
        'https://dialfirst.in/quantapixel/badhyata/api/OneTimeRecruitmentJobCreate',
      );

      final body = {
        "employer_id": employerId, // ✅ from session
        "title": _jobTitleController.text.trim(),
        "category": _selectedCategory ?? "",
        "job_date": _jobDateController.text.trim(), // YYYY-MM-DD
        "start_time": _to24Hour(startTOD), // HH:mm
        "end_time": _to24Hour(endTOD), // HH:mm
        "duration": durationDisplay,
        "payment_amount": double.tryParse(_paymentAmountController.text) ?? 0.0,
        "payment_type": "One-Time",
        "location": _locationController.text.trim(),
        "job_description": _jobDescriptionController.text.trim(),
        "requirements": _requirementsController.text.trim(),
        "perks": _perksController.text.trim(),
        "openings": int.tryParse(_vacanciesController.text) ?? 1,
        "application_deadline": _applicationDeadline != null
            ? "${_applicationDeadline!.year.toString().padLeft(4, '0')}-${_applicationDeadline!.month.toString().padLeft(2, '0')}-${_applicationDeadline!.day.toString().padLeft(2, '0')}"
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
            content: Text("One-Time Job posted successfully!"),
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
      _jobDateController,
      _startTimeController,
      _endTimeController,
      _durationController,
      _paymentAmountController,
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
                      "Post One-Time Job",
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
                                    // Job Date (date picker)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          final picked = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now().subtract(
                                              const Duration(days: 365 * 5),
                                            ),
                                            lastDate: DateTime.now().add(
                                              const Duration(days: 365 * 5),
                                            ),
                                          );
                                          if (picked != null) {
                                            _jobDateController.text =
                                                '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                                            setState(() {});
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: _jobDateController,
                                            decoration: InputDecoration(
                                              labelText: "Job Date",
                                              filled: true,
                                              fillColor: Colors.grey.shade50,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              suffixIcon: const Icon(
                                                Icons.calendar_today,
                                              ),
                                            ),
                                            validator: (val) =>
                                                val == null || val.isEmpty
                                                ? "Please enter Job Date"
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Start Time (time picker)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (picked != null) {
                                            _startTimeController.text =
                                                MaterialLocalizations.of(
                                                  context,
                                                ).formatTimeOfDay(picked);
                                            // if end already set, compute duration
                                            if (_endTimeController
                                                .text
                                                .isNotEmpty) {
                                              final end =
                                                  _parseTimeOfDayFromString(
                                                    _endTimeController.text,
                                                  );
                                              final start = picked;
                                              _durationController.text =
                                                  _computeDurationString(
                                                    start,
                                                    end,
                                                  );
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: _startTimeController,
                                            decoration: InputDecoration(
                                              labelText: "Start Time",
                                              filled: true,
                                              fillColor: Colors.grey.shade50,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              suffixIcon: const Icon(
                                                Icons.access_time,
                                              ),
                                            ),
                                            validator: (val) =>
                                                val == null || val.isEmpty
                                                ? "Please enter Start Time"
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // End Time (time picker)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (picked != null) {
                                            _endTimeController.text =
                                                MaterialLocalizations.of(
                                                  context,
                                                ).formatTimeOfDay(picked);
                                            // if start already set, compute duration
                                            if (_startTimeController
                                                .text
                                                .isNotEmpty) {
                                              final start =
                                                  _parseTimeOfDayFromString(
                                                    _startTimeController.text,
                                                  );
                                              final end = picked;
                                              _durationController.text =
                                                  _computeDurationString(
                                                    start,
                                                    end,
                                                  );
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: _endTimeController,
                                            decoration: InputDecoration(
                                              labelText: "End Time",
                                              filled: true,
                                              fillColor: Colors.grey.shade50,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              suffixIcon: const Icon(
                                                Icons.access_time,
                                              ),
                                            ),
                                            validator: (val) =>
                                                val == null || val.isEmpty
                                                ? "Please enter End Time"
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Duration - read-only (computed) — not required
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          controller: _durationController,
                                          decoration: InputDecoration(
                                            labelText: "Duration",
                                            filled: true,
                                            fillColor: Colors.grey.shade50,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    _buildTextField(
                                      _paymentAmountController,
                                      "Payment Amount",
                                      keyboardType: TextInputType.number,
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
                                                _postOneTimeJob();
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

  // --- Category dropdown widget (NEW) ---
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
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _applicationDeadline ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() => _applicationDeadline = picked);
                }
              },
              child: Text(
                _applicationDeadline != null
                    ? "${_applicationDeadline!.day}/${_applicationDeadline!.month}/${_applicationDeadline!.year}"
                    : "Select Date",
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _applicationDeadline ?? DateTime.now(),
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
