import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobshub/admin/admin_approved_screen.dart';
import 'package:jobshub/admin/admin_contact_us.dart';
import 'package:jobshub/admin/admin_dashboard.dart';
import 'package:jobshub/admin/admin_job_status.dart';
import 'package:jobshub/admin/admin_report_page.dart';
import 'package:jobshub/admin/admin_stats.dart';
import 'package:jobshub/admin/admin_user.dart';
import 'package:jobshub/admin/admin_view_notification_screen.dart';
import 'package:jobshub/admin/manage_kyc.dart';
import 'package:jobshub/users/login_screen.dart';
import 'package:jobshub/utils/AppColor.dart';

// ---------------- HR Work Assign Screen ----------------
class HrWorkAssignScreen extends StatefulWidget {
  const HrWorkAssignScreen({super.key});

  @override
  State<HrWorkAssignScreen> createState() => _HrWorkAssignScreenState();
}

class _HrWorkAssignScreenState extends State<HrWorkAssignScreen> {
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

  Widget _buildForm() {
    return Padding(
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
    );
  }

  // ---------------- DRAWER (same as JobStatusDashboard) ----------------
  Drawer _buildDrawer(BuildContext context, {bool isWeb = false}) {
    return Drawer(
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (!isWeb)
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(radius: 30, backgroundImage: AssetImage("assets/client.png")),
                  SizedBox(height: 10),
                  Text("Admin Panel", style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text("Mobile No: 9090909090", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
          _drawerItem(context, Icons.dashboard, "Dashboard", isWeb),
          _drawerItem(context, Icons.assignment, "Assign Work", isWeb, active: true),
          _drawerItem(context, Icons.report, "Job Status", isWeb),
          _drawerItem(context, Icons.people, "Users", isWeb),
          _drawerItem(context, Icons.logout, "Log out", isWeb),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, bool isWeb, {bool active = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ListTile(
        leading: Icon(icon, color: active ? AppColors.primary : Colors.grey[700]),
        title: Text(title,
            style: TextStyle(
                color: active ? AppColors.primary : Colors.black87,
                fontWeight: active ? FontWeight.bold : FontWeight.normal)),
        hoverColor: Colors.blue.shade50,
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isWeb = constraints.maxWidth > 900;

      return Scaffold(
        appBar: isWeb
            ? null
            : AppBar(
                title: const Text('Assign Work',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                backgroundColor: AppColors.primary,
              ),
        drawer: isWeb ? null : _buildDrawer(context),
        body: Row(
          children: [
            if (isWeb)
              Container(
                width: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(2, 0),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: _buildDrawer(context, isWeb: true),
              ),
            Expanded(child: _buildForm()),
          ],
        ),
      );
    });
  }
}

// ------------------ Assigned Work Model ------------------
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

// ------------------ Assigned Work List ------------------
class HrAssignedWorkListScreen extends StatefulWidget {
  const HrAssignedWorkListScreen({super.key});

  @override
  State<HrAssignedWorkListScreen> createState() =>
      _HrAssignedWorkListScreenState();
}

class _HrAssignedWorkListScreenState extends State<HrAssignedWorkListScreen> {
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

  bool isExpired(AssignedWork work) {
    return work.endDate.isBefore(DateTime.now());
  }

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

  Widget _buildWorkList() {
    return assignedWorks.isEmpty
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
                      Text("Start: ${DateFormat('yyyy-MM-dd').format(work.startDate)}"),
                      Text("End: ${DateFormat('yyyy-MM-dd').format(work.endDate)}"),
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
  }

  Drawer _buildDrawer(BuildContext context, {bool isWeb = false}) {
    return Drawer(
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (!isWeb)
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(radius: 30, backgroundImage: AssetImage("assets/client.png")),
                  SizedBox(height: 10),
                  Text("Admin Panel", style: TextStyle(color: Colors.black, fontSize: 18)),
                  Text("Mobile No: 9090909090", style: TextStyle(color: Colors.black, fontSize: 14)),
                ],
              ),
            ),
           _drawerItem(context, Icons.dashboard, "Dashboard", const AdminDashboardPage(), isWeb),
          _drawerItem(context, Icons.pie_chart, "Chart", const AdminStats(), isWeb),
          _drawerItem(context, Icons.assignment, "Assign Work", const HrAssignedWorkListScreen(), isWeb),
          _drawerItem(context, Icons.report, "Job Status",  JobStatusScreen(), isWeb),
          _drawerItem(context, Icons.person_4_outlined, "Manage Users", const AdminUser(), isWeb),
          _drawerItem(context, Icons.person_search, "Manage KYC", const ManageKyc(), isWeb),
          // _drawerItem(
          //   context,
          //   Icons.report,
          //   "Reports",
          //   AdminReportsPage(projects: dummyProjects),
          //   isWeb,
          // ),
          _drawerItem(context, Icons.contact_page, "Contact Us", const AdminContactUsPage(), isWeb),
          _drawerItem(context, Icons.notifications, "View Notifications", const AdminViewNotificationScreen(), isWeb),
          _drawerItem(context, Icons.logout, "Log out", const LoginScreen(), isWeb),
        ],
      ),
    );
  }

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
           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => page),(route) => false);
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isWeb = constraints.maxWidth > 900;

      return Scaffold(
        appBar: isWeb
            ? null
            : AppBar(
                title: const Text("Assigned Works",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                backgroundColor: AppColors.primary,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HrWorkAssignScreen()));
                    },
                    child: const Text("Add Work", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
        drawer: isWeb ? null : _buildDrawer(context),
        body: Row(
          children: [
            if (isWeb)
              Container(
                width: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(2, 0),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: _buildDrawer(context, isWeb: true),
              ),
            Expanded(child: _buildWorkList()),
          ],
        ),
        floatingActionButton: isWeb
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HrWorkAssignScreen()));
                },
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add),
              )
            : null,
      );
    });
  }
}