import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';

class AdminViewNotificationsPage extends StatefulWidget {
  const AdminViewNotificationsPage({super.key});

  @override
  State<AdminViewNotificationsPage> createState() =>
      _AdminViewNotificationsPageState();
}

class _AdminViewNotificationsPageState
    extends State<AdminViewNotificationsPage> {
  final List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;
  bool _error = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _loading = true;
      _error = false;
      _errorMessage = null;
    });

    final uri = Uri.parse('${ApiConstants.baseUrl}adminNotifications');

    try {
      final resp = await http.get(
        uri,
        headers: const {'Accept': 'application/json'},
      );

      debugPrint('\n===== adminNotifications =====');
      debugPrint('Status: ${resp.statusCode}');
      debugPrint(resp.body);

      if (resp.statusCode != 200) {
        throw Exception(
          'Server returned ${resp.statusCode}: '
          '${resp.body.length > 200 ? resp.body.substring(0, 200) : resp.body}',
        );
      }

      final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
      if (decoded['success'] != true) {
        throw Exception(decoded['message'] ?? 'API returned failure');
      }

      final List<dynamic> list = decoded['data'] ?? [];

      final mapped = list.map<Map<String, dynamic>>((n) {
        final List<dynamic> recRaw = n['recipients'] ?? [];
        final recipients = recRaw.map<Map<String, dynamic>>((r) {
          final first = (r['first_name'] ?? '').toString();
          final last = (r['last_name'] ?? '').toString();
          final name = (first + ' ' + last).trim().isEmpty
              ? (r['mobile'] ?? '').toString()
              : (first + ' ' + last).trim();

          return {
            'id': r['id'],
            'name': name,
            'email': r['email'] ?? '',
            'mobile': r['mobile'] ?? '',
          };
        }).toList();

        return {
          'id': n['notification_id'],
          'title': n['title'] ?? '',
          'message': n['message'] ?? '',
          'time': n['created_at'] ?? '',
          'recipients': recipients,
        };
      }).toList();

      setState(() {
        _notifications
          ..clear()
          ..addAll(mapped);
        _loading = false;
      });
    } catch (e) {
      debugPrint('❌ adminNotifications error: $e');
      setState(() {
        _error = true;
        _errorMessage = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return AdminDashboardWrapper(
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  'Sent Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _fetchNotifications,
                  ),
                ],
              ),

              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _errorMessage ??
                                      'Error loading notifications',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: _fetchNotifications,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _notifications.isEmpty
                      ? const Center(
                          child: Text(
                            'No notifications found.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _notifications.length,
                          itemBuilder: (context, index) {
                            final notif = _notifications[index];
                            final List recips =
                                (notif['recipients'] as List?) ?? [];
                            final totalRecipients = recips.length;

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title row
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: AppColors.primary
                                              .withOpacity(0.15),
                                          child: Icon(
                                            Icons.notifications,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            notif['title'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          notif['time'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Message
                                    if ((notif['message'] ?? '')
                                        .toString()
                                        .isNotEmpty) ...[
                                      Text(
                                        notif['message'],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 12),
                                    ],

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _CountPill(
                                          label: 'Recipients',
                                          count: totalRecipients,
                                          color: AppColors.primary,
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    NotificationRecipientsPage(
                                                      title:
                                                          notif['title'] ??
                                                          'Recipients',
                                                      recipients: recips
                                                          .cast<
                                                            Map<String, dynamic>
                                                          >(),
                                                    ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.list_alt,
                                            size: 18,
                                          ),
                                          label: const Text('View Recipients'),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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

class NotificationRecipientsPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> recipients;

  const NotificationRecipientsPage({
    super.key,
    required this.title,
    required this.recipients,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.primary,
          elevation: 2,
        ),
        body: _RecipientList(
          items: recipients,
          emptyText: 'No users received this notification.',
          icon: Icons.person,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _RecipientList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String emptyText;
  final IconData icon;
  final Color color;

  const _RecipientList({
    required this.items,
    required this.emptyText,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(emptyText, style: const TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (_, i) {
        final r = items[i];
        final email = (r['email'] ?? '').toString();
        final mobile = (r['mobile'] ?? '').toString();

        final subtitleParts = <String>[];
        if (email.isNotEmpty) subtitleParts.add(email);
        if (mobile.isNotEmpty) subtitleParts.add(mobile);
        final subtitle = subtitleParts.join(' • ');

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            title: Text(
              (r['name'] ?? '').toString(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: subtitle.isEmpty ? null : Text(subtitle),
          ),
        );
      },
    );
  }
}

class _CountPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _CountPill({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
