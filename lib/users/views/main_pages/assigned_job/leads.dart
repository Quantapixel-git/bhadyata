import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/constants/base_url.dart'; // ApiConstants.baseUrl

/// Lead model matching your API response.
class Lead {
  final int id;
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
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? (createdAt ?? DateTime.now());

  factory Lead.fromJson(Map<String, dynamic> json) {
    DateTime _parseDate(dynamic v) {
      if (v == null) return DateTime.now();
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    return Lead(
      id: json['id'] ?? 0,
      jobId: json['job_id'] ?? 0,
      employeeId: json['employee_id'] ?? 0,
      name: json['lead_name']?.toString() ?? '',
      mobile: json['lead_mobile']?.toString() ?? '',
      email: json['lead_email']?.toString() ?? '',
      source: json['lead_source']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      leadStatus: json['lead_status'] ?? 0,
      hrStatus: json['hr_status'] ?? 2,
      employerStatus: json['employer_status'] ?? 2,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }
}

class CommissionLeadsPage extends StatefulWidget {
  final int jobId;
  final String jobTitle;
  final int employeeId;
  final String employeeName;
  final int employerId; // 👈 NEW – needed for addLead API

  const CommissionLeadsPage({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.employeeId,
    required this.employeeName,
    required this.employerId,
  });

  @override
  State<CommissionLeadsPage> createState() => _CommissionLeadsPageState();
}

class _CommissionLeadsPageState extends State<CommissionLeadsPage> {
  final List<Lead> _leads = [];
  String _search = '';
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLeadsFromApi();
  }

  Future<void> _fetchLeadsFromApi() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}leadsByEmployeeAndJob');
      final body = {"employee_id": widget.employeeId, "job_id": widget.jobId};

      final res = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (res.statusCode < 200 || res.statusCode >= 300) {
        setState(() {
          _error = 'Server returned status ${res.statusCode}';
          _leads.clear();
        });
        return;
      }

      final decoded = jsonDecode(res.body);
      if (decoded is! Map || decoded['success'] != true) {
        setState(() {
          _error = decoded is Map
              ? (decoded['message']?.toString() ?? 'API error')
              : 'Unexpected response';
          _leads.clear();
        });
        return;
      }

