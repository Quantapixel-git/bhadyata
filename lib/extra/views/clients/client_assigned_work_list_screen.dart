
// ------------------ Assigned Work List ------------------
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobshub/admin/admin_report_page.dart';
import 'package:jobshub/extra/views/clients/client_assign_work.dart';
import 'package:jobshub/extra/views/clients/client_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart' show AppColors;

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
class ClientAssignedWorkListScreen extends StatefulWidget {
  const ClientAssignedWorkListScreen({super.key});

  @override
  State<ClientAssignedWorkListScreen> createState() =>
      _ClientAssignedWorkListScreenState();
}

class _ClientAssignedWorkListScreenState extends State<ClientAssignedWorkListScreen> {
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
  return Scaffold(
    backgroundColor: const Color(0xFFF8FAFC), // soft grey bg
    body: Row(
      children: [
        // Sidebar
        ClientSidebar(projects: []),

        // Main content area
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------- Top App Bar -----------
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Assigned Works",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ClientAssignWorkScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Add Work",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // ----------- Content Area -----------
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: assignedWorks.isEmpty
                      ? const Center(
                          child: Text(
                            "No work assigned yet",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount =
                                (constraints.maxWidth ~/ 350).clamp(1, 4);
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 1.3,
                              ),
                              itemCount: assignedWorks.length,
                              itemBuilder: (context, index) {
                                final work = assignedWorks[index];
                                final expired = isExpired(work);

                                return MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                work.jobTitle,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color: expired
                                                    ? Colors.red.shade100
                                                    : Colors.green.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                expired ? "Expired" : "Active",
                                                style: TextStyle(
                                                  color: expired
                                                      ? Colors.red.shade800
                                                      : Colors.green.shade800,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          "Candidate: ${work.candidate}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          "Start: ${DateFormat('yyyy-MM-dd').format(work.startDate)}",
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "End: ${DateFormat('yyyy-MM-dd').format(work.endDate)}",
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Payment: ₹${work.payment.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (expired)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () =>
                                                      extendJob(work),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green.shade600,
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 10),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child:
                                                      const Text("Extend Job"),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () =>
                                                      terminateJob(work),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.red.shade600,
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 10),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child:
                                                      const Text("Terminate"),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
 else {
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
