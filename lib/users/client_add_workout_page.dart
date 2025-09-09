import 'package:flutter/material.dart';

class AddWorkPage extends StatefulWidget {
  const AddWorkPage({super.key});

  @override
  State<AddWorkPage> createState() => _AddWorkPageState();
}

class _AddWorkPageState extends State<AddWorkPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _budgetController = TextEditingController();

  String? _selectedCategory;
  final List<Map<String, dynamic>> _works = [];

  final List<String> _categories = [
    "Marketing",
    "Onboarding",
    "Sales",
    "Design",
    "Development",
    "Other"
  ];

  void _addWork() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _works.add({
          "title": _titleController.text,
          "category": _selectedCategory ?? "General",
          "desc": _descController.text,
          "budget": _budgetController.text,
          "status": "Pending", // always pending until admin approves
        });
        _titleController.clear();
        _descController.clear();
        _budgetController.clear();
        _selectedCategory = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Work submitted for approval"),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Client Work Submission"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Add Work Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Work Title",
                      prefixIcon: Icon(Icons.work),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter work title" : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: "Category",
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    items: _categories
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                    validator: (v) =>
                        v == null ? "Select a category" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter description" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _budgetController,
                    decoration: const InputDecoration(
                      labelText: "Budget / Salary",
                      prefixIcon: Icon(Icons.monetization_on),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _addWork,
                      icon: const Icon(Icons.add),
                      label: const Text("Submit Work"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Work List (Pending/Approved)
            Expanded(
              child: _works.isEmpty
                  ? const Center(
                      child: Text(
                        "No works submitted yet",
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _works.length,
                      itemBuilder: (context, index) {
                        final work = _works[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: const Icon(Icons.work, color: Colors.blue),
                            ),
                            title: Text(work["title"]),
                            subtitle: Text(
                                "${work["category"]}\n${work["desc"]}\nBudget: ${work["budget"]}"),
                            isThreeLine: true,
                            trailing: Chip(
                              label: Text(work["status"]),
                              backgroundColor: work["status"] == "Pending"
                                  ? Colors.orange.shade100
                                  : work["status"] == "Approved"
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                              labelStyle: TextStyle(
                                color: work["status"] == "Pending"
                                    ? Colors.orange
                                    : work["status"] == "Approved"
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
