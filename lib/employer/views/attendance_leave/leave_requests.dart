import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';
import 'package:url_launcher/url_launcher.dart';

class LeaveRequestsPage extends StatefulWidget {
  const LeaveRequestsPage({super.key});

  @override
  State<LeaveRequestsPage> createState() => _LeaveRequestsPageState();
}

class _LeaveRequestsPageState extends State<LeaveRequestsPage> {
  static const String apiUrl =
      "https://dialfirst.in/quantapixel/badhyata/api/employerLeaves";

  bool _loading = false;
  String? _error;
  List<dynamic> leaveList = [];

  @override
  void initState() {
    super.initState();
    fetchLeaves();
  }

  Future<void> fetchLeaves() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"employer_id": 14}), // 🔥 Auto employer id for now
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final jsonBody = json.decode(res.body);

        if (jsonBody["success"] == true) {
          setState(() {
            leaveList = jsonBody["data"] ?? [];
          });
        } else {
          setState(() => _error = jsonBody["message"]);
        }
      } else {
        setState(() => _error = "Server Error (${res.statusCode})");
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  // Open attachment link
  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // Status badge
  Widget statusBadge(int status) {
    Color c;
    String t;

    switch (status) {
      case 1:
        c = Colors.green;
        t = "Approved";
        break;
      case 3:
        c = Colors.red;
        t = "Rejected";
        break;
      default:
        c = Colors.orange;
        t = "Pending";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        t,
        style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: !isWeb,
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "Leave Requests",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: AppColors.primary,
              actions: [
                IconButton(
                  onPressed: fetchLeaves,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
            drawer: EmployerSidebar(),
            body: Container(
              color: Colors.grey.shade100,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red.shade400,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: fetchLeaves,
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  : leaveList.isEmpty
                  ? const Center(
                      child: Text(
                        "No leave requests found.",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: leaveList.length,
                      itemBuilder: (context, index) {
                        final item = leaveList[index];
                        final leave = item["leave"];
                        final emp = item["employee"];
                        final job = item["job"];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.1),
                                    child: const Icon(
                                      Icons.person,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          emp["name"] ?? "Unknown",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${job["job_title"]}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          emp["mobile"] ?? "",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  statusBadge(leave["approval"]),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // Leave Dates
                              Text(
                                "${leave["start_date"]} → ${leave["end_date"]}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Reason
                              Text(
                                leave["reason"],
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Attachment button
                              // Attachment button
                              if (leave["attachment"] != null)
                                TextButton.icon(
                                  onPressed: () =>
                                      _openUrl(leave["attachment"]),
                                  icon: const Icon(
                                    Icons.picture_as_pdf,
                                    size: 18,
                                  ),
                                  label: const Text("View Attachment"),
                                ),

                              // Accept / Reject buttons (only for pending)
                              if (leave["approval"] == 2) ...[
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Accept",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Reject",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
