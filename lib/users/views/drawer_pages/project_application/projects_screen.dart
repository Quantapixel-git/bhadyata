import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';

/// ------------------ Model ------------------
class UserProjectApplication {
  final int projectId;
  final String title;
  final String category;
  final String location;
  final String budgetMin;
  final String budgetMax;
  final String budgetType;
  final int employerId;
  final String projectStatus;
  final int applicantId;
  final String applicationDate;
  final String applicantStatus;
  final int hrApproval;
  final String remarks;

  UserProjectApplication({
    required this.projectId,
    required this.title,
    required this.category,
    required this.location,
    required this.budgetMin,
    required this.budgetMax,
    required this.budgetType,
    required this.employerId,
    required this.projectStatus,
    required this.applicantId,
    required this.applicationDate,
    required this.applicantStatus,
    required this.hrApproval,
    required this.remarks,
  });

  factory UserProjectApplication.fromJson(Map<String, dynamic> json) {
    return UserProjectApplication(
      projectId: json['project_id'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      location: json['location'] ?? 'N/A',
      budgetMin: json['budget_min']?.toString() ?? '0',
      budgetMax: json['budget_max']?.toString() ?? '0',
      budgetType: json['budget_type'] ?? 'Fixed',
      employerId: json['employer_id'] ?? 0,
      projectStatus: json['project_status'] ?? '',
      applicantId: json['applicant_id'] ?? 0,
      applicationDate: json['application_date'] ?? '',
      applicantStatus: json['applicant_status'] ?? '',
      hrApproval: json['hr_approval'] ?? 2,
      remarks: json['remarks'] ?? '',
    );
  }
}

/// ------------------ Service ------------------
class _ProjectApi {
  static Future<List<UserProjectApplication>> fetchUserAppliedProjects() async {
    try {
      final userId = await SessionManager.getValue('user_id');
      if (userId == null || userId.isEmpty) return [];

      final url = Uri.parse("${ApiConstants.baseUrl}projectsAppliedByUser");

      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": int.parse(userId)}),
      );

      final body = jsonDecode(resp.body);

      if (resp.statusCode == 200 && body['success'] == true) {
        final List data = body['data'] ?? [];
        return data.map((e) => UserProjectApplication.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }
}

/// ------------------ UI Screen ------------------
class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  late Future<List<UserProjectApplication>> _future;

  @override
  void initState() {
    super.initState();
    _future = _ProjectApi.fetchUserAppliedProjects();
  }

  Color _statusBg(String appStatus) {
    switch (appStatus) {
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

  Color _statusTextColor(String appStatus) {
    switch (appStatus) {
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

  String _formatDate(String date) {
    try {
      return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }

  Widget _buildCard(UserProjectApplication p) {
    final priceText = (p.budgetType.toLowerCase() == 'fixed')
        ? "₹${p.budgetMin} - ₹${p.budgetMax} (Fixed)"
        : "₹${p.budgetMin} - ₹${p.budgetMax} / month";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      width: double.infinity, // <-- FULL WIDTH
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: const Icon(Icons.work_outline, color: AppColors.primary),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  p.category,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        p.location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text(
                  priceText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 6),
                Text(
                  "Applied on ${_formatDate(p.applicationDate)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),

                if (p.remarks.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    "Remarks: ${p.remarks}",
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ],
            ),
          ),

          Column(
            children: [
              Chip(
                backgroundColor: _statusBg(p.applicantStatus),
                label: Text(
                  p.applicantStatus.toUpperCase(),
                  style: TextStyle(
                    color: _statusTextColor(p.applicantStatus),
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
            "No Applications Yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "You haven't applied for any projects.\nStart exploring opportunities!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() => _future = _ProjectApi.fetchUserAppliedProjects());
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
          elevation: 1,
          title: const Text(
            "My Projects",
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
          child: FutureBuilder<List<UserProjectApplication>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final items = snap.data ?? [];
              if (items.isEmpty) return _emptyState();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, idx) => _buildCard(items[idx]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
