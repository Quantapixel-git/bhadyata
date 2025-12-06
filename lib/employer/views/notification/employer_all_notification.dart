import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class EmployerNotificationsPage extends StatefulWidget {
  const EmployerNotificationsPage({super.key});

  @override
  State<EmployerNotificationsPage> createState() =>
      _EmployerNotificationsPageState();
}

class _EmployerNotificationsPageState extends State<EmployerNotificationsPage> {
  final List<Map<String, dynamic>> _notifications = [];
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    // 👇 get employer id from session (same style as send notification)
    final dynamic senderRaw = await SessionManager.getValue('employer_id');
    int? senderId;
    if (senderRaw is int) {
      senderId = senderRaw;
    } else if (senderRaw is String) {
      senderId = int.tryParse(senderRaw);
    }

    if (senderId == null) {
      setState(() {
        _loading = false;
        _errorMessage = "Could not read employer_id from session.";
      });
      return;
    }

    final url = Uri.parse("${ApiConstants.baseUrl}senderNotifications");

    try {
      final body = jsonEncode({"sender_id": senderId});

      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (resp.statusCode == 200) {
        final json = jsonDecode(resp.body);
        if (json['success'] == true) {
          final List<dynamic> data = json['data'] ?? [];

          final mapped = data.map<Map<String, dynamic>>((item) {
            final rawRecips = item['recipients'] as List<dynamic>? ?? [];

            final recips = rawRecips.map<Map<String, dynamic>>((r) {
              final first = (r['first_name'] ?? '').toString();
              final last = (r['last_name'] ?? '').toString();

              String name = (first + " " + last).trim();
              if (name.isEmpty) name = r['mobile'] ?? r['email'] ?? "";

              return {
                "name": name,
                "email": r['email'] ?? "",
                "mobile": r['mobile'] ?? "",
              };
            }).toList();

            return {
              "id": item['notification_id'],
              "title": item['title'] ?? "",
              "message": item['message'] ?? "",
              "time": item['created_at'] ?? "",
              "recipients": recips,
            };
          }).toList();

          setState(() {
            _notifications
              ..clear()
              ..addAll(mapped);
          });
        } else {
          setState(() {
            _errorMessage = json['message'] ?? "Failed to fetch notifications.";
          });
        }
      } else {
        setState(() {
          _errorMessage =
              "Error ${resp.statusCode} while fetching notifications.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Something went wrong while fetching notifications.";
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EmployerDashboardWrapper(
      child: Column(
        children: [
          AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Sent Notifications",
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
                  : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : _notifications.isEmpty
                  ? const Center(
                      child: Text(
                        "No notifications sent yet.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notif = _notifications[index];
                        final List recips =
                            (notif["recipients"] as List?) ?? [];

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
                                        notif["title"] ?? "",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      notif["time"] ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                if (notif["message"].toString().isNotEmpty)
                                  Text(
                                    notif["message"],
                                    style: const TextStyle(fontSize: 14),
                                  ),

                                const SizedBox(height: 12),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _CountPill(
                                      label: "Recipients",
                                      count: recips.length,
                                      color: Colors.teal,
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EmployerNotificationRecipientsPage(
                                                  title:
                                                      notif["title"] ??
                                                      "Recipients",
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
                                      label: const Text("View Recipients"),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
  }
}

class EmployerNotificationRecipientsPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> recipients;

  const EmployerNotificationRecipientsPage({
    super.key,
    required this.title,
    required this.recipients,
  });

  @override
  Widget build(BuildContext context) {
    return EmployerDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
        ),
        body: _RecipientList(
          items: recipients,
          emptyText: "No recipients for this notification.",
          icon: Icons.person,
          color: Colors.teal,
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
        final name = (r["name"] ?? "").toString();
        final email = (r["email"] ?? "").toString();
        final mobile = (r["mobile"] ?? "").toString();

        String subtitle = "";
        if (email.isNotEmpty)
          subtitle = email;
        else if (mobile.isNotEmpty)
          subtitle = mobile;

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
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
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
        "$label: $count",
        style: TextStyle(fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
