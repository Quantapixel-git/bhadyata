import 'package:flutter/material.dart';
import 'package:jobshub/users/project_model.dart';
import 'package:jobshub/utils/AppColor.dart';

class ClientCreateProject extends StatefulWidget {
  const ClientCreateProject({super.key});

  @override
  State<ClientCreateProject> createState() => _ClientCreateProjectState();
}

class _ClientCreateProjectState extends State<ClientCreateProject> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();

  String? selectedCategory;
  String? paymentType;
  DateTime? deadline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Project',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWeb = constraints.maxWidth > 800;
          final double maxWidth = isWeb ? 800 : double.infinity;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  width: maxWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Description
                        if (isWeb)
                          Column(
                            children: [
                              TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Title',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Title is required'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 4,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Description is required'
                                    : null,
                              ),
                            ],
                          )
                        else ...[
                          TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Title is required'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Description is required'
                                : null,
                          ),
                        ],
                        const SizedBox(height: 16),

                        // Category and Payment Type
                        isWeb
                            ? Column(
                                children: [
                                  DropdownButtonFormField<String>(
                                    value: selectedCategory,
                                    items: ['Design', 'Development', 'Writing']
                                        .map(
                                          (cat) => DropdownMenuItem(
                                            value: cat,
                                            child: Text(cat),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) => setState(
                                      () => selectedCategory = value,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Category',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) => value == null
                                        ? 'Please select a category'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<String>(
                                    value: paymentType,
                                    items: ['Salary', 'Commission']
                                        .map(
                                          (type) => DropdownMenuItem(
                                            value: type,
                                            child: Text(type),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        paymentType = value;
                                        paymentController.clear();
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Payment Type',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) => value == null
                                        ? 'Please select a payment type'
                                        : null,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  DropdownButtonFormField<String>(
                                    value: selectedCategory,
                                    items: ['Design', 'Development', 'Writing']
                                        .map(
                                          (cat) => DropdownMenuItem(
                                            value: cat,
                                            child: Text(cat),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) => setState(
                                      () => selectedCategory = value,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Category',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) => value == null
                                        ? 'Please select a category'
                                        : null,
                                  ),
                                  const SizedBox(height: 10),
                                  DropdownButtonFormField<String>(
                                    value: paymentType,
                                    items: ['Salary', 'Commission']
                                        .map(
                                          (type) => DropdownMenuItem(
                                            value: type,
                                            child: Text(type),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        paymentType = value;
                                        paymentController.clear();
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Payment Type',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) => value == null
                                        ? 'Please select a payment type'
                                        : null,
                                  ),
                                ],
                              ),

                        const SizedBox(height: 16),

                        // Payment input
                        if (paymentType != null)
                          TextFormField(
                            controller: paymentController,
                            decoration: InputDecoration(
                              labelText: paymentType == 'Salary'
                                  ? 'Salary Amount'
                                  : 'Commission %',
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Enter a valid number';
                              }
                              return null;
                            },
                          ),

                        const SizedBox(height: 16),

                        // Deadline Picker
                        Row(
                          children: [
                            ElevatedButton(
                              child: const Text('Pick Deadline'),
                              onPressed: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => deadline = picked);
                                }
                              },
                            ),
                            const SizedBox(width: 16),
                            if (deadline != null)
                              Text(
                                'Deadline: ${deadline!.toLocal()}'.split(
                                  ' ',
                                )[0],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Create Project Button
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                isWeb ? 200 : double.infinity,
                                50,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  deadline != null) {
                                final project = ProjectModel(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  budget:
                                      double.tryParse(budgetController.text) ??
                                      0,
                                  category: selectedCategory ?? '',
                                  paymentType: paymentType ?? '',
                                  paymentValue:
                                      double.tryParse(paymentController.text) ??
                                      0,
                                  status: 'In Progress',
                                  deadline: deadline!,
                                );

                                debugPrint(
                                  'Created Project: ${project.title}, ${project.paymentType} ${project.paymentValue}',
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Project created successfully! 🎉',
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                _formKey.currentState!.reset();
                                titleController.clear();
                                descriptionController.clear();
                                budgetController.clear();
                                paymentController.clear();
                                setState(() {
                                  selectedCategory = null;
                                  paymentType = null;
                                  deadline = null;
                                });
                              } else if (deadline == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please pick a deadline'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: const Text('Create Project'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
