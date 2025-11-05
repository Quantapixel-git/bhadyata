import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_side_bar.dart';

class EmployerPostOneTimeJob extends StatefulWidget {
  const EmployerPostOneTimeJob({super.key});

  @override
  State<EmployerPostOneTimeJob> createState() =>
      _EmployerPostOneTimeJobState();
}

class _EmployerPostOneTimeJobState extends State<EmployerPostOneTimeJob> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Controllers
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _jobDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _paymentAmountController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _perksController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vacanciesController = TextEditingController();

  DateTime? _applicationDeadline;

  Future<void> _postOneTimeJob() async {
    FocusScope.of(context).unfocus(); // hide keyboard
    setState(() => isLoading = true);
    print("🔹 Starting one-time job post process...");

    try {
      final url = Uri.parse(
        'https://dialfirst.in/quantapixel/badhyata/api/OneTimeRecruitmentJobCreate',
      );

      final body = {
        "employer_id": 14,
        "title": _jobTitleController.text.trim(),
        "category": _categoryController.text.trim(),
        "job_date": _jobDateController.text.trim(),
        "start_time": _startTimeController.text.trim(),
        "end_time": _endTimeController.text.trim(),
        "duration": _durationController.text.trim(),
        "payment_amount": double.tryParse(_paymentAmountController.text) ?? 0,
        "payment_type": "One-Time",
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
        print("One-Time Job posted successfully!");
        _formKey.currentState!.reset();
        _clearControllers();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            // backgroundColor: Colors.green,
            content: Text("One-Time Job posted successfully!"),
          ),
        );
      } else {
        print("Failed to post one-time job. Message: ${data['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            // backgroundColor: Colors.red,
            content: Text("${data['message'] ?? 'Failed to post job'}"),
          ),
        );
      }
    } catch (e) {
      print("Exception occurred while posting one-time job: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          // backgroundColor: Colors.red,
          content: Text("Error: $e"),
        ),
      );
    } finally {
      setState(() => isLoading = false);
      print("One-time job post process completed.");
    }
  }

  void _clearControllers() {
    for (final c in [
      _jobTitleController,
      _categoryController,
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
                                    _buildTextField(
                                      _categoryController,
                                      "Job Category",
                                    ),
                                    _buildTextField(
                                      _jobDateController,
                                      "Job Date",
                                      keyboardType: TextInputType.datetime,
                                    ),
                                    _buildTextField(
                                      _startTimeController,
                                      "Start Time",
                                    ),
                                    _buildTextField(
                                      _endTimeController,
                                      "End Time",
                                    ),
                                    _buildTextField(
                                      _durationController,
                                      "Duration",
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
                                    _buildTextField(
                                      _perksController,
                                      "Perks",
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
                                                _postOneTimeJob();
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
