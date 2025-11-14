import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

class OneTimeApplicantsPage extends StatefulWidget {
  final int jobId;
  final String? jobTitle; // optional, for AppBar subtitle

  const OneTimeApplicantsPage({
    super.key,
    required this.jobId,
    this.jobTitle,
  });

  @override
  State<OneTimeApplicantsPage> createState() => _OneTimeApplicantsPageState();
}

class _OneTimeApplicantsPageState extends State<OneTimeApplicantsPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _applicants = [];

  // 👉 Update to your actual endpoint for {{bhadyata}}oneTimeApplicantsByJob
  final String apiUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/oneTimeApplicantsByJob';

  @override
  void initState() {
    super.initState();
    _fetchApplicants();
  }

  Future<void> _fetchApplicants() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"job_id": widget.jobId}),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final List data = (json['data'] as List?) ?? [];
        setState(() => _applicants = data.cast<Map<String, dynamic>>());
      } else {
        setState(() => _error = "Error ${res.statusCode}");
      }
    } catch (e) {
      setState(() => _error = "Network error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _safe(dynamic v) {
    if (v == null) return '—';
    final s = v.toString().trim();
    return s.isEmpty ? '—' : s;
  }

  String _formatDateTime(dynamic raw) {
    if (raw == null) return '—';
    try {
      final dt = DateTime.parse(raw.toString());
      final d = dt.day.toString().padLeft(2, '0');
      final m = const [
        'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
      ][dt.month - 1];
      final y = dt.year.toString();
      final hh = dt.hour.toString().padLeft(2, '0');
      final mm = dt.minute.toString().padLeft(2, '0');
      return "$d $m $y, $hh:$mm";
    } catch (_) {
      return raw.toString();
    }
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'selected':
        return Colors.green;
      case 'shortlisted':
      case 'interview_scheduled':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget _pill(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      );

  Widget _hrApprovalPill(dynamic v) {
    final a = int.tryParse(_safe(v)) ?? 2;
    if (a == 1) return _pill('HR: Approved', Colors.green);
    if (a == 3) return _pill('HR: Rejected', Colors.red);
    return _pill('HR: Pending', Colors.orange);
    }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isWeb = constraints.maxWidth >= 900;

      return HrDashboardWrapper(
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            automaticallyImplyLeading: !isWeb,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primary,
            title: const Text(
              "Applicants",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            bottom: widget.jobTitle == null
                ? null
                : PreferredSize(
                    preferredSize: const Size.fromHeight(28),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.jobTitle!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
            elevation: 2,
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_error!, style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 8),
                          OutlinedButton(onPressed: _fetchApplicants, child: const Text('Retry')),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchApplicants,
                      child: _applicants.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                const SizedBox(height: 120),
                                Center(
                                  child: Text(
                                    'No applicants',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _applicants.length,
                              itemBuilder: (context, i) {
                                final a = _applicants[i];

                                final firstName = _safe(a['first_name']);
                                final lastName = _safe(a['last_name']);
                                final name = [firstName, lastName]
                                    .where((e) => e != '—' && e.isNotEmpty)
                                    .join(' ');
                                final email = _safe(a['email']);
                                final mobile = _safe(a['mobile']);
                                final appDate = _formatDateTime(a['application_date']);
                                final status = _safe(a['status']);
                                final statusClr = _statusColor(status);
                                final profileImg = _safe(a['profile_image']);
                                final hasImg = profileImg != '—' && profileImg.startsWith('http');

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: CircleAvatar(
                                      backgroundColor: AppColors.primary.withOpacity(0.12),
                                      foregroundImage: hasImg ? NetworkImage(profileImg) : null,
                                      child: Icon(Icons.person, color: AppColors.primary),
                                    ),
                                    title: Text(
                                      name.isEmpty ? '—' : name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        if (mobile != '—') Text("Mobile: $mobile"),
                                        if (email != '—') Text("Email: $email"),
                                        Text("Applied: $appDate"),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: [
                                            _pill('Status: $status', statusClr),
                                            _hrApprovalPill(a['hr_approval']),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      tooltip: 'Action (placeholder)',
                                      icon: const Icon(Icons.more_horiz, color: Colors.black87),
                                      onPressed: () {
                                        // TODO: replace with your action (e.g., update status / open profile)
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            content: Text('Placeholder action for this applicant'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
        ),
      );
    });
  }
}
