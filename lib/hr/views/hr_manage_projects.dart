import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobshub/extra/views/clients/client_create_project.dart';
import 'package:jobshub/hr/views/hr_create_notification.dart';
import 'package:jobshub/hr/views/drawer_dashboard/hr_sidebar.dart';
import 'package:jobshub/users/views/project_model.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class HrManageProjects extends StatefulWidget {
  final List<ProjectModel> projects;

  const HrManageProjects({super.key, required this.projects});

  @override
  State<HrManageProjects> createState() => _HrManageProjectsState();
}

class _HrManageProjectsState extends State<HrManageProjects> {
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
          status: "Completed",
          budget: 19.00,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 900;

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
                  return _projectCard(project, index, projectsToShow);
                },
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: projectsToShow.length,
                itemBuilder: (context, index) {
                  final project = projectsToShow[index];
                  return _projectCard(project, index, projectsToShow);
                },
              );

    if (isWeb) {
      // Permanent sidebar layout for web
      return Scaffold(
        body: Row(
          children: [
             HrSidebar(),
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Manage Projects",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  backgroundColor: AppColors.primary,
                  elevation: 2,
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
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: content,
                ),
                backgroundColor: Colors.grey[100],
              ),
            ),
          ],
        ),
      );
    } else {
      // Drawer layout for mobile
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
                  MaterialPageRoute(builder: (context) => HrCreateNotification()),
                );
              },
              child: const Text(
                "Add project",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
        drawer:  HrSidebar(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: content,
        ),
      );
    }
  }

  Widget _projectCard(
      ProjectModel project, int index, List<ProjectModel> projectsToShow) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(project.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.description,
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text("Category: ${project.category}"),
            Text("Payment: ${project.paymentType} (${project.paymentValue})"),
            Text(
                "Deadline: ${DateFormat('yyyy-MM-dd').format(project.deadline)}"),
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
  }
}
