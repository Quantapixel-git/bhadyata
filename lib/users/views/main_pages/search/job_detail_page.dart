import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:jobshub/common/utils/app_color.dart';

class JobDetailPage extends StatelessWidget {
  final Map<String, String> job;
  const JobDetailPage({super.key, required this.job});

  String _formatFullDate(String? d) {
    if (d == null || d.isEmpty) return 'Not specified';
    try {
      final dt = DateTime.parse(d);
      return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(dt);
    } catch (_) {
      try {
        final dt = DateFormat('yyyy-MM-dd').parse(d);
        return DateFormat('EEE, dd MMM yyyy').format(dt);
      } catch (__) {
        return d;
      }
    }
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

  List<Widget> _buildSkillChips(List<String> skills) {
    return skills
        .map(
          (s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(s, style: const TextStyle(fontSize: 12)),
          ),
        )
        .toList();
  }

  Widget _metaRow(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext ctx, String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(
      ctx,
    ).showSnackBar(SnackBar(content: Text('$label copied to clipboard')));
  }

  void _fakeApply(BuildContext ctx, String title) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('Apply clicked — implement real flow for "$title"'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = job['title'] ?? 'Untitled';
    final location = job['location'] ?? '';
    final salaryMin = job['salary_min'] ?? '';
    final salaryMax = job['salary_max'] ?? '';
    final salaryType = job['salary_type'] ?? '';
    final salaryText = (salaryMin.isNotEmpty || salaryMax.isNotEmpty)
        ? (salaryMin == salaryMax
              ? '₹$salaryMin / $salaryType'
              : '₹$salaryMin - ₹$salaryMax / $salaryType')
        : (job['payment_amount'] != null &&
                  (job['payment_amount'] ?? '').isNotEmpty
              ? '₹${job['payment_amount']}'
              : (job['budget_min'] != null &&
                        (job['budget_min'] ?? '').isNotEmpty
                    ? 'Budget: ₹${job['budget_min']}'
                    : 'Not specified'));

    final jobType =
        job['job_type'] ?? job['payment_type'] ?? job['commission_type'] ?? '';
    final experience =
        job['experience_required'] ?? job['experience_level'] ?? '';
    final qualification = job['qualification'] ?? '';
    final skillsRaw = job['skills'] ?? job['skills_required'] ?? '';
    final skills = skillsRaw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final deadline = job['application_deadline'] ?? job['deadline'] ?? '';
    final created = job['created_at'] ?? '';
    final description = job['job_description'] ?? job['description'] ?? '-';

    final isSalary =
        job.containsKey('salary_min') ||
        job.containsKey('salary_max') ||
        job.containsKey('salary_type');
    final isOneTime =
        job.containsKey('job_date') ||
        job.containsKey('payment_amount') ||
        (job['payment_type'] ?? '').toLowerCase().contains('one');
    final isCommission =
        job.containsKey('commission_rate') ||
        job.containsKey('target_leads') ||
        job.containsKey('lead_type');
    final isProject =
        job.containsKey('budget_min') ||
        job.containsKey('budget_max') ||
        job.containsKey('deliverables');

    final responsibilities =
        job['responsibilities'] ?? job['requirements'] ?? '-';
    final benefits = job['benefits'] ?? job['perks'] ?? '-';
    final contactEmail = job['contact_email'] ?? '';
    final contactPhone = job['contact_phone'] ?? '';

    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1000;
    final bool isWide = width >= 1000;

    // Constrain max content width for readability on very large screens
    final double maxContentWidth = isWide ? 1100 : 900;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Colors.grey.shade100,
      // On mobile show a bottom action bar with primary actions for easier access
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header card - horizontal on wide, stacked on mobile
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (isMobile || constraints.maxWidth < 600) {
                          // stacked header for narrow widths
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(
                                        0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.work_outline,
                                      color: AppColors.primary,
                                      size: 36,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: [
                                            if (location.isNotEmpty)
                                              _smallChip(
                                                Icons.location_on,
                                                location,
                                              ),
                                            if (jobType.isNotEmpty)
                                              _smallChip(
                                                Icons.work_outline,
                                                jobType,
                                              ),
                                            if (experience.isNotEmpty)
                                              _smallChip(
                                                Icons.timeline,
                                                experience,
                                              ),
                                            if (skills.isNotEmpty)
                                              _smallChip(
                                                Icons.star_border,
                                                '${skills.length} skills',
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      salaryText,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    deadline.isNotEmpty
                                        ? _formatFullDate(deadline)
                                        : 'Deadline: N/A',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          // wide horizontal header
                          return Row(
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
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 6,
                                      children: [
                                        if (location.isNotEmpty)
                                          _smallChip(
                                            Icons.location_on,
                                            location,
                                          ),
                                        if (jobType.isNotEmpty)
                                          _smallChip(
                                            Icons.work_outline,
                                            jobType,
                                          ),
                                        if (experience.isNotEmpty)
                                          _smallChip(
                                            Icons.timeline,
                                            experience,
                                          ),
                                        if (skills.isNotEmpty)
                                          _smallChip(
                                            Icons.star_border,
                                            '${skills.length} skills',
                                          ),
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
                                  const SizedBox(height: 8),
                                  Text(
                                    'Deadline: ${deadline.isNotEmpty ? _formatFullDate(deadline) : 'Not specified'}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Posted: ${created.isNotEmpty ? _formatFullDate(created) : 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Main content + meta: two-column on tablet/desktop, stacked on mobile
                if (!isMobile)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: main content (flex 2)
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _sectionCard(
                              title: 'About the role',
                              child: Text(
                                description,
                                style: const TextStyle(height: 1.6),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _sectionCard(
                              title: 'Responsibilities / Requirements',
                              child: Text(responsibilities),
                            ),
                            const SizedBox(height: 12),
                            _sectionCard(
                              title: 'Benefits / Perks',
                              child: Text(benefits),
                            ),
                            const SizedBox(height: 12),
                            if (skills.isNotEmpty)
                              _sectionCard(
                                title: 'Skills',
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _buildSkillChips(skills),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Right: meta (flex 3)
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _sectionCard(
                              title: 'Details',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isSalary) ...[
                                    _metaRow(
                                      Icons.monetization_on,
                                      'Salary',
                                      salaryText,
                                    ),
                                    _metaRow(
                                      Icons.account_box,
                                      'Qualification',
                                      qualification,
                                    ),
                                    _metaRow(
                                      Icons.work_outline,
                                      'Job type',
                                      jobType,
                                    ),
                                  ],
                                  if (isOneTime) ...[
                                    _metaRow(
                                      Icons.date_range,
                                      'Job date',
                                      _formatFullDate(job['job_date']),
                                    ),
                                    _metaRow(
                                      Icons.access_time,
                                      'Time',
                                      '${job['start_time'] ?? '-'} - ${job['end_time'] ?? '-'}',
                                    ),
                                    _metaRow(
                                      Icons.timer,
                                      'Duration',
                                      job['duration'] ?? '',
                                    ),
                                    _metaRow(
                                      Icons.payments,
                                      'Payment',
                                      job['payment_amount'] ?? '',
                                    ),
                                  ],
                                  if (isCommission) ...[
                                    _metaRow(
                                      Icons.percent,
                                      'Commission rate',
                                      job['commission_rate'] ?? '',
                                    ),
                                    _metaRow(
                                      Icons.flag,
                                      'Target leads',
                                      job['target_leads'] ?? '',
                                    ),
                                    _metaRow(
                                      Icons.trending_up,
                                      'Potential earning',
                                      job['potential_earning'] ?? '',
                                    ),
                                    _metaRow(
                                      Icons.business,
                                      'Industry',
                                      job['industry'] ?? '',
                                    ),
                                  ],
                                  if (isProject) ...[
                                    _metaRow(
                                      Icons.account_balance_wallet,
                                      'Budget',
                                      '${job['budget_min'] ?? ''} - ${job['budget_max'] ?? ''}',
                                    ),
                                    _metaRow(
                                      Icons.timeline,
                                      'Duration',
                                      job['duration'] ?? '',
                                    ),
                                    _metaRow(
                                      Icons.task,
                                      'Deliverables',
                                      job['deliverables'] ?? '',
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            _sectionCard(
                              title: 'Contact',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (contactEmail.isNotEmpty)
                                    Row(
                                      children: [
                                        Expanded(child: Text(contactEmail)),
                                        IconButton(
                                          tooltip: 'Copy email',
                                          onPressed: () => _copyToClipboard(
                                            context,
                                            'Email',
                                            contactEmail,
                                          ),
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (contactPhone.isNotEmpty)
                                    Row(
                                      children: [
                                        Expanded(child: Text(contactPhone)),
                                        IconButton(
                                          tooltip: 'Copy phone',
                                          onPressed: () => _copyToClipboard(
                                            context,
                                            'Phone',
                                            contactPhone,
                                          ),
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => _fakeApply(context, title),
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Apply Now',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _sectionCard(
                        title: 'About the role',
                        child: Text(
                          description,
                          style: const TextStyle(height: 1.6),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _sectionCard(
                        title: 'Responsibilities / Requirements',
                        child: Text(responsibilities),
                      ),
                      const SizedBox(height: 12),
                      _sectionCard(
                        title: 'Benefits / Perks',
                        child: Text(benefits),
                      ),
                      const SizedBox(height: 12),
                      if (skills.isNotEmpty)
                        _sectionCard(
                          title: 'Skills',
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _buildSkillChips(skills),
                          ),
                        ),
                      const SizedBox(height: 12),
                      _sectionCard(
                        title: 'Details',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isSalary) ...[
                              _metaRow(
                                Icons.monetization_on,
                                'Salary',
                                salaryText,
                              ),
                              _metaRow(
                                Icons.account_box,
                                'Qualification',
                                qualification,
                              ),
                              _metaRow(Icons.work_outline, 'Job type', jobType),
                            ],
                            if (isOneTime) ...[
                              _metaRow(
                                Icons.date_range,
                                'Job date',
                                _formatFullDate(job['job_date']),
                              ),
                              _metaRow(
                                Icons.access_time,
                                'Time',
                                '${job['start_time'] ?? '-'} - ${job['end_time'] ?? '-'}',
                              ),
                              _metaRow(
                                Icons.timer,
                                'Duration',
                                job['duration'] ?? '',
                              ),
                              _metaRow(
                                Icons.payments,
                                'Payment',
                                job['payment_amount'] ?? '',
                              ),
                            ],
                            if (isCommission) ...[
                              _metaRow(
                                Icons.percent,
                                'Commission rate',
                                job['commission_rate'] ?? '',
                              ),
                              _metaRow(
                                Icons.flag,
                                'Target leads',
                                job['target_leads'] ?? '',
                              ),
                              _metaRow(
                                Icons.trending_up,
                                'Potential earning',
                                job['potential_earning'] ?? '',
                              ),
                              _metaRow(
                                Icons.business,
                                'Industry',
                                job['industry'] ?? '',
                              ),
                            ],
                            if (isProject) ...[
                              _metaRow(
                                Icons.account_balance_wallet,
                                'Budget',
                                '${job['budget_min'] ?? ''} - ${job['budget_max'] ?? ''}',
                              ),
                              _metaRow(
                                Icons.timeline,
                                'Duration',
                                job['duration'] ?? '',
                              ),
                              _metaRow(
                                Icons.task,
                                'Deliverables',
                                job['deliverables'] ?? '',
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _sectionCard(
                        title: 'Contact',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (contactEmail.isNotEmpty)
                              Row(
                                children: [
                                  Expanded(child: Text(contactEmail)),
                                  IconButton(
                                    tooltip: 'Copy email',
                                    onPressed: () => _copyToClipboard(
                                      context,
                                      'Email',
                                      contactEmail,
                                    ),
                                    icon: const Icon(Icons.copy, size: 18),
                                  ),
                                ],
                              ),
                            if (contactPhone.isNotEmpty)
                              Row(
                                children: [
                                  Expanded(child: Text(contactPhone)),
                                  IconButton(
                                    tooltip: 'Copy phone',
                                    onPressed: () => _copyToClipboard(
                                      context,
                                      'Phone',
                                      contactPhone,
                                    ),
                                    icon: const Icon(Icons.copy, size: 18),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => _fakeApply(context, title),
                              icon: const Icon(Icons.send, color: Colors.white),
                              label: const Text(
                                'Apply Now',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                            ),
                          ],
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

  // helper used inside build
  Widget _smallChip(IconData icon, String text) {
    return Chip(
      backgroundColor: Colors.grey.shade50,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Flexible(child: Text(text, overflow: TextOverflow.ellipsis)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}
