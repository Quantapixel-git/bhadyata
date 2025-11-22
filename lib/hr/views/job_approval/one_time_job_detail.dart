import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jobshub/common/utils/app_color.dart';

/// Detail page for One-Time Recruitment job (calls OneTimeRecruitmentJobView API)
class OneTimeJobDetailPage extends StatefulWidget {
  final int jobId;
  final String viewUrl;

  const OneTimeJobDetailPage({
    super.key,
    required this.jobId,
    required this.viewUrl,
  });

  @override
  State<OneTimeJobDetailPage> createState() => _OneTimeJobDetailPageState();
}

class _OneTimeJobDetailPageState extends State<OneTimeJobDetailPage> {
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
      // API returns "2025-11-12" for job_date in sample
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (e) {
      return raw ?? '';
    }
  }

  String _formatDateTimeIso(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (e) {
      return raw;
    }
  }

  String _formatTimeOnly(String? time) {
    if (time == null || time.isEmpty) return '';
    try {
      // API sample: "15:32:00"
      final parts = time.split(':');
      if (parts.length >= 2) {
        final t = TimeOfDay(
            hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        final now = DateTime.now();
        final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
        return DateFormat('hh:mm a').format(dt);
      } else {
        return time;
      }
    } catch (e) {
      return time;
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

                            // Date / Time / Payment
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
                                        const Icon(Icons.event_outlined, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Date: ${_formatDate(_job!['job_date']?.toString())}',
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time_outlined, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Time: ${_formatTimeOnly(_job!['start_time']?.toString())} - ${_formatTimeOnly(_job!['end_time']?.toString())} (${_job!['duration'] ?? '—'})',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.monetization_on_outlined, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Payment: ₹${_job!['payment_amount'] ?? '-'} (${_job!['payment_type'] ?? '—'})',
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
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
