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
class SalaryJobApplication {
  final int jobId;
  final String title;
  final String category;
  final String jobType;
  final String experience;
  final String qualification;
  final String location;
  final String salaryMin;
  final String salaryMax;
  final String salaryType;
  final int employerId;
  final String jobStatus;
  final int applicantId;
  final String applicationDate;
  final String applicantStatus;
  final int hrApproval;
  final String remarks;

  SalaryJobApplication({
    required this.jobId,
    required this.title,
    required this.category,
    required this.jobType,
    required this.experience,
    required this.qualification,
    required this.location,
    required this.salaryMin,
    required this.salaryMax,
    required this.salaryType,
    required this.employerId,
    required this.jobStatus,
    required this.applicantId,
    required this.applicationDate,
    required this.applicantStatus,
    required this.hrApproval,
    required this.remarks,
  });

  factory SalaryJobApplication.fromJson(Map<String, dynamic> json) {
    return SalaryJobApplication(
      jobId: json["job_id"] ?? 0,
      title: json["title"] ?? "",
      category: json["category"] ?? "",
      jobType: json["job_type"] ?? "",
      experience: json["experience_required"] ?? "",
      qualification: json["qualification"] ?? "",
      location: json["location"] ?? "",
      salaryMin: json["salary_min"]?.toString() ?? "0",
      salaryMax: json["salary_max"]?.toString() ?? "0",
      salaryType: json["salary_type"] ?? "",
      employerId: json["employer_id"] ?? 0,
      jobStatus: json["job_status"] ?? "",
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
class SalaryJobsApi {
  static Future<List<SalaryJobApplication>> fetchAppliedSalaryJobs() async {
    try {
      final userId = await SessionManager.getValue('user_id');
      if (userId == null) return [];

      final url = Uri.parse("${ApiConstants.baseUrl}salaryJobsAppliedByUser");

      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": int.parse(userId)}),
      );

      final body = jsonDecode(resp.body);
      if (resp.statusCode == 200 && body["success"] == true) {
        final List data = body["data"] ?? [];
        return data.map((e) => SalaryJobApplication.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      debugPrint("Salary API Error: $e");
      return [];
    }
  }
}

/// ----------------------------------------------------
/// SALARY JOBS APPLIED SCREEN
/// ----------------------------------------------------
class SalaryJobsScreen extends StatefulWidget {
  const SalaryJobsScreen({super.key});

  @override
  State<SalaryJobsScreen> createState() => _SalaryJobsScreenState();
}

class _SalaryJobsScreenState extends State<SalaryJobsScreen> {
  late Future<List<SalaryJobApplication>> _future;

  @override
  void initState() {
    super.initState();
    _future = SalaryJobsApi.fetchAppliedSalaryJobs();
  }

  String _formatDate(String dt) {
    try {
      return DateFormat("dd MMM yyyy").format(DateTime.parse(dt));
    } catch (_) {
      return dt;
    }
  }

  Color _statusBg(String status) {
    switch (status) {
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

  Color _statusTextColor(String status) {
    switch (status) {
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

  Widget _buildCard(SalaryJobApplication j) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      width: double.infinity,
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
            child: const Icon(Icons.work_outline, color: AppColors.primary),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  j.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
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
                  "₹${j.salaryMin} - ₹${j.salaryMax} (${j.salaryType})",
                  style: const TextStyle(fontWeight: FontWeight.w600),
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
                    color: _statusTextColor(j.applicantStatus),
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
            Icons.folder_off_outlined,
            size: 90,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 18),
          const Text(
            "No Job Applications Yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "You haven't applied to any salary-based jobs.\nStart applying now!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() => _future = SalaryJobsApi.fetchAppliedSalaryJobs());
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
            "My Salary Jobs",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _refresh,
            ),
          ],
        ),

        body: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<SalaryJobApplication>>(
            future: _future,
            builder: (context, snap) {
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
                itemBuilder: (context, i) => _buildCard(items[i]),
              );
            },
          ),
        ),
      ),
    );
  }
}
