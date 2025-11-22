import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

class employerProjectApplicantsPage extends StatefulWidget {
  final int jobId;
  final String? jobTitle;

  const employerProjectApplicantsPage({
    super.key,
    required this.jobId,
    this.jobTitle,
  });

  @override
  State<employerProjectApplicantsPage> createState() =>
      _employerProjectApplicantsPageState();
}

class _employerProjectApplicantsPageState
    extends State<employerProjectApplicantsPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _applicants = [];

  // per-row loading flags (for status update)
  final Set<int> _rowsLoading = {};

  // endpoints (replace {{bhadyata}} with your base URL if needed)
  final String _fetchUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/projectApplicantsByProject';
  final String _updateStatusUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/updateStatusProject';

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
      // Send hr_approval = 1 as requested
      final res = await http.post(
        Uri.parse(_fetchUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"project_id": widget.jobId, "hr_approval": 1}),
      );

      if (res.statusCode == 200) {
        final jsonBody = jsonDecode(res.body) as Map<String, dynamic>;
        final List data = (jsonBody['data'] as List?) ?? [];
        _applicants = data.map<Map<String, dynamic>>((e) {
          if (e is Map) return Map<String, dynamic>.from(e as Map);
          return <String, dynamic>{};
        }).toList();
        if (mounted) setState(() {});
      } else {
        setState(() => _error = 'Server error: ${res.statusCode}');
      }
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<bool> _updateApplicantStatus({
    required int recordId,
    required String newStatus,
    required int index,
  }) async {
    if (_rowsLoading.contains(index)) return false;
    setState(() => _rowsLoading.add(index));

    final oldStatus = _applicants[index]['status'];

    // optimistic local update
    setState(() => _applicants[index]['status'] = newStatus);

    try {
      final res = await http.post(
        Uri.parse(_updateStatusUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"id": recordId, "status": newStatus}),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final ok = (body['success'] == true) || (body['status'] == true);

        if (ok) {
          final updated = body['data'];
          if (updated is Map) {
            setState(() {
              // merge updated fields returned by server into local applicant map
              updated.forEach((k, v) => _applicants[index][k] = v);
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                body['message'] ?? 'Applicant status updated successfully.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return true;
        } else {
          // revert local change
          setState(() => _applicants[index]['status'] = oldStatus);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(body['message'] ?? 'Failed to update status'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return false;
        }
      } else {
        setState(() => _applicants[index]['status'] = oldStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error: ${res.statusCode}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return false;
      }
    } catch (e) {
      setState(() => _applicants[index]['status'] = oldStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    } finally {
      setState(() => _rowsLoading.remove(index));
    }
  }

  // helpers
  String _safe(dynamic v) {
    if (v == null) return '—';
    final s = v.toString().trim();
    return s.isEmpty ? '—' : s;
  }

  String _formatDateTime(dynamic raw) {
    if (raw == null) return '—';
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      final d = dt.day.toString().padLeft(2, '0');
      final m = const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][dt.month - 1];
      final hh = dt.hour.toString().padLeft(2, '0');
      final mm = dt.minute.toString().padLeft(2, '0');
      return "$d $m ${dt.year}, $hh:$mm";
    } catch (_) {
      final s = raw.toString();
      return s.isEmpty ? '—' : s;
    }
  }

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
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

  Widget _statusChip(String text, Color color) => Chip(
    label: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
    ),
    backgroundColor: color.withOpacity(0.12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    visualDensity: VisualDensity.compact,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
  );

  double _cardMaxWidth(BoxConstraints constraints) {
    if (constraints.maxWidth >= 1400) return 1100;
    if (constraints.maxWidth >= 1100) return 900;
    if (constraints.maxWidth >= 800) return 720;
    if (constraints.maxWidth >= 600) return 560;
    return double.infinity;
  }

  Future<bool?> _confirm(
    BuildContext ctx,
    String title,
    String content,
    String confirmLabel,
  ) {
    return showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  Widget _emptyPlaceholder(bool isWeb) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: isWeb ? 72 : 140),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline, size: 72, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'No applicants',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // list of allowed statuses (as provided)
  static const List<String> _allowedStatuses = [
    'applied',
    'interview_scheduled',
    'shortlisted',
    'selected',
    'rejected',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth >= 900;

        final appBarTitle = widget.jobTitle == null || widget.jobTitle!.isEmpty
            ? const Text('Applicants')
            : Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.jobTitle!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('—', style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 8),
                  const Text(
                    'Applicants',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );

        return HrDashboardWrapper(
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              automaticallyImplyLeading: !isWeb,
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: AppColors.primary,
              title: appBarTitle,
              elevation: 2,
              actions: [
                IconButton(
                  tooltip: 'Refresh',
                  icon: const Icon(Icons.refresh_outlined),
                  onPressed: _fetchApplicants,
                ),
              ],
            ),
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _fetchApplicants,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchApplicants,
                    child: _applicants.isEmpty
                        ? _emptyPlaceholder(isWeb)
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: isWeb ? 28 : 12,
                              vertical: 18,
                            ),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemCount: _applicants.length,
                            itemBuilder: (context, i) {
                              final a = _applicants[i];
                              final first = _safe(a['first_name']);
                              final last = _safe(a['last_name']);
                              final name = [first, last]
                                  .where((e) => e != '—' && e.isNotEmpty)
                                  .join(' ');
                              final mobile = _safe(a['mobile']);
                              final email = _safe(a['email']);
                              final rawDate =
                                  a['application_date'] ?? a['created_at'];
                              final applied = _formatDateTime(rawDate);
                              final status = _safe(a['status']);
                              final statusColor = _statusColor(status);

                              final profileImg = _safe(a['profile_image']);
                              final hasImg =
                                  profileImg != '—' &&
                                  (profileImg.startsWith('http') ||
                                      profileImg.startsWith('https'));

                              final int recordId = (() {
                                final cand =
                                    a['id'] ??
                                    a['applicant_id'] ??
                                    a['applicantId'];
                                if (cand == null) return 0;
                                return int.tryParse(cand.toString()) ?? 0;
                              })();

                              // hr approval is fetched from server but we do not allow changing it here
                              final int hrApproval =
                                  int.tryParse(_safe(a['hr_approval'])) ?? 2;

                              final indicatorColor = hrApproval == 1
                                  ? Colors.green.shade400
                                  : hrApproval == 3
                                  ? Colors.red.shade400
                                  : Colors.orange.shade400;

                              final bool rowLoading = _rowsLoading.contains(i);

                              return Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: _cardMaxWidth(constraints),
                                  ),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // left accent bar
                                                Container(
                                                  width: 6,
                                                  height: 140,
                                                  decoration: BoxDecoration(
                                                    color: indicatorColor,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                12,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                  ),
                                                ),

                                                // main content
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 14.0,
                                                          vertical: 12.0,
                                                        ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // avatar
                                                        CircleAvatar(
                                                          radius: 28,
                                                          backgroundColor:
                                                              AppColors.primary
                                                                  .withOpacity(
                                                                    0.12,
                                                                  ),
                                                          foregroundImage:
                                                              hasImg
                                                              ? NetworkImage(
                                                                  profileImg,
                                                                )
                                                              : null,
                                                          child: hasImg
                                                              ? null
                                                              : Text(
                                                                  (name.isEmpty
                                                                          ? '?'
                                                                          : name.split(' ').first[0])
                                                                      .toUpperCase(),
                                                                  style: TextStyle(
                                                                    color: AppColors
                                                                        .primary,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),

                                                        // details column (name, contact)
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      name.isEmpty
                                                                          ? '—'
                                                                          : name,
                                                                      style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  _statusChip(
                                                                    'Status: $status',
                                                                    statusColor,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              if (mobile != '—')
                                                                Text(
                                                                  'Mobile: $mobile',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                  ),
                                                                ),
                                                              if (email != '—')
                                                                Text(
                                                                  'Email: $email',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                  ),
                                                                ),
                                                              const SizedBox(
                                                                height: 12,
                                                              ),

                                                              // applied + remarks stacked vertically
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Applied: $applied',
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                      fontSize:
                                                                          12.5,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  if ((a['remarks'] ??
                                                                          '')
                                                                      .toString()
                                                                      .isNotEmpty)
                                                                    Container(
                                                                      padding: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            8,
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade50,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              8,
                                                                            ),
                                                                      ),
                                                                      child: Text(
                                                                        a['remarks']
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade700,
                                                                          fontSize:
                                                                              13,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // divider
                                            Divider(
                                              height: 1,
                                              color: Colors.grey.shade100,
                                            ),

                                            // bottom action row:
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14.0,
                                                    vertical: 10.0,
                                                  ),
                                              child: Row(
                                                children: [
                                                  _statusChip(
                                                    hrApproval == 1
                                                        ? 'HR: Approved'
                                                        : hrApproval == 3
                                                        ? 'HR: Rejected'
                                                        : 'HR: Pending',
                                                    hrApproval == 1
                                                        ? Colors.green
                                                        : hrApproval == 3
                                                        ? Colors.red
                                                        : Colors.orange,
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                    tooltip: 'View profile',
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              ViewProfilePage(
                                                                applicant: a,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.remove_red_eye,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                  // show spinner while status change is in progress
                                                  if (rowLoading)
                                                    SizedBox(
                                                      width: isWeb ? 120 : 36,
                                                      height: isWeb ? 36 : 36,
                                                      child: Center(
                                                        child: SizedBox(
                                                          width: 18,
                                                          height: 18,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth:
                                                                    2.2,
                                                              ),
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    Row(
                                                      children: [
                                                        // Status menu (select new status)
                                                        PopupMenuButton<String>(
                                                          tooltip:
                                                              'Change status',
                                                          onSelected: (newStatus) async {
                                                            // confirm before changing to some statuses (optional)
                                                            final confirm =
                                                                await _confirm(
                                                                  context,
                                                                  'Change status?',
                                                                  'Change status of ${name.isEmpty ? 'this applicant' : name} to "$newStatus"?',
                                                                  'Change',
                                                                );
                                                            if (confirm != true)
                                                              return;

                                                            await _updateApplicantStatus(
                                                              recordId:
                                                                  recordId,
                                                              newStatus:
                                                                  newStatus,
                                                              index: i,
                                                            );
                                                          },
                                                          itemBuilder: (_) => _allowedStatuses
                                                              .map(
                                                                (
                                                                  s,
                                                                ) => PopupMenuItem(
                                                                  value: s,
                                                                  child: Text(
                                                                    s
                                                                        .replaceAll(
                                                                          '_',
                                                                          ' ',
                                                                        )
                                                                        .toUpperCase(),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 8,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                              border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              children: const [
                                                                Icon(
                                                                  Icons
                                                                      .swap_vert,
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  'Change status',
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
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

/// Simple placeholder profile page - replace with your real profile screen
class ViewProfilePage extends StatelessWidget {
  final Map<String, dynamic> applicant;
  const ViewProfilePage({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    final name =
        ((applicant['first_name'] ?? '') + ' ' + (applicant['last_name'] ?? ''))
            .trim();
    return Scaffold(
      appBar: AppBar(
        title: Text(name.isEmpty ? 'Profile' : name),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.primary.withOpacity(0.12),
                backgroundImage:
                    (applicant['profile_image'] ?? '').toString().startsWith(
                      'http',
                    )
                    ? NetworkImage(applicant['profile_image'])
                    : null,
                child: (applicant['profile_image'] ?? '').toString().isEmpty
                    ? Text(
                        (name.isEmpty ? '?' : name[0]).toUpperCase(),
                        style: const TextStyle(fontSize: 28),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              name.isEmpty ? '—' : name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'Email',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(applicant['email']?.toString() ?? '—'),
            const SizedBox(height: 12),
            Text(
              'Mobile',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(applicant['mobile']?.toString() ?? '—'),
            const SizedBox(height: 12),
            Text(
              'Applied on',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              applicant['application_date']?.toString() ??
                  applicant['created_at']?.toString() ??
                  '—',
            ),
            const SizedBox(height: 12),
            if ((applicant['remarks'] ?? '').toString().isNotEmpty) ...[
              Text(
                'Remarks',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(applicant['remarks'].toString()),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
