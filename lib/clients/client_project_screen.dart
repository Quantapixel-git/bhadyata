import 'package:flutter/material.dart';
import 'package:jobshub/clients/client_create_project.dart';
import 'package:jobshub/users/project_model.dart';
import 'package:jobshub/utils/AppColor.dart';

import 'client_sidebar.dart'; // import the shared ClientSidebar

class ProjectListScreen extends StatefulWidget {
  final List<ProjectModel> projects;

  const ProjectListScreen({super.key, required this.projects});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 800; // breakpoint for web

    Widget content = widget.projects.isEmpty
        ? const Center(child: Text("No projects created yet."))
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: widget.projects.length,
            itemBuilder: (context, index) {
              final project = widget.projects[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    project.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.description,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text("Category: ${project.category}"),
                      Text("Payment: ${project.paymentType} (${project.paymentValue})"),
                      Text("Deadline: ${project.deadline.toLocal()}".split(' ')[0]),
                      Text("Status: ${project.status}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.projects.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Project deleted"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );

    if (isWeb) {
      // ---- Web Layout with permanent ClientSidebar ----
      return Scaffold(
        body: Row(
          children: [
            ClientSidebar(projects: widget.projects, isWeb: true),
            Expanded(
              child: Column(
                children: [
                  AppBar(
                    title: const Text(
                      "Manage Projects",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    backgroundColor: AppColors.primary,
                    iconTheme: const IconThemeData(color: Colors.white),
                    elevation: 4,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClientCreateProject()),
                          );
                        },
                        child: const Text(
                          "Add project",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  Expanded(child: content),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // ---- Mobile Layout with Drawer ----
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Manage Projects",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 4,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientCreateProject()),
                );
              },
              child: const Text(
                "Add project",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          ],
        ),
        drawer: ClientSidebar(projects: widget.projects), // drawer for mobile
        body: content,
      );
    }
  }
}
