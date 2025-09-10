import 'package:flutter/material.dart';
import 'package:jobshub/users/project_model.dart';

class UserAssignedProjectsScreen extends StatefulWidget {
  @override
  State<UserAssignedProjectsScreen> createState() =>
      _UserAssignedProjectsScreenState();
}

class _UserAssignedProjectsScreenState
    extends State<UserAssignedProjectsScreen> {
  List<ProjectModel> assignedProjects = [
    ProjectModel(
      title: 'Website Design',
      description: 'Create a landing page',
      budget: 5000,
      category: 'Design',
      paymentType: 'Salary',
      paymentValue: 5000,
      status: 'In Progress',
      deadline: DateTime.now().add(Duration(days: 7)),
    ),
    ProjectModel(
      title: 'Sales Campaign',
      description: 'Earn commission on sales',
      budget: 0,
      category: 'Marketing',
      paymentType: 'Commission',
      paymentValue: 10,
      status: 'In Progress',
      deadline: DateTime.now().add(Duration(days: 14)),
    ),
  ];

  final List<String> statusOptions = ['In Progress', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Assigned Projects',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: assignedProjects.length,
        itemBuilder: (context, index) {
          final project = assignedProjects[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(project.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.description),
                  Text(
                    'Payment: ${project.paymentType} '
                    '${project.paymentValue}${project.paymentType == "Commission" ? "%" : ""}',
                  ),
                  Text('Status: ${project.status}'),
                ],
              ),
              trailing: DropdownButton<String>(
                value: project.status,
                items: statusOptions
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (newStatus) {
                  setState(() {
                    project.status = newStatus!;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
