import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/admin/views/side_bar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/constants/constants.dart';

class EmployerQueryToAdminPage extends StatefulWidget {
  const EmployerQueryToAdminPage({super.key});

  @override
  State<EmployerQueryToAdminPage> createState() =>
      _EmployerQueryToAdminPageState();
}

class _EmployerQueryToAdminPageState extends State<EmployerQueryToAdminPage> {
  List<Map<String, dynamic>> _queries = [];
  bool _loading = true;
  String? _error;

  /// Per-item reply controller + sending state keyed by query id
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, bool> _sending = {};

  @override
  void initState() {
    super.initState();
    _fetchQueries();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchQueries() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse("${ApiConstants.baseUrl}GeneralQueryList");
      final res = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"sender_role": "employer"}),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final List data = (json['data'] as List?) ?? [];
        setState(() {
          _queries = data.cast<Map<String, dynamic>>();
        });
      } else {
        setState(() => _error = "Error ${res.statusCode}");
      }
    } catch (e) {
      setState(() => _error = "Network error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _sendReply(int id) async {
    final ctrl = _controllers[id];
    final text = ctrl?.text.trim() ?? '';
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please write a reply"),
        ),
      );
      return;
    }

    setState(() => _sending[id] = true);

    try {
      final uri = Uri.parse("${ApiConstants.baseUrl}GeneralQueryReply");
      final body = {"id": id, "reply_message": text, "status": "replied"};

      final res = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        // Update local item
        setState(() {
          final idx = _queries.indexWhere(
            (q) => (q['id'] as num).toInt() == id,
          );
          if (idx != -1) {
            _queries[idx] = {
              ..._queries[idx],
              "reply_message": text,
              "status": "replied",
              "updated_at": DateTime.now().toIso8601String(),
            };
          }
        });
        ctrl?.clear();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Reply submitted successfully"),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Error ${res.statusCode}: failed to reply"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Network error: $e"),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending[id] = false);
    }
  }

  String _fmtDate(dynamic iso) {
    if (iso == null) return '—';
    try {
      final dt = DateTime.tryParse(iso.toString());
      if (dt == null) return iso.toString();
      final y = dt.year.toString().padLeft(4, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      return "$y-$m-$d";
    } catch (_) {
      return iso.toString();
    }
  }

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'replied':
        return Colors.green;
      case 'open':
      default:
        return Colors.orange;
    }
  }

  Widget _statusPill(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.isEmpty ? 'Open' : status[0].toUpperCase() + status.substring(1),
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return AdminDashboardWrapper(
          child: Column(
            children: [
              // App bar consistent with AdminDashboard
              AppBar(
                centerTitle: true,
                automaticallyImplyLeading: !isWeb,
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: AppColors.primary,
                title: const Text(
                  "Employer → Admin Queries",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _fetchQueries,
                  ),
                ],
              ),

              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: _loading
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
                              const SizedBox(height: 8),
                              OutlinedButton(
                                onPressed: _fetchQueries,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchQueries,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(12),
                            itemCount: _queries.length,
                            itemBuilder: (context, index) {
                              final q = _queries[index];
                              final id = (q['id'] as num).toInt();
                              final subject = (q['subject'] ?? '').toString();
                              final message = (q['message'] ?? '').toString();
                              final reply = (q['reply_message'] ?? '')
                                  .toString();
                              final status = (q['status'] ?? 'open').toString();
                              final senderId =
                                  q['sender_id']?.toString() ?? '—';
                              final created = _fmtDate(q['created_at']);

                              _controllers.putIfAbsent(
                                id,
                                () => TextEditingController(),
                              );

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Subject + status
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              subject.isEmpty
                                                  ? "No subject"
                                                  : subject,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          _statusPill(status),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      // Sender / date
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person_outline,
                                            size: 16,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Employee ID: $senderId",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(
                                            Icons.event,
                                            size: 16,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Date: $created",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      // Message
                                      Text(
                                        message.isEmpty ? "—" : message,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 12),

                                      // Reply or input
                                      if (reply.isNotEmpty)
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(
                                              0.08,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.green.withOpacity(
                                                0.25,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.reply,
                                                color: Colors.green,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  reply,
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        TextField(
                                          controller: _controllers[id],
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            hintText: "Write your reply...",
                                            hintStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            suffixIcon: _sending[id] == true
                                                ? const Padding(
                                                    padding: EdgeInsets.all(
                                                      12.0,
                                                    ),
                                                    child: SizedBox(
                                                      width: 18,
                                                      height: 18,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                    ),
                                                  )
                                                : IconButton(
                                                    icon: Icon(
                                                      Icons.send,
                                                      color: AppColors.primary,
                                                    ),
                                                    onPressed: () =>
                                                        _sendReply(id),
                                                  ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
