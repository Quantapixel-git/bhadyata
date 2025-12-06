import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';

class UserNotificationPage extends StatefulWidget {
  const UserNotificationPage({super.key});

  @override
  State<UserNotificationPage> createState() => _UserNotificationPageState();
}

class _UserNotificationPageState extends State<UserNotificationPage> {
  late Future<List<dynamic>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _fetchNotifications();
  }

  Future<List<dynamic>> _fetchNotifications() async {
    // 🔹 Get user_id from session
    final userIdStr = await SessionManager.getValue('user_id');
    final userId = int.tryParse(userIdStr?.toString() ?? '');

    if (userId == null) {
      throw Exception('User ID not found in session');
    }

    final url = Uri.parse('${ApiConstants.baseUrl}getUserNotifications');

    final response = await http.post(url, body: {'user_id': userId.toString()});

    if (response.statusCode != 200) {
      throw Exception('Failed to load notifications (${response.statusCode})');
    }

    final decoded = json.decode(response.body);

    if (decoded['success'] != true) {
      throw Exception(decoded['message'] ?? 'Error fetching notifications');
    }

    final List data = decoded['data'] ?? [];
    return data;
  }

  String _formatTime(dynamic createdAt) {
    // created_at comes like "2025-12-06 13:32:09"
    if (createdAt == null) return '';
    final raw = createdAt.toString();

    try {
      final dt = DateTime.parse(raw.replaceFirst(' ', 'T'));
      // simple formatting: "06 Dec, 1:32 PM"
      final timeOfDay =
          '${dt.hour % 12 == 0 ? 12 : dt.hour % 12}:${dt.minute.toString().padLeft(2, '0')}'
          ' ${dt.hour >= 12 ? 'PM' : 'AM'}';
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  $timeOfDay';
    } catch (_) {
      // if parse fails, just return as-is
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // ⏳ Loading
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // ❌ Error state
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load notifications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _notificationsFuture = _fetchNotifications();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            // 📭 No data
            return _buildEmptyState(context);
          }

          // ✅ Show list
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = notifications[index];

              final title = item['title']?.toString() ?? 'No title';
              final message = item['message']?.toString() ?? '';
              final createdAt = _formatTime(item['created_at']);
              final senderFirst = item['sender_first_name']?.toString();
              final senderLast = item['sender_last_name']?.toString();

              // If you later add read/unread logic, map status -> isRead here
              // For now, treat all as "New"
              final bool isRead = false; // item['status'] == 2 for example

              final String? senderName =
                  (senderFirst != null && senderFirst.isNotEmpty)
                  ? '$senderFirst ${senderLast ?? ''}'.trim()
                  : null;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isRead
                      ? Colors.white
                      : AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isRead
                        ? Colors.grey.shade200
                        : AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔔 Leading icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRead
                            ? Colors.grey.shade200
                            : AppColors.primary.withOpacity(0.15),
                      ),
                      child: Icon(
                        Icons.notifications,
                        size: 20,
                        color: isRead
                            ? Colors.grey.shade600
                            : AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // 📝 Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                createdAt,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (senderName != null && senderName.isNotEmpty) ...[
                            // Text(
                            //   'From: $senderName',
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.w500,
                            //     color: Colors.grey.shade700,
                            //   ),
                            // ),
                            // const SizedBox(height: 2),
                          ],
                          Text(
                            message,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          // if (!isRead) ...[
                          //   const SizedBox(height: 6),
                          //   Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: Container(
                          //       padding: const EdgeInsets.symmetric(
                          //         horizontal: 8,
                          //         vertical: 3,
                          //       ),
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(20),
                          //         color: AppColors.primary.withOpacity(0.12),
                          //       ),
                          //       child: Text(
                          //         "New",
                          //         style: TextStyle(
                          //           fontSize: 11.5,
                          //           fontWeight: FontWeight.w600,
                          //           color: AppColors.primary,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "No notifications yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "You’ll see important updates here.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
