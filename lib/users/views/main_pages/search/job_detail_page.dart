
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobshub/common/utils/app_color.dart';

/// Job detail page (keeps previous improved layout)
class JobDetailPage extends StatelessWidget {
  final Map<String, String> job;
  const JobDetailPage({super.key, required this.job});

  String _formatFullDate(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      final dt = DateTime.parse(d);
      return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(dt);
    } catch (_) {
      return d;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = job['title'] ?? 'Job';
    final location = job['location'] ?? 'Location unavailable';
    final salaryMin = job['salary_min'] ?? '';
    final salaryMax = job['salary_max'] ?? '';
    final salaryType = job['salary_type'] ?? '';
    final salaryText = (salaryMin.isNotEmpty || salaryMax.isNotEmpty)
        ? (salaryMin == salaryMax
              ? '₹$salaryMin / $salaryType'
              : '₹$salaryMin - ₹$salaryMax / $salaryType')
        : 'Not specified';
    final jobType = job['job_type'] ?? '';
    final experience = job['experience_required'] ?? '';
    final qualification = job['qualification'] ?? '';
    final skills = (job['skills'] ?? '')
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final deadline = job['application_deadline'];
    final description = job['job_description'] ?? '-';
    final responsibilities = job['responsibilities'] ?? '-';
    final benefits = job['benefits'] ?? '-';
    final contactEmail = job['contact_email'] ?? '';
    final contactPhone = job['contact_phone'] ?? '';

    final bool isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        centerTitle: false,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isWide ? 1100 : double.infinity,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // header card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.work_outline,
                            color: AppColors.primary,
                            size: 36,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    location,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  if (jobType.isNotEmpty) ...[
                                    Icon(
                                      Icons.work_outline,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      jobType,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              salaryText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Experience: $experience',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // sections
                _sectionCard(
                  title: 'Job Description',
                  child: Text(description, style: const TextStyle(height: 1.6)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _sectionCard(
                        title: 'Responsibilities',
                        child: Text(responsibilities),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _sectionCard(
                        title: 'Benefits',
                        child: Text(benefits),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _sectionCard(
                  title: 'Skills & Qualification',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (qualification.isNotEmpty)
                        Text('Qualification: $qualification'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: skills
                            .map((s) => Chip(label: Text(s)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _sectionCard(
                  title: 'Meta',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Application deadline: ${deadline != null ? _formatFullDate(deadline) : 'Not specified'}',
                      ),
                      const SizedBox(height: 6),
                      if (contactEmail.isNotEmpty)
                        Text('Contact: $contactEmail'),
                      if (contactPhone.isNotEmpty) Text('Phone: $contactPhone'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Apply (demo)')),
                            ),
                        icon: const Icon(Icons.send),
                        label: const Text('Apply Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved (demo)')),
                          ),
                      icon: const Icon(Icons.bookmark_border),
                      label: const Text('Save'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
