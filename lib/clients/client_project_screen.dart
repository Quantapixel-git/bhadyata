import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  // Demo projects to show when no projects are created
  List<ProjectModel> get demoProjects => [
        ProjectModel(
          title: "Mobile App Development",
          description:
              "Build a Flutter mobile application for e-commerce with payment gateway integration.",
          category: "Mobile Development",
          paymentType: "Fixed",
          paymentValue: 50.000,
           budget: 19.00,
          deadline: DateTime.now().add(const Duration(days: 30)),
          status: "In Progress",
        ),
        ProjectModel(
          title: "Website Redesign",
          description:
              "Redesign company website with modern UI/UX and responsive layout.",
          category: "Web Development",
          paymentType: "Hourly",
          deadline: DateTime.now().add(const Duration(days: 15)),
          paymentValue: 500,
          status: "Pending",
           budget: 19.00,
        ),
        ProjectModel(
          title: "Logo Design",
          description: "Create a modern logo for a startup brand.",
          category: "Design",
          paymentType: "Fixed",
          paymentValue: 5.000,
          deadline: DateTime.now().add(const Duration(days: 7)),
          status: "Completed", budget: 19.00,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isWeb = constraints.maxWidth > 800;

      // Use actual projects or demo projects if empty
      final List<ProjectModel> projectsToShow =
          widget.projects.isEmpty ? demoProjects : widget.projects;

      Widget content = projectsToShow.isEmpty
          ? const Center(
              child: Text(
                "No projects created yet.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : isWeb
              ? GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: projectsToShow.length,
                  itemBuilder: (context, index) {
                    final project = projectsToShow[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              project.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Chip(
                                  label: Text(project.category),
                                  backgroundColor: Colors.blue.shade100,
                                ),
                                const SizedBox(width: 6),
                                Chip(
                                  label: Text(project.status),
                                  backgroundColor: project.status == "Completed"
                                      ? Colors.green.shade100
                                      : project.status == "In Progress"
                                          ? Colors.orange.shade100
                                          : Colors.grey.shade300,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Payment: ${project.paymentType} (${project.paymentValue})",
                              style: const TextStyle(fontSize: 14),
                            ),
                             Text(
  "Deadline: ${DateFormat('yyyy-MM-dd').format(project.deadline)}",
  style: const TextStyle(fontSize: 14),
),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    projectsToShow.removeAt(index);
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
                          ],
                        ),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: projectsToShow.length,
                  itemBuilder: (context, index) {
                    final project = projectsToShow[index];
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
                            Text(
                                "Payment: ${project.paymentType} (${project.paymentValue})"),
                          Text(
  "Deadline: ${DateFormat('yyyy-MM-dd').format(project.deadline)}",
),


                            Text("Status: ${project.status}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              projectsToShow.removeAt(index);
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
          drawer: ClientSidebar(projects: widget.projects),
          body: content,
        );
      }
    });
  }
}