      final List data = decoded['data'] as List? ?? [];
      final leads = data
          .map((e) => Lead.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      setState(() {
        _leads
          ..clear()
          ..addAll(leads);
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load leads: $e';
        _leads.clear();
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _onRefresh() => _fetchLeadsFromApi();

  /// ADD LEAD – uses {{bhadyata}}addLead API
  void _openAddLeadSheet() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final mobileCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final sourceCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            bool isSaving = false;

            Future<void> submit() async {
              if (!formKey.currentState!.validate()) return;

              setSheetState(() => isSaving = true);

              try {
                final uri = Uri.parse(
                  '${ApiConstants.baseUrl}addLead',
                ); // 👈 endpoint
                final body = {
                  "employer_id": widget.employerId,
                  "job_id": widget.jobId,
                  "employee_id": widget.employeeId,
                  "lead_name": nameCtrl.text.trim(),
                  "lead_mobile": mobileCtrl.text.trim(),
                  "lead_email": emailCtrl.text.trim(),
                  "lead_source": sourceCtrl.text.trim(),
                  "notes": notesCtrl.text.trim(),
                };

                final res = await http.post(
                  uri,
                  headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode(body),
                );

                final decoded = jsonDecode(res.body);
                if (res.statusCode < 200 ||
                    res.statusCode >= 300 ||
                    decoded is! Map ||
                    decoded['success'] != true) {
                  final msg = decoded is Map
                      ? (decoded['message']?.toString() ??
                            'Unable to submit lead')
                      : 'Unable to submit lead';
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg)));
                  }
                  return;
                }

                final data = decoded['data'];
                Lead newLead;
                if (data is Map<String, dynamic>) {
                  newLead = Lead.fromJson(data);
                } else {
                  // Fallback: create from request if data not returned properly
                  newLead = Lead(
                    id: 0,
                    jobId: widget.jobId,
                    employeeId: widget.employeeId,
                    name: nameCtrl.text.trim(),
                    mobile: mobileCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    source: sourceCtrl.text.trim(),
                    notes: notesCtrl.text.trim(),
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                }

                if (mounted) {
                  setState(() => _leads.insert(0, newLead));
                  Navigator.of(ctx).pop(); // close sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        decoded['message']?.toString() ??
                            'Lead submitted successfully.',
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to submit lead: $e')),
                  );
                }
              } finally {
                setSheetState(() => isSaving = false);
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Add Lead',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Lead name',
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: mobileCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Mobile',
                          hintText: '10 digit mobile',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Required';
                          }
                          if (v.trim().length < 7) {
                            return 'Enter valid mobile';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'example@mail.com',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          final pattern = RegExp(r'^[^@]+@[^@]+\.[^@]+');
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
                          hintText: 'WhatsApp / Instagram / Referral / Other',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: notesCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : submit,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: isSaving
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text('Save Lead'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLeadDetails(Lead lead) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            Text(
              'Lead status: ${lead.leadStatus == 1 ? 'Converted' : 'Not Converted'}',
            ),
            Text('HR status: ${_hrStatusLabel(lead.hrStatus)}'),
            Text('Employer status: ${_hrStatusLabel(lead.employerStatus)}'),
            const SizedBox(height: 8),
            Text(
              'Created: ${DateFormat.yMMMd().add_jm().format(lead.createdAt)}',
            ),
            Text(
              'Updated: ${DateFormat.yMMMd().add_jm().format(lead.updatedAt)}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Lead deleted')));
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
      backgroundColor: const Color(0xFFF7F5FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text(
          'Commission Leads',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _fetchLeadsFromApi,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;

            // 👇 now spans full width (no Center + ConstrainedBox)
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeaderCard(isWide),
                    const SizedBox(height: 16),
                    _buildSearchAndSummary(filtered.length),
                    const SizedBox(height: 16),

                    if (_loading && _leads.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_error != null && _leads.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 8),
                            Text(_error!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _fetchLeadsFromApi,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    else if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.group_add_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'No leads yet. Click "Add Lead" to create one.',
                            ),
                          ],
                        ),
                      )
                    else ...[
                      if (isWide)
                        _buildWebTable(filtered)
                      else
                        _buildMobileList(filtered),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isWide) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF9575CD)],
                ),
              ),
              child: const Icon(Icons.work, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.jobTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Job ID: ${widget.jobId}  •  ${widget.employeeName} (ID: ${widget.employeeId})',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: _openAddLeadSheet,
              icon: const Icon(Icons.add),
              label: const Text('Add Lead'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndSummary(int count) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name, mobile, email or source',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (v) => setState(() => _search = v.trim()),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$count lead${count == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Updated ${DateFormat('dd/MM HH:mm').format(DateTime.now())}',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebTable(List<Lead> leads) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 44,
            dataRowHeight: 56,
            columnSpacing: 24,
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            columns: const [
              DataColumn(label: Text('Lead')),
              DataColumn(label: Text('Contact')),
              DataColumn(label: Text('Source')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Created')),
              DataColumn(label: Text('Actions')),
            ],
            rows: leads.map((lead) {
              final created = DateFormat(
                'dd/MM/yyyy HH:mm',
              ).format(lead.createdAt);
              final statusLabel = lead.leadStatus == 1
                  ? 'Converted'
                  : 'Not Converted';

              return DataRow(
                cells: [
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead.name.isEmpty ? '(No name)' : lead.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (lead.notes.isNotEmpty)
                          Text(
                            lead.notes,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lead.mobile, style: const TextStyle(fontSize: 13)),
                        if (lead.email.isNotEmpty)
                          Text(
                            lead.email,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),
                  DataCell(_buildSourceChip(lead.source)),
                  DataCell(_buildStatusChip(statusLabel, lead.leadStatus == 1)),
                  DataCell(Text(created, style: const TextStyle(fontSize: 12))),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 20),
                          tooltip: 'View details',
                          onPressed: () => _showLeadDetails(lead),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          tooltip: 'Delete',
                          onPressed: () => _deleteLead(lead.id),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList(List<Lead> leads) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leads.length,
      itemBuilder: (ctx, i) {
        final lead = leads[i];
        final created = DateFormat('dd/MM HH:mm').format(lead.createdAt);
        final statusLabel = lead.leadStatus == 1
            ? 'Converted'
            : 'Not Converted';

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
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () => _showLeadDetails(lead),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leading: CircleAvatar(
                child: Text(
                  lead.name.isEmpty ? '?' : lead.name[0].toUpperCase(),
                ),
              ),
              title: Text(
                lead.name.isEmpty ? '(No name)' : lead.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${lead.mobile}'
                      '${lead.email.isNotEmpty ? ' • ${lead.email}' : ''}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildSourceChip(lead.source),
                        const SizedBox(width: 8),
                        _buildStatusChip(statusLabel, lead.leadStatus == 1),
                      ],
                    ),
                  ],
                ),
              ),
              trailing: Text(
                created,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceChip(String source) {
    final label = source.isEmpty ? 'Source: —' : source;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _buildStatusChip(String label, bool converted) {
    final bg = converted ? const Color(0xFFE6F5EA) : const Color(0xFFFFF4E5);
    final fg = converted ? const Color(0xFF2E7D32) : const Color(0xFFEF6C00);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
