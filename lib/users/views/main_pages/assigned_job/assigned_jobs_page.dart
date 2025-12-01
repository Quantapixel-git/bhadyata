// users/views/main_pages/assigned/assigned_jobs_page.dart
// Adapted: choose API based on user's job_type and use session user_id as employee_id
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
// import 'package:jobshub/users/views/main_pages/search/job_detail_page.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';

class AssignedJobsPage extends StatefulWidget {
  const AssignedJobsPage({super.key});

  @override
  State<AssignedJobsPage> createState() => _AssignedJobsPageState();
}

class _AssignedJobsPageState extends State<AssignedJobsPage> {
  bool _loading = false;
  String? _error;
  List<Map<String, dynamic>> _items = []; // normalized assigned items
  String _profileJobType = '';

  @override
  void initState() {
    super.initState();
    _loadAndFetch();
  }

  Future<void> _loadAndFetch() async {
    setState(() {
      _loading = true;
      _error = null;
      _items = [];
    });

    try {
      final storedJobType = await SessionManager.getValue('job_type') ?? '';
      final normalized = _normalizeJobType(storedJobType.toString());
      setState(() => _profileJobType = normalized);

      await _fetchAssignedForEmployee();
    } catch (e, st) {
      if (kDebugMode) print('❌ init error: $e\n$st');
      setState(() {
        _error = 'Failed to initialize: $e';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refresh() async {
    await _fetchAssignedForEmployee();
  }

  String _normalizeJobType(String raw) {
    final s = raw.toString().trim();
    final low = s.toLowerCase();
    if (low.contains('commission') || low.contains('commision'))
      return 'commission';
    if (low.contains('one') ||
        low.contains('one-time') ||
        low.contains('onetime') ||
        low.contains('one time'))
      return 'one-time';
    if (low.contains('project') ||
        low.contains('projects') ||
        low.contains('freelance') ||
        low.contains('it'))
      return 'project';
    if (low.contains('salary')) return 'salary';
    return s;
  }

  Future<void> _fetchAssignedForEmployee() async {
    setState(() {
      _loading = true;
      _error = null;
      _items = [];
    });

    try {
      final rawUser = await SessionManager.getValue('user_id') ?? '';
      final employeeId = rawUser?.toString() ?? '';
      if (employeeId.isEmpty) {
        setState(() {
          _error = 'Not logged in';
          _items = [];
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to see assigned jobs')),
          );
        }
        return;
      }

      final jt = _profileJobType.toLowerCase();
      String endpoint;
      if (jt.contains('commission')) {
        endpoint = 'commissionJobsByEmployee';
      } else if (jt.contains('one') ||
          jt.contains('one-time') ||
          jt.contains('onetime')) {
        endpoint = 'oneTimeJobsByEmployee';
      } else if (jt.contains('project')) {
        endpoint = 'projectsByEmployee';
      } else {
        endpoint = 'salaryJobsByEmployee';
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final body = {'employee_id': int.tryParse(employeeId) ?? employeeId};

      if (kDebugMode) {
        print('🔁 Assigned -> endpoint: $endpoint');
        print('🔁 URL: $uri');
        print('🔁 Body: ${jsonEncode(body)}');
      }

      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (kDebugMode) {
        print('⬅️ status: ${res.statusCode}');
        print('⬅️ body: ${res.body}');
      }

      if (res.statusCode < 200 || res.statusCode >= 300) {
        setState(() => _error = 'Server returned ${res.statusCode}');
        return;
      }

      final decoded = jsonDecode(res.body);
      final successFlag =
          (decoded is Map &&
          ((decoded['success'] == true) || (decoded['status'] == 1)));

      if (!successFlag) {
        setState(() {
          _items = [];
          _error = decoded is Map
              ? (decoded['message']?.toString() ?? 'API error')
              : 'Unexpected response';
        });
        return;
      }

      final List<dynamic> data = (decoded['data'] as List?) ?? [];

      // Normalize varied response shapes into a consistent map we can display
      final normalized = data.map<Map<String, dynamic>>((raw) {
        if (raw is! Map) return <String, dynamic>{'raw': raw};
        final map = Map<String, dynamic>.from(raw);

        // Several response variants exist: salary jobs, commission, one-time, projects
        // We'll extract common display fields where present.
        String id =
            (map['job_id'] ??
                    map['project_id'] ??
                    map['assigned_job_id'] ??
                    map['assigned_project_id'] ??
                    map['assignment_id'] ??
                    '')
                .toString();
        String title = (map['title'] ?? '').toString();
        String location = (map['location'] ?? '').toString();
        String jobType = map['job_type']?.toString() ?? '';
        // salary/payment/budget fields
        String salaryMin = map['salary_min']?.toString() ?? '';
        String salaryMax = map['salary_max']?.toString() ?? '';
        String salaryType = map['salary_type']?.toString() ?? '';
        String paymentAmount = map['payment_amount']?.toString() ?? '';
        String budgetMin = map['budget_min']?.toString() ?? '';
        String budgetMax = map['budget_max']?.toString() ?? '';

        // Compose a sensible displaySalary
        String displaySalary = '';
        if (salaryMin.isNotEmpty || salaryMax.isNotEmpty) {
          displaySalary = (salaryMin == salaryMax || salaryMax.isEmpty)
              ? '₹$salaryMin / ${salaryType.isNotEmpty ? salaryType : 'period'}'
              : '₹$salaryMin - ₹$salaryMax / ${salaryType.isNotEmpty ? salaryType : 'period'}';
        } else if (paymentAmount.isNotEmpty) {
          displaySalary = '₹$paymentAmount';
        } else if (budgetMin.isNotEmpty || budgetMax.isNotEmpty) {
          displaySalary = '₹$budgetMin - ₹$budgetMax';
        } else {
          displaySalary = map['salary']?.toString() ?? '';
        }

        return <String, dynamic>{
          'id': id,
          'title': title.isNotEmpty
              ? title
              : (map['name']?.toString() ?? 'Untitled'),
          'location': location,
          'job_type': jobType,
          'display_salary': displaySalary,
          'raw': map,
        };
      }).toList();

      setState(() {
        _items = normalized;
        _error = null;
      });
    } catch (e, st) {
      if (kDebugMode) print('❌ fetch assigned error: $e\n$st');
      setState(() {
        _error = 'Failed to fetch assigned items: $e';
        _items = [];
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildEmpty() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Column(
            children: const [
              Icon(Icons.assignment_late, size: 68, color: Colors.grey),
              SizedBox(height: 12),
              Text('No assigned job', style: TextStyle(fontSize: 18)),
              SizedBox(height: 6),
              Text(
                'You have no active assigned job at the moment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final it = _items[index];
        final title = it['title']?.toString() ?? 'Untitled';
        final subtitleParts = <String>[];
        if ((it['job_type'] ?? '').toString().isNotEmpty)
          subtitleParts.add(it['job_type'].toString());
        if ((it['location'] ?? '').toString().isNotEmpty)
          subtitleParts.add(it['location'].toString());
        final subtitle = subtitleParts.join(' • ');
        final salary = (it['display_salary'] ?? '').toString();

        return Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            // onTap: () => _openDetail(it),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              subtitle.isNotEmpty ? subtitle : 'Assigned',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (salary.isNotEmpty)
                  Text(
                    salary,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> 
                          CommissionLeadsPage(jobId: 1, jobTitle: 'Test', employeeId: 67, employeeName: 'Punita',)
                          ),
                        );
                      },
                      child: const Text('View'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine whether to show mobile AppBar+Drawer.
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 1000; // show appbar on narrower screens

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      // show drawer for mobile; on wider screens you can place a persistent sidebar elsewhere
      drawer: isMobile ? const AppDrawer() : null,
      appBar: isMobile
          ? AppBar(
              backgroundColor: AppColors.primary,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Assigned Job',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _fetchAssignedForEmployee,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : _items.isEmpty
            ? _buildEmpty()
            : _buildList(),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // add intl: ^0.17.0 to pubspec.yaml



/// Simple Lead model matching the important fields from your DB screenshot.
class Lead {
  final int id; // local id
  final int jobId;
  final int employeeId;
  final String name;
  final String mobile;
  final String email;
  final String source;
  final String notes;
  int leadStatus; // 0 = Not Converted, 1 = Converted
  int hrStatus; // 0 Rejected,1 Approved,2 Pending
  int employerStatus; // 0 Rejected,1 Approved,2 Pending
  final DateTime createdAt;
  DateTime updatedAt;

  Lead({
    required this.id,
    required this.jobId,
    required this.employeeId,
    required this.name,
    required this.mobile,
    required this.email,
    required this.source,
    required this.notes,
    this.leadStatus = 0,
    this.hrStatus = 2,
    this.employerStatus = 2,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? (createdAt ?? DateTime.now());
}

class CommissionLeadsPage extends StatefulWidget {
  final int jobId;
  final String jobTitle;
  final int employeeId;
  final String employeeName;

  const CommissionLeadsPage({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.employeeId,
    required this.employeeName,
  });

  @override
  State<CommissionLeadsPage> createState() => _CommissionLeadsPageState();
}

class _CommissionLeadsPageState extends State<CommissionLeadsPage> {
  final List<Lead> _leads = [];
  int _nextId = 1;
  String _search = '';

  @override
  void initState() {
    super.initState();
    // Optionally pre-fill with sample leads for demo
    _leads.addAll([
      Lead(
        id: _nextId++,
        jobId: widget.jobId,
        employeeId: widget.employeeId,
        name: 'Rohit Sharma',
        mobile: '9876543210',
        email: 'rohit@example.com',
        source: 'Referral',
        notes: 'Very interested, available next week',
        leadStatus: 0,
        hrStatus: 2,
      ),
      Lead(
        id: _nextId++,
        jobId: widget.jobId,
        employeeId: widget.employeeId,
        name: 'Neha Patel',
        mobile: '9123456780',
        email: 'neha@example.com',
        source: 'Job Portal',
        notes: 'Has 3 years of experience',
        leadStatus: 1,
        hrStatus: 1,
      ),
    ]);
  }

  void _openAddLeadSheet() {
    final _formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final mobileCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final sourceCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                Row(
                  children: [
                    const Expanded(
                        child: Text('Add Lead',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close))
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Name', hintText: 'Lead name'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: mobileCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            labelText: 'Mobile', hintText: '10 digit mobile'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (v.trim().length < 7) return 'Enter valid mobile';
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email', hintText: 'example@mail.com'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          final pattern =
                              RegExp(r'^[^@]+@[^@]+\.[^@]+'); // simple check
                          if (!pattern.hasMatch(v.trim())) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: sourceCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Source',
                          hintText: 'Referral / Portal / Walk-in / Other',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: notesCtrl,
                        maxLines: 3,
                        decoration:
                            const InputDecoration(labelText: 'Notes (optional)'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text('Save Lead'),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final newLead = Lead(
                                    id: _nextId++,
                                    jobId: widget.jobId,
                                    employeeId: widget.employeeId,
                                    name: nameCtrl.text.trim(),
                                    mobile: mobileCtrl.text.trim(),
                                    email: emailCtrl.text.trim(),
                                    source: sourceCtrl.text.trim(),
                                    notes: notesCtrl.text.trim(),
                                    leadStatus: 0,
                                    hrStatus: 2,
                                    employerStatus: 2,
                                  );
                                  setState(() => _leads.insert(0, newLead));
                                  Navigator.of(ctx).pop();
                                  // small feedback
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Lead added')),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLeadDetails(Lead lead) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lead.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mobile: ${lead.mobile}'),
            if (lead.email.isNotEmpty) Text('Email: ${lead.email}'),
            if (lead.source.isNotEmpty) Text('Source: ${lead.source}'),
            const SizedBox(height: 8),
            Text('Notes: ${lead.notes.isEmpty ? '—' : lead.notes}'),
            const SizedBox(height: 8),
            Text('Lead status: ${lead.leadStatus == 1 ? 'Converted' : 'Not Converted'}'),
            Text('HR status: ${_hrStatusLabel(lead.hrStatus)}'),
            Text('Employer status: ${_hrStatusLabel(lead.employerStatus)}'),
            const SizedBox(height: 8),
            Text('Created: ${DateFormat.yMMMd().add_jm().format(lead.createdAt)}'),
            Text('Updated: ${DateFormat.yMMMd().add_jm().format(lead.updatedAt)}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  String _hrStatusLabel(int v) {
    switch (v) {
      case 0:
        return 'Rejected';
      case 1:
        return 'Approved';
      case 2:
      default:
        return 'Pending';
    }
  }

  void _deleteLead(int id) {
    setState(() => _leads.removeWhere((l) => l.id == id));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lead deleted')));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _search.trim().isEmpty
        ? _leads
        : _leads.where((l) {
            final q = _search.toLowerCase();
            return l.name.toLowerCase().contains(q) ||
                l.mobile.toLowerCase().contains(q) ||
                l.email.toLowerCase().contains(q) ||
                l.source.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commission Leads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              // simple sample: toggle between all leads and only not converted
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        ListTile(
                          title: const Text('All leads'),
                          onTap: () {
                            setState(() {
                              // clear any search filter
                              _search = '';
                            });
                            Navigator.of(ctx).pop();
                          },
                        ),
                        ListTile(
                          title: const Text('Only Not Converted'),
                          onTap: () {
                            Navigator.of(ctx).pop();
                            setState(() {
                              _search = ''; // keep search empty and filter by conversion
                              // Use a temporary filter by replacing list with filtered? For demo we'll show a SnackBar
                              final notConverted = _leads.where((l) => l.leadStatus == 0).toList();
                              showDialog(
                                  context: context,
                                  builder: (dctx) => AlertDialog(
                                        title: const Text('Not Converted leads'),
                                        content: SizedBox(
                                          width: double.maxFinite,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: notConverted.length,
                                              itemBuilder: (_, i) {
                                                final lead = notConverted[i];
                                                return ListTile(
                                                  title: Text(lead.name),
                                                  subtitle: Text(lead.mobile),
                                                  onTap: () {
                                                    Navigator.of(dctx).pop();
                                                    _showLeadDetails(lead);
                                                  },
                                                );
                                              }),
                                        ),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.of(dctx).pop(), child: const Text('Close'))
                                        ],
                                      ));
                            });
                          },
                        ),
                      ]),
                    );
                  });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Job + Employee header
          Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
              child: Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.work)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Job ID: ${widget.jobId} • Employee: ${widget.employeeName} (ID: ${widget.employeeId})',
                            ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _openAddLeadSheet,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Lead'),
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search leads by name, mobile, email, source',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),

          const SizedBox(height: 8),

          // Leads list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.group_add_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('No leads yet. Tap "Add Lead" to create one.'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final lead = filtered[i];
                      return Dismissible(
                        key: ValueKey(lead.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteLead(lead.id),
                        child: Card(
                          child: ListTile(
                            onTap: () => _showLeadDetails(lead),
                            leading: CircleAvatar(child: Text(lead.name.isEmpty ? '?' : lead.name[0].toUpperCase())),
                            title: Text(lead.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${lead.mobile} ${lead.email.isNotEmpty ? '• ${lead.email}' : ''}'),
                                const SizedBox(height: 4),
                                Column(
                                  children: [
                                    Chip(label: Text(lead.source.isEmpty ? 'Source: —' : 'Source: ${lead.source}')),
                                    const SizedBox(width: 8),
                                    Text(
                                      lead.leadStatus == 1 ? 'Converted' : 'Not Converted',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: lead.leadStatus == 1 ? Colors.green : Colors.orange),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Text(
                              DateFormat('dd/MM HH:mm').format(lead.createdAt),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddLeadSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add Lead'),
      ),
    );
  }
}
