import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/employer/views/leads/leads_page.dart';

class EmployeeLeadsPageNetwork extends StatefulWidget {
  final int employerId;
  final int jobId;
  final int employeeId;
  final String employeeName;
  final String jobTitle;

  const EmployeeLeadsPageNetwork({
    required this.employerId,
    required this.jobId,
    required this.employeeId,
    required this.employeeName,
    required this.jobTitle,
    super.key,
  });

  @override
  State<EmployeeLeadsPageNetwork> createState() =>
      _EmployeeLeadsPageNetworkState();
}

class _EmployeeLeadsPageNetworkState extends State<EmployeeLeadsPageNetwork> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _leads = [];

  // track lead ids currently being updated (to show per-lead spinner / disable controls)
  final Set<int> _updatingLeadIds = {};

  @override
  void initState() {
    super.initState();
    _fetchLeads();
  }

  /// Fetches leads using the endpoint:
  /// POST $API_BASE/leadsByEmployee
  /// body: { "employee_id": <id> }
  Future<void> _fetchLeads() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final uri = Uri.parse('$API_BASE/leadsByEmployee');
    final body = json.encode({'employee_id': widget.employeeId});

    try {
      final resp = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        throw Exception('HTTP ${resp.statusCode}: ${resp.reasonPhrase}');
      }

      final Map<String, dynamic> j = json.decode(resp.body);
      if (j['success'] != true) {
        throw Exception(j['message'] ?? 'API error fetching leads');
      }

      final List<dynamic> data = j['data'] ?? [];
      final List<Map<String, dynamic>> leads = data.map<Map<String, dynamic>>((
        raw,
      ) {
        final r = Map<String, dynamic>.from(raw as Map);
        return {
          'lead_record_id': (r['id'] ?? r['lead_record_id']) is num
              ? ((r['id'] ?? r['lead_record_id']) as num).toInt()
              : 0,
          'employer_id': r['employer_id'],
          'job_id': r['job_id'],
          'employee_id': r['employee_id'],
          'lead_name': r['lead_name'] ?? r['name'] ?? '',
          'lead_mobile': r['lead_mobile'] ?? r['mobile'] ?? '',
          'lead_email': r['lead_email'] ?? r['email'] ?? '',
          'lead_source': r['lead_source'] ?? '',
          'notes': r['notes'] ?? '',
          'hr_status': (r['hr_status'] ?? 2) is num
              ? (r['hr_status'] as num).toInt()
              : 2,
          'employer_status': (r['employer_status'] ?? 2) is num
              ? (r['employer_status'] as num).toInt()
              : 2,
          'lead_status': (r['lead_status'] ?? 0) is num
              ? (r['lead_status'] as num).toInt()
              : 0,
          'created_at': r['created_at'] ?? r['created'] ?? '',
          'raw': r,
        };
      }).toList();

      setState(() {
        _leads = leads;
        _loading = false;
      });
    } on TimeoutException {
      setState(() {
        _error = 'Request timed out';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  /// Calls employerUpdate API:
  /// POST $API_BASE/employerUpdate
  /// body: { "lead_id": <id>, "employer_status": <0|1|2> }
  Future<bool> _updateEmployerStatusNetwork({
    required int leadRecordId,
    required int newEmployerStatus,
  }) async {
    // avoid duplicate calls
    if (_updatingLeadIds.contains(leadRecordId)) return false;

    setState(() => _updatingLeadIds.add(leadRecordId));
    try {
      final uri = Uri.parse('$API_BASE/employerUpdate');
      final body = json.encode({
        'lead_id': leadRecordId,
        'employer_status': newEmployerStatus,
      });

      final resp = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        throw Exception('HTTP ${resp.statusCode}: ${resp.reasonPhrase}');
      }

      final Map<String, dynamic> j = json.decode(resp.body);
      if (j['success'] != true) {
        throw Exception(j['message'] ?? 'Failed to update employer status');
      }

      // server returns updated lead in j['data']
      final Map<String, dynamic>? updated = (j['data'] is Map)
          ? Map<String, dynamic>.from(j['data'])
          : null;
      if (updated != null) {
        _applyServerLeadUpdate(leadRecordId, updated);
      } else {
        // fallback: optimistic local update
        await _updateLocalLead(
          leadRecordId: leadRecordId,
          employerStatus: newEmployerStatus,
        );
      }

      return true;
    } on TimeoutException {
      _showSnack('Request timed out while updating employer status');
      return false;
    } catch (e) {
      _showSnack('Failed to update employer status: $e');
      return false;
    } finally {
      setState(() => _updatingLeadIds.remove(leadRecordId));
    }
  }

  /// Calls markConverted API:
  /// POST $API_BASE/markConverted
  /// body: { "lead_id": <id>, "lead_status": <0|1> }
  Future<bool> _updateLeadConvertedNetwork({
    required int leadRecordId,
    required int newLeadStatus,
  }) async {
    if (_updatingLeadIds.contains(leadRecordId)) return false;

    setState(() => _updatingLeadIds.add(leadRecordId));
    try {
      final uri = Uri.parse('$API_BASE/markConverted');
      final body = json.encode({
        'lead_id': leadRecordId,
        'lead_status': newLeadStatus,
      });

      final resp = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        throw Exception('HTTP ${resp.statusCode}: ${resp.reasonPhrase}');
      }

      final Map<String, dynamic> j = json.decode(resp.body);
      if (j['success'] != true) {
        throw Exception(j['message'] ?? 'Failed to update lead status');
      }

      final Map<String, dynamic>? updated = (j['data'] is Map)
          ? Map<String, dynamic>.from(j['data'])
          : null;
      if (updated != null) {
        _applyServerLeadUpdate(leadRecordId, updated);
      } else {
        await _updateLocalLead(
          leadRecordId: leadRecordId,
          leadStatus: newLeadStatus,
        );
      }

      return true;
    } on TimeoutException {
      _showSnack('Request timed out while updating lead status');
      return false;
    } catch (e) {
      _showSnack('Failed to update lead status: $e');
      return false;
    } finally {
      setState(() => _updatingLeadIds.remove(leadRecordId));
    }
  }

  /// Apply server-provided lead object to local _leads list (by id).
  /// Expects server `data` to contain the same fields as leadsByEmployee returns.
  void _applyServerLeadUpdate(
    int leadRecordId,
    Map<String, dynamic> serverLead,
  ) {
    try {
      for (final l in _leads) {
        final id = ((l['lead_record_id'] ?? 0) as num).toInt();
        if (id == leadRecordId) {
          // update fields we care about
          l['lead_name'] = serverLead['lead_name'] ?? l['lead_name'];
          l['lead_mobile'] = serverLead['lead_mobile'] ?? l['lead_mobile'];
          l['lead_email'] = serverLead['lead_email'] ?? l['lead_email'];
          l['lead_source'] = serverLead['lead_source'] ?? l['lead_source'];
          l['notes'] = serverLead['notes'] ?? l['notes'];
          l['hr_status'] = (serverLead['hr_status'] ?? l['hr_status']) is num
              ? (serverLead['hr_status'] as num).toInt()
              : l['hr_status'];
          l['employer_status'] =
              (serverLead['employer_status'] ?? l['employer_status']) is num
              ? (serverLead['employer_status'] as num).toInt()
              : l['employer_status'];
          l['lead_status'] =
              (serverLead['lead_status'] ?? l['lead_status']) is num
              ? (serverLead['lead_status'] as num).toInt()
              : l['lead_status'];
          l['created_at'] = serverLead['created_at'] ?? l['created_at'];
          l['raw'] = serverLead;
          break;
        }
      }
      if (mounted) setState(() {});
    } catch (e) {
      // ignore mapping errors; fall back to optimistic update handled elsewhere
    }
  }

  Future<bool> _updateLocalLead({
    required int leadRecordId,
    int? hrStatus,
    int? employerStatus,
    int? leadStatus,
  }) async {
    try {
      bool updated = false;
      for (final l in _leads) {
        final id = ((l['lead_record_id'] ?? 0) as num).toInt();
        if (id == leadRecordId) {
          if (hrStatus != null) l['hr_status'] = hrStatus;
          if (employerStatus != null) l['employer_status'] = employerStatus;
          if (leadStatus != null) l['lead_status'] = leadStatus;
          updated = true;
          break;
        }
      }
      if (!updated) throw Exception('Lead not found');
      if (mounted) setState(() {});
      return true;
    } catch (e) {
      return false;
    }
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String _hrStatusLabel(int s) {
    switch (s) {
      case 0:
        return 'Rejected';
      case 1:
        return 'Approved';
      default:
        return 'Pending';
    }
  }

  String _employerStatusLabel(int s) {
    switch (s) {
      case 0:
        return 'Rejected';
      case 1:
        return 'Approved';
      default:
        return 'Pending';
    }
  }

  String _leadStatusLabel(int s) => s == 1 ? 'Converted' : 'Not Converted';

  String _fmtCreatedAt(String raw) {
    if (raw.isEmpty) return '';
    try {
      final iso = raw.replaceAll('T', ' ');
      return iso.length >= 16 ? iso.substring(0, 16) : iso;
    } catch (_) {
      return raw.length >= 16 ? raw.substring(0, 16) : raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${widget.employeeName} — Leads',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error: $_error',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _fetchLeads,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : _leads.isEmpty
            ? const Center(child: Text('No leads for this assignment.'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total leads: ${_leads.length}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    ..._leads.map<Widget>((l) {
                      final int leadId = ((l['lead_record_id'] ?? 0) as num)
                          .toInt();
                      final int hrStatus = (l['hr_status'] ?? 2) as int;
                      final int employerStatus =
                          (l['employer_status'] ?? 2) as int;
                      final int leadStatus = (l['lead_status'] ?? 0) as int;
                      final String leadSource = (l['lead_source'] ?? '')
                          .toString();
                      final bool updating = _updatingLeadIds.contains(leadId);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l['lead_name'] ??
                                        (l['raw']?['lead_name'] ?? 'Unnamed'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  _fmtCreatedAt(
                                    (l['created_at'] ?? '').toString(),
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (leadSource.isNotEmpty) ...[
                              Row(
                                children: [
                                  const Icon(
                                    Icons.source,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    leadSource,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                            Row(
                              children: [
                                if ((l['lead_mobile'] ?? '')
                                    .toString()
                                    .isNotEmpty) ...[
                                  const Icon(Icons.phone, size: 16),
                                  const SizedBox(width: 6),
                                  Text(l['lead_mobile'] ?? ''),
                                  const SizedBox(width: 12),
                                ],
                                if ((l['lead_email'] ?? '')
                                    .toString()
                                    .isNotEmpty) ...[
                                  const Icon(Icons.email, size: 16),
                                  const SizedBox(width: 6),
                                  Text(l['lead_email'] ?? ''),
                                ],
                              ],
                            ),
                            if ((l['notes'] ?? '').toString().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                l['notes'] ?? '',
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                // HR status shown but NOT editable

                                // Employer status - chip + dropdown (Pending=2, Approved=1, Rejected=0)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Chip(
                                      avatar: CircleAvatar(
                                        backgroundColor: employerStatus == 1
                                            ? Colors.green.withOpacity(0.15)
                                            : (employerStatus == 0
                                                  ? Colors.red.withOpacity(0.15)
                                                  : Colors.orange.withOpacity(
                                                      0.15,
                                                    )),
                                        child: Icon(
                                          Icons.business,
                                          color: employerStatus == 1
                                              ? Colors.green
                                              : (employerStatus == 0
                                                    ? Colors.red
                                                    : Colors.orange),
                                          size: 16,
                                        ),
                                      ),
                                      label: Text(
                                        'Employer: ${_employerStatusLabel(employerStatus)}',
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    updating
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : DropdownButton<int>(
                                            value: employerStatus,
                                            items: const [
                                              DropdownMenuItem(
                                                value: 2,
                                                child: Text('Pending'),
                                              ),
                                              DropdownMenuItem(
                                                value: 1,
                                                child: Text('Approved'),
                                              ),
                                              DropdownMenuItem(
                                                value: 0,
                                                child: Text('Rejected'),
                                              ),
                                            ],
                                            onChanged: (val) async {
                                              if (val == null) return;
                                              final ok = await showDialog<bool>(
                                                context: context,
                                                builder: (c) => AlertDialog(
                                                  title: const Text('Confirm'),
                                                  content: Text(
                                                    'Update Employer status to ${val == 1 ? 'Approved' : (val == 0 ? 'Rejected' : 'Pending')}?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            c,
                                                            false,
                                                          ),
                                                      child: const Text(
                                                        'Cancel',
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            c,
                                                            true,
                                                          ),
                                                      child: const Text('Yes'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (ok == true) {
                                                final success =
                                                    await _updateEmployerStatusNetwork(
                                                      leadRecordId: leadId,
                                                      newEmployerStatus: val,
                                                    );
                                                if (success)
                                                  _showSnack(
                                                    'Employer status updated',
                                                  );
                                              }
                                            },
                                          ),
                                  ],
                                ),

                                // Converted status - chip + dropdown (Not Converted / Converted)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Chip(
                                      avatar: CircleAvatar(
                                        backgroundColor: leadStatus == 1
                                            ? Colors.green.withOpacity(0.15)
                                            : Colors.grey.withOpacity(0.15),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: leadStatus == 1
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 16,
                                        ),
                                      ),
                                      label: Text(
                                        'Status: ${_leadStatusLabel(leadStatus)}',
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    updating
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : DropdownButton<int>(
                                            value: leadStatus,
                                            items: const [
                                              DropdownMenuItem(
                                                value: 0,
                                                child: Text('Not Converted'),
                                              ),
                                              DropdownMenuItem(
                                                value: 1,
                                                child: Text('Converted'),
                                              ),
                                            ],
                                            onChanged: (val) async {
                                              if (val == null) return;
                                              final ok = await showDialog<bool>(
                                                context: context,
                                                builder: (c) => AlertDialog(
                                                  title: const Text('Confirm'),
                                                  content: Text(
                                                    'Mark lead as ${val == 1 ? "Converted" : "Not Converted"}?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            c,
                                                            false,
                                                          ),
                                                      child: const Text(
                                                        'Cancel',
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            c,
                                                            true,
                                                          ),
                                                      child: const Text('Yes'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (ok == true) {
                                                final success =
                                                    await _updateLeadConvertedNetwork(
                                                      leadRecordId: leadId,
                                                      newLeadStatus: val,
                                                    );
                                                if (success)
                                                  _showSnack(
                                                    'Lead converted status updated',
                                                  );
                                              }
                                            },
                                          ),
                                  ],
                                ),
                                Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor: hrStatus == 1
                                        ? Colors.green.withOpacity(0.15)
                                        : (hrStatus == 0
                                              ? Colors.red.withOpacity(0.15)
                                              : Colors.orange.withOpacity(
                                                  0.15,
                                                )),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: hrStatus == 1
                                          ? Colors.green
                                          : (hrStatus == 0
                                                ? Colors.red
                                                : Colors.orange),
                                      size: 16,
                                    ),
                                  ),
                                  label: Text(
                                    'HR: ${_hrStatusLabel(hrStatus)}',
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
      ),
    );
  }
}
