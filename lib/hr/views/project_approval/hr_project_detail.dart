import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailPage extends StatelessWidget {
  final Map<String, dynamic> project;
  const ProjectDetailPage({super.key, required this.project});

  String _safe(dynamic v) {
    if (v == null) return '—';
    final s = v.toString().trim();
    return s.isEmpty ? '—' : s;
  }

  String _approvalText(dynamic v) {
    final a = int.tryParse(v?.toString() ?? '');
    if (a == 1) return 'Approved';
    if (a == 3) return 'Rejected';
    return 'Pending';
  }

  Color _approvalColor(dynamic v) {
    final a = int.tryParse(v?.toString() ?? '');
    if (a == 1) return Colors.green;
    if (a == 3) return Colors.red;
    return Colors.orange;
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(k,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black87)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    if (url.trim().isEmpty) return;
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final skills = _safe(project['skills_required']);
    final skillsList = skills == '—'
        ? <String>[]
        : skills.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    final approvalClr = _approvalColor(project['approval']);
    final approvalTxt = _approvalText(project['approval']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Project Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;
          final content = SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.12),
                          child: Icon(Icons.work, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _safe(project['title']),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  Chip(label: Text('Category: ${_safe(project['category'])}')),
                                  Chip(
                                    label: Text(approvalTxt),
                                    backgroundColor: approvalClr.withOpacity(.12),
                                    side: BorderSide(color: approvalClr.withOpacity(.35)),
                                    labelStyle: TextStyle(color: approvalClr, fontWeight: FontWeight.w700),
                                  ),
                                  Chip(label: Text('Status: ${_safe(project['status'])}')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 32),

                    // Core info
                    _row('ID', _safe(project['id'])),
                    _row('Employer ID', _safe(project['employer_id'])),
                    _row('Description', _safe(project['description'])),
                    _row('Experience Level', _safe(project['experience_level'])),
                    _row('Duration', _safe(project['duration'])),
                    _row('Location', _safe(project['location'])),

                    // Budget block
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Budget', style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          _row('Type', _safe(project['budget_type'])),
                          _row('Min', _safe(project['budget_min'])),
                          _row('Max', _safe(project['budget_max'])),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Deliverables & preferences
                    _row('Deliverables', _safe(project['deliverables'])),
                    _row('Preferred Freelancer', _safe(project['preferred_freelancer_type'])),
                    _row('Openings', _safe(project['openings'])),

                    // Deadlines & timestamps
                    _row('Application Deadline', _safe(project['application_deadline'])),
                    _row('Created At', _safe(project['created_at'])),
                    _row('Updated At', _safe(project['updated_at'])),

                    const SizedBox(height: 12),

                    // Skills
                    if (skillsList.isNotEmpty) ...[
                      const Text('Skills Required',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: skillsList.map((s) => Chip(label: Text(s))).toList(),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Contact actions
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          onPressed: () {
                            final email = _safe(project['contact_email']);
                            if (email == '—') return;
                            _openUrl('mailto:$email');
                          },
                          icon: const Icon(Icons.email, color: Colors.white),
                          label: const Text('Email', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            final phone = _safe(project['contact_phone']);
                            if (phone == '—') return;
                            _openUrl('tel:$phone');
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );

          // Full width on desktop; centered 800px on small screens for readability
          return isDesktop
              ? content
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: content,
                  ),
                );
        },
      ),
    );
  }
}
