import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobshub/common/utils/app_color.dart';
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

  String _formatDate(dynamic raw) {
    if (raw == null) return '—';
    try {
      // Accept various formats — if parse fails, return raw string
      final dt = DateTime.parse(raw.toString()).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      final s = raw.toString();
      return s.isEmpty ? '—' : s;
    }
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.16)),
      ),
      child: Text(label, style: TextStyle(color: AppColors.primary)),
    );
  }

  Widget _rowLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(color: Colors.black87)),
          ),
          Expanded(flex: 5, child: Text(value.isNotEmpty ? value : '—')),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    if (url.trim().isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final skills = _safe(project['skills_required']);
    final skillsList = skills == '—'
        ? <String>[]
        : skills
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

    final approvalClr = _approvalColor(project['approval']);
    final approvalTxt = _approvalText(project['approval']);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
        title: const Text(
          'Project Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // stateless page — if you later want to re-fetch use a stateful approach
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;
          final content = SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _safe(project['title']),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if ((_safe(project['category'])) != '—')
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(_safe(project['category'])),
                              ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: approvalClr.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                approvalTxt,
                                style: TextStyle(
                                  color: approvalClr,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Budget & basics card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.monetization_on_outlined,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Budget: ₹${_safe(project['budget_min'])} - ₹${_safe(project['budget_max'])}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            if ((_safe(project['openings'])) != '—')
                              Text('${_safe(project['openings'])} openings'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _rowLabelValue('Duration', _safe(project['duration'])),
                        _rowLabelValue(
                          'Experience',
                          _safe(project['experience_level']),
                        ),
                        _rowLabelValue('Location', _safe(project['location'])),
                        _rowLabelValue(
                          'Application deadline',
                          _safe(project['application_deadline']),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Skills chips
                if (skillsList.isNotEmpty) ...[
                  const Text(
                    'Skills',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Wrap(children: skillsList.map((s) => _chip(s)).toList()),
                  const SizedBox(height: 12),
                ],

                // Description
                if ((_safe(project['description'])) != '—') ...[
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(_safe(project['description'])),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Requirements
                if ((_safe(project['requirements'])) != '—') ...[
                  const Text(
                    'Requirements',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(_safe(project['requirements'])),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Perks / Benefits
                if ((_safe(project['perks'])) != '—') ...[
                  const Text(
                    'Perks',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(_safe(project['perks'])),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Contact card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        if ((_safe(project['contact_email'])) != '—')
                          _rowLabelValue(
                            'Email',
                            _safe(project['contact_email']),
                          ),
                        if ((_safe(project['contact_phone'])) != '—')
                          _rowLabelValue(
                            'Phone',
                            _safe(project['contact_phone']),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if ((_safe(project['contact_email'])) != '—')
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                ),
                                onPressed: () => _openUrl(
                                  'mailto:${_safe(project['contact_email'])}',
                                ),
                                icon: const Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Email',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            const SizedBox(width: 10),
                            if ((_safe(project['contact_phone'])) != '—')
                              OutlinedButton.icon(
                                onPressed: () => _openUrl(
                                  'tel:${_safe(project['contact_phone'])}',
                                ),
                                icon: const Icon(Icons.phone),
                                label: const Text('Call'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Meta card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _rowLabelValue('Status', _safe(project['status'])),
                        const SizedBox(height: 6),
                        _rowLabelValue(
                          'Created',
                          _formatDate(project['created_at']),
                        ),
                        const SizedBox(height: 6),
                        // _rowLabelValue(
                        //   'Updated',
                        //   _formatDate(project['updated_at']),
                        // ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),
              ],
            ),
          );

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
