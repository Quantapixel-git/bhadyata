import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobshub/admin/admin_contact_us.dart';
import 'package:jobshub/admin/admin_dashboard.dart';
import 'package:jobshub/admin/admin_job_status.dart';
import 'package:jobshub/admin/admin_report_page.dart';
import 'package:jobshub/admin/admin_stats.dart';
import 'package:jobshub/admin/admin_user.dart';
import 'package:jobshub/admin/admin_view_notification_screen.dart';
import 'package:jobshub/admin/manage_kyc.dart';
import 'package:jobshub/clients/client_sidebar.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/utils/AppColor.dart';

// ------------------ Assign Work Form ------------------
class ClientAssignWorkScreen extends StatefulWidget {
  const ClientAssignWorkScreen({super.key});

  @override
  State<ClientAssignWorkScreen> createState() => _ClientAssignWorkScreenState();
}

class _ClientAssignWorkScreenState extends State<ClientAssignWorkScreen> {
  String? selectedCandidate;
  final List<String> candidates = ['John Doe', 'Jane Smith', 'Alex Johnson'];
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  Future<void> pickDate({required bool isStart}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _assignWork() {
    if (selectedCandidate == null ||
        jobTitleController.text.isEmpty ||
        startDate == null ||
        endDate == null ||
        paymentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final work = AssignedWork(
      candidate: selectedCandidate!,
      jobTitle: jobTitleController.text,
      startDate: startDate!,
      endDate: endDate!,
      payment: double.tryParse(paymentController.text) ?? 0,
    );

    Navigator.pop(context, work);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assign Work',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Candidate',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCandidate,
                items: candidates
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCandidate = val),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Choose Candidate',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Job Title',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: jobTitleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter job title',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Start Date',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => pickDate(isStart: true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(startDate != null
                                ? DateFormat('yyyy-MM-dd').format(startDate!)
                                : 'Select Start Date'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('End Date',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => pickDate(isStart: false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(endDate != null
                                ? DateFormat('yyyy-MM-dd').format(endDate!)
                                : 'Select End Date'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Payment',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: paymentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter payment amount',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _assignWork,
                  child: const Text('Assign Work'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ Assigned Work List ------------------
class AssignedWork {
  final String candidate;
  final String jobTitle;
  final DateTime startDate;
   DateTime endDate;
  final double payment;

  AssignedWork({
    required this.candidate,
    required this.jobTitle,
    required this.startDate,
    required this.endDate,
    required this.payment,
  });
}

// ------------------ Assigned Work List Screen ------------------
class AssignedWorkListScreen extends StatefulWidget {
  const AssignedWorkListScreen({super.key});

  @override
  State<AssignedWorkListScreen> createState() =>
      _AssignedWorkListScreenState();
}

class _AssignedWorkListScreenState extends State<AssignedWorkListScreen> {


  Widget _drawerItem(BuildContext context, IconData icon, String title, Widget page, bool isWeb) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ListTile(
        leading: Icon(icon, color: isWeb ? AppColors.primary : null),
        title: Text(
          title,
          style: TextStyle(
            color: isWeb ? Colors.black87 : null,
            fontWeight: isWeb ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        hoverColor: isWeb ? Colors.blue.shade50 : null,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }


  Drawer _buildDrawer(BuildContext context, {bool isWeb = false}) {
  return Drawer(
    elevation: 0,
    child: Column(
      children: [
        // ---------- Top Logo / Header ----------
        Container(
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/job_bgr.png"),
              ),
              const SizedBox(width: 12),
              if (!isWeb)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Admin Panel",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Mobile No: 9090909090",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
            ],
          ),
        ),

        // ---------- Drawer Items ----------
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _drawerItem(context, Icons.dashboard, "Dashboard",
                  const AdminDashboardPage(), isWeb),
              _drawerItem(context, Icons.pie_chart, "Chart", AdminStats(),
                  isWeb),
              _drawerItem(context, Icons.assignment, "Assign Work",
                  AssignedWorkListScreen(), isWeb),
              _drawerItem(context, Icons.report, "Job Status", JobStatusScreen(),
                  isWeb),
              _drawerItem(context, Icons.person_4_outlined, "Manage Users",
                  AdminUser(), isWeb),
              _drawerItem(context, Icons.person_search, "Manage KYC", ManageKyc(),
                  isWeb),
              _drawerItem(
                  context,
                  Icons.report,
                  "Reports",
                  AdminReportsPage(projects: dummyProjectsReports),
                  isWeb),
              _drawerItem(context, Icons.contact_page, "Contact Us",
                  AdminContactUsPage(), isWeb),
              _drawerItem(context, Icons.notifications, "View Notifications",
                  AdminViewNotificationScreen(), isWeb),
              _drawerItem(
                  context, Icons.logout, "Log out", LoginScreen(), isWeb),
            ],
          ),
        ),
      ],
    ),
  );
}

  final List<AssignedWork> assignedWorks = [
    AssignedWork(
      candidate: "John Doe",
      jobTitle: "Flutter Developer",
      startDate: DateTime(2025, 9, 1),
      endDate: DateTime(2025, 9, 27),
      payment: 12000,
    ),
    AssignedWork(
      candidate: "Jane Smith",
      jobTitle: "UI/UX Designer",
      startDate: DateTime(2025, 9, 15),
      endDate: DateTime(2025, 10, 10),
      payment: 15000,
    ),
  ];

  bool isExpired(AssignedWork work) => work.endDate.isBefore(DateTime.now());

  void extendJob(AssignedWork work) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: work.endDate.add(const Duration(days: 1)),
      firstDate: work.endDate.add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        work.endDate = picked;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '${work.jobTitle} extended till ${DateFormat('yyyy-MM-dd').format(work.endDate)}')));
    }
  }

