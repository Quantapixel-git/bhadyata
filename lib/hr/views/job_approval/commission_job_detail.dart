import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jobshub/common/utils/app_color.dart';

/// Commission-based job detail page
class CommissionJobDetailPage extends StatefulWidget {
  final int jobId;
  final String viewUrl;

  const CommissionJobDetailPage({
    super.key,
    required this.jobId,
    required this.viewUrl,
  });

  @override
  State<CommissionJobDetailPage> createState() => _CommissionJobDetailPageState();
}

class _CommissionJobDetailPageState extends State<CommissionJobDetailPage> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _job;

  @override
  void initState() {
    super.initState();
    _fetchJob();
  }

  Future<void> _fetchJob() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await http.post(
        Uri.parse(widget.viewUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': widget.jobId}),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        if (body['success'] == true && body['data'] != null) {
          setState(() {
            _job = Map<String, dynamic>.from(body['data'] as Map);
            _loading = false;
          });
        } else {
          setState(() {
            _error = body['message']?.toString() ?? 'Unexpected response';
            _loading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Error ${res.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: $e';
        _loading = false;
      });
    }
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (e) {
      return raw;
    }
  }

  String _formatDateTimeIso(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (e) {
      return raw ?? '';
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

  Widget _rowLabelValue(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(color: Colors.black87))),
          Expanded(flex: 5, child: Text(value?.isNotEmpty == true ? value! : '—')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Job #${widget.jobId}', style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchJob)],
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
                      OutlinedButton(onPressed: _fetchJob, child: const Text('Retry')),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _job == null
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _job!['title']?.toString() ?? '—',
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        if ((_job!['category']?.toString() ?? '').isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                            margin: const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(_job!['category']!.toString()),
                                          ),
                                        const Spacer(),
                                        Text(
                                          _job!['status']?.toString() ?? '',
                                          style: TextStyle(
                                            color: _job!['status'] == 'Active' ? Colors.green : Colors.orange,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Commission & basics
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              color: Colors.white,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.monetization_on_outlined, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Potential: ₹${_job!['potential_earning'] ?? '-'}',
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _rowLabelValue('Commission rate', _job!['commission_rate']?.toString()),
                                    _rowLabelValue('Commission type', _job!['commission_type']?.toString()),
                                    _rowLabelValue('Target leads', _job!['target_leads']?.toString()),
                                    _rowLabelValue('Lead type', _job!['lead_type']?.toString()),
                                    _rowLabelValue('Industry', _job!['industry']?.toString()),
                                    _rowLabelValue('Work mode', _job!['work_mode']?.toString()),
                                    _rowLabelValue('Openings', _job!['openings']?.toString()),
                                    _rowLabelValue('Application deadline', _formatDate(_job!['application_deadline']?.toString())),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Requirements / Perks
                            if ((_job!['requirements']?.toString() ?? '').isNotEmpty) ...[
                              const Text('Requirements', style: TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(_job!['requirements']!.toString()),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            if ((_job!['perks']?.toString() ?? '').isNotEmpty) ...[
                              const Text('Perks', style: TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(_job!['perks']!.toString()),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Job description
                            if ((_job!['job_description']?.toString() ?? '').isNotEmpty) ...[
                              const Text('Job description', style: TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(_job!['job_description']!.toString()),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Contact
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Contact', style: TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 8),
                                    if ((_job!['contact_email']?.toString() ?? '').isNotEmpty)
                                      _rowLabelValue('Email', _job!['contact_email']?.toString()),
                                    if ((_job!['contact_phone']?.toString() ?? '').isNotEmpty)
                                      _rowLabelValue('Phone', _job!['contact_phone']?.toString()),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Meta
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    _rowLabelValue('Status', _job!['status']?.toString()),
                                    const SizedBox(height: 6),
                                    _rowLabelValue('Created', _formatDateTimeIso(_job!['created_at']?.toString())),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),
                          ],
                        ),
                ),
    );
  }
}
