import 'package:flutter/material.dart';
import 'project_model.dart';

class BrowseProjectsScreen extends StatelessWidget {
  final ProjectModel? newProject;

  BrowseProjectsScreen({super.key, this.newProject});

  final List<ProjectModel> projects = [
    ProjectModel(
      title: 'Website Design',
      description: 'Landing page project',
      budget: 5000,
      category: 'Design',
      paymentType: 'Salary',
      paymentValue: 5000,
      status: 'In Progress',
      deadline: DateTime.now().add(const Duration(days: 7)),
    ),
    ProjectModel(
      title: 'Sales Partner',
      description: 'Earn commission per sale',
      budget: 0,
      category: 'Marketing',
      paymentType: 'Commission',
      paymentValue: 15,
      status: 'In Progress',
      deadline: DateTime.now().add(const Duration(days: 15)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Add new project if passed
    if (newProject != null) {
      projects.insert(0, newProject!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Projects',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
         iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(project.title),
              subtitle: Text(
                '${project.category}\n'
                'Budget: ${project.budget}\n'
                '${project.paymentType}: '
                '${project.paymentValue}${project.paymentType == "Commission" ? "%" : ""}',
              ),
              trailing: ElevatedButton(
                child: const Text('Apply'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Applied to ${project.title}')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