  void terminateJob(AssignedWork work) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Terminate Job'),
        content: Text('Are you sure you want to terminate ${work.jobTitle}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                assignedWorks.remove(work);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job terminated successfully')),
              );
            },
            child: const Text('Terminate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 800;

    Widget content = assignedWorks.isEmpty
        ? const Center(child: Text("No work assigned yet"))
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: assignedWorks.length,
            itemBuilder: (context, index) {
              final work = assignedWorks[index];
              final expired = isExpired(work);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        work.jobTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text("Candidate: ${work.candidate}"),
                      Text(
                          "Start: ${DateFormat('yyyy-MM-dd').format(work.startDate)}"),
                      Text(
                          "End: ${DateFormat('yyyy-MM-dd').format(work.endDate)}"),
                      Text("Payment: ₹${work.payment.toStringAsFixed(2)}"),
                      if (expired) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => extendJob(work),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                child: const Text('Extend Job'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => terminateJob(work),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text('Terminate Job'),
                              ),
                            ),
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              );
            },
          );

    if (isWeb) {
      // ---- Web layout with permanent sidebar ----
      return Scaffold(
        body: Row(
          children: [
            ClientSidebar(projects: []), // Pass empty list or projects if needed
            Expanded(
              child: Column(
                children: [
                  AppBar(
                    title: const Text(
                      "Assigned Works",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    backgroundColor: AppColors.primary,
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ClientAssignWorkScreen()));
                          },
                          child: const Text(
                            "Add Work",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ))
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
      // ---- Mobile layout with drawer ----
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Assigned Works",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ClientAssignWorkScreen()));
                },
                child: const Text(
                  "Add Work",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ))
          ],
        ),
        drawer: ClientSidebar(projects: []), // drawer for mobile
        body: content,
      );
    }
  }
}

// ---- Dummy Report List ----
final List<ProjectModelReport> dummyProjectsReports = [
  ProjectModelReport(
    title: "Website Development",
    category: "IT & Software",
    budget: 50000,
    paymentType: "Fixed",
    paymentValue: 50000,
    deadline: DateTime.now().add(const Duration(days: 30)),
    applicants: [
      {"name": "Alice", "proposal": "I will build your website in Flutter"},
      {"name": "Bob", "proposal": "I can do it with ReactJS"},
    ],
    assignedUser: "Alice",
  ),
  ProjectModelReport(
    title: "Logo Design",
    category: "Design",
    budget: 5000,
    paymentType: "Fixed",
    paymentValue: 5000,
    deadline: DateTime.now().add(const Duration(days: 10)),
    applicants: [
      {"name": "Charlie", "proposal": "Professional logo design"},
    ],
    assignedUser: "Charlie",
  ),
];
