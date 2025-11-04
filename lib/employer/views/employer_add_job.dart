import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  String jobTitle = '';
  String jobDescription = '';
  String jobCategory = '';
  String hiringType = 'Salary based employment offer'; // default
  int vacancies = 1;
  double paymentValue = 0.0;
  DateTime? deadline;

  final List<String> hiringTypes = [
    'Salary based employment offer',
    'Commission based hiring by agent',
    'One-time recruitment',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Job Opportunity"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Title
              DropdownButtonFormField<String>(
                value: hiringType,
                decoration: const InputDecoration(
                  labelText: "Hiring Type",
                  border: OutlineInputBorder(),
                ),
                items: hiringTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    hiringType = val!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Job Title",
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => jobTitle = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter job title" : null,
              ),
              const SizedBox(height: 16),

              // Job Description
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Job Description",
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => jobDescription = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter job description" : null,
              ),
              const SizedBox(height: 16),

              // Job Category
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Job Category",
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => jobCategory = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter job category" : null,
              ),
              const SizedBox(height: 16),

              // Hiring Type Dropdown

              // Number of Vacancies
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Number of Vacancies",
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => vacancies = int.tryParse(val ?? '1') ?? 1,
                validator: (val) => val == null || val.isEmpty
                    ? "Enter number of vacancies"
                    : null,
              ),
              const SizedBox(height: 16),

              // Payment Value (optional)
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: hiringType.contains('Commission')
                      ? "Commission %"
                      : "Payment Amount",
                  border: const OutlineInputBorder(),
                ),
                onSaved: (val) =>
                    paymentValue = double.tryParse(val ?? '0') ?? 0.0,
              ),
              const SizedBox(height: 16),

              // Deadline Picker
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Deadline",
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        deadline != null
                            ? "${deadline!.day}/${deadline!.month}/${deadline!.year}"
                            : "Select Deadline",
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
                        setState(() {
                          deadline = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Handle form submission
                      print("Job Title: $jobTitle");
                      print("Description: $jobDescription");
                      print("Category: $jobCategory");
                      print("Hiring Type: $hiringType");
                      print("Vacancies: $vacancies");
                      print("Payment Value: $paymentValue");
                      print("Deadline: $deadline");

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text("Job added successfully!"),
                        ),
                      );
                      _formKey.currentState!.reset();
                      setState(() {
                        hiringType = hiringTypes[0];
                        deadline = null;
                      });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text("Add Job", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
