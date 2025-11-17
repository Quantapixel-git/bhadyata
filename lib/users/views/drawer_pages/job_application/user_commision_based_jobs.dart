import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';

/// ----------------------------------------------------
/// MODEL
/// ----------------------------------------------------
class CommissionJobApplication {
  final int jobId;
  final String title;
  final String category;
  final String commissionRate;
  final String commissionType;
  final int targetLeads;
  final String potentialEarning;
  final String leadType;
  final String industry;
  final String workMode;
  final String location;

  final int applicantId;
  final String applicationDate;
  final String applicantStatus;
  final int hrApproval;
  final String remarks;

  CommissionJobApplication({
    required this.jobId,
    required this.title,
    required this.category,
    required this.commissionRate,
    required this.commissionType,
    required this.targetLeads,
    required this.potentialEarning,
    required this.leadType,
    required this.industry,
    required this.workMode,
    required this.location,
    required this.applicantId,
    required this.applicationDate,
    required this.applicantStatus,
    required this.hrApproval,
    required this.remarks,
  });

  factory CommissionJobApplication.fromJson(Map<String, dynamic> json) {
    return CommissionJobApplication(
      jobId: json["job_id"] ?? 0,
      title: json["title"] ?? "",
      category: json["category"] ?? "",
      commissionRate: json["commission_rate"]?.toString() ?? "0",
      commissionType: json["commission_type"] ?? "",
      targetLeads: json["target_leads"] ?? 0,
      potentialEarning: json["potential_earning"]?.toString() ?? "0",
      leadType: json["lead_type"] ?? "",
      industry: json["industry"] ?? "",
      workMode: json["work_mode"] ?? "",
      location: json["location"] ?? "",
      applicantId: json["applicant_id"] ?? 0,
      applicationDate: json["application_date"] ?? "",
      applicantStatus: json["applicant_status"] ?? "",
      hrApproval: json["hr_approval"] ?? 2,
      remarks: json["remarks"] ?? "",
    );
  }
}

/// ----------------------------------------------------
/// API SERVICE
/// ----------------------------------------------------
class CommissionJobsApi {
  static Future<List<CommissionJobApplication>>
  fetchAppliedCommissionJobs() async {
    try {
      final userId = await SessionManager.getValue('user_id');
      if (userId == null) return [];

      final url = Uri.parse(
        "${ApiConstants.baseUrl}commissionJobsAppliedByUser",
      );

      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": int.parse(userId)}),
      );

      final body = jsonDecode(resp.body);

      if (resp.statusCode == 200 && body["success"] == true) {
        final List data = body["data"] ?? [];
        return data.map((e) => CommissionJobApplication.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      debugPrint("Commission Jobs API Error: $e");
      return [];
    }
  }
}

/// ----------------------------------------------------
/// COMMISSION JOBS APPLIED SCREEN
/// ----------------------------------------------------
class CommissionJobsScreen extends StatefulWidget {
  const CommissionJobsScreen({super.key});

  @override
  State<CommissionJobsScreen> createState() => _CommissionJobsScreenState();
}

class _CommissionJobsScreenState extends State<CommissionJobsScreen> {
  late Future<List<CommissionJobApplication>> _future;

  @override
  void initState() {
    super.initState();
    _future = CommissionJobsApi.fetchAppliedCommissionJobs();
  }

  String _formatDate(String dt) {
    try {
      return DateFormat("dd MMM yyyy").format(DateTime.parse(dt));
    } catch (_) {
      return dt;
    }
  }

  Color _statusBg(String s) {
    switch (s) {
      case "selected":
        return Colors.green.shade100;
      case "rejected":
        return Colors.red.shade100;
      case "shortlisted":
        return Colors.blue.shade100;
      default:
        return Colors.orange.shade100;
    }
  }

  Color _statusText(String s) {
    switch (s) {
      case "selected":
        return Colors.green.shade800;
      case "rejected":
        return Colors.red.shade800;
      case "shortlisted":
        return Colors.blue.shade800;
      default:
        return Colors.orange.shade800;
    }
  }

  Widget _buildCard(CommissionJobApplication j) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: const Icon(Icons.trending_up, color: AppColors.primary),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  j.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  j.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        j.location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text(
                  "Commission: ${j.commissionRate}${j.commissionType == "Percentage" ? "%" : ""} (${j.commissionType})",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  "Target Leads: ${j.targetLeads}",
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  "Potential Earning: ₹${j.potentialEarning}",
                  style: const TextStyle(color: Colors.black87),
                ),

                const SizedBox(height: 6),
                Text(
                  "Applied on ${_formatDate(j.applicationDate)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),

                if (j.remarks.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    "Remarks: ${j.remarks}",
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ],
            ),
          ),

          Column(
            children: [
              Chip(
                backgroundColor: _statusBg(j.applicantStatus),
                label: Text(
                  j.applicantStatus.toUpperCase(),
                  style: TextStyle(
                    color: _statusText(j.applicantStatus),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_down_outlined,
            size: 90,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 18),
          const Text(
            "No Applications Yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "You haven't applied to any commission-based jobs.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() => _future = CommissionJobsApi.fetchAppliedCommissionJobs());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return AppDrawerWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          title: const Text(
            "My Commission Jobs",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
          ],
        ),

        body: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<CommissionJobApplication>>(
            future: _future,
            builder: (ctx, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final items = snap.data ?? [];
              if (items.isEmpty) return _emptyState();

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (c, i) => _buildCard(items[i]),
              );
            },
          ),
        ),
      ),
    );
  }
}
