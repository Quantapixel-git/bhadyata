import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
// import 'package:jobshub/hr/views/Sidebar_dashboard/hr_side_bar.dart';
import 'package:jobshub/hr/views/hr_details/hr_edit_profile.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

class HrProfilePage extends StatefulWidget {
  const HrProfilePage({super.key});

  @override
  State<HrProfilePage> createState() => _HrProfilePageState();
}

class _HrProfilePageState extends State<HrProfilePage> {
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchEmployerProfile();
  }

  // 🧩 API CALL - getProfileById
  Future<Map<String, dynamic>?> fetchEmployerProfile() async {
    final userId = await SessionManager.getValue('hr_id');

    final url = Uri.parse("${ApiConstants.baseUrl}getProfileById");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        // return raw map so we can render all fields
        return Map<String, dynamic>.from(decoded['data'] as Map);
      } else {
        debugPrint("⚠️ API error: ${decoded['message']}");
        return null;
      }
    } else {
      debugPrint("❌ HTTP error: ${response.statusCode}");
      return null;
    }
  }

  // 🕒 "Joined X ago" from created_at
  String timeAgoFrom(String createdAt) {
    // Your API returns "YYYY-MM-DD HH:mm:ss"
    // Parse as local time; fallback gracefully.
    DateTime? dt;
    try {
      dt = DateTime.parse(createdAt.replaceFirst(' ', 'T'));
    } catch (_) {}
    dt ??= DateTime.now();

    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays >= 365) {
      final years = (diff.inDays / 365).floor();
      return 'Joined $years year${years > 1 ? 's' : ''} ago';
    } else if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return 'Joined $months month${months > 1 ? 's' : ''} ago';
    } else if (diff.inDays >= 7) {
      final weeks = (diff.inDays / 7).floor();
      return 'Joined $weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (diff.inDays >= 1) {
      final days = diff.inDays;
      return 'Joined $days day${days > 1 ? 's' : ''} ago';
    } else if (diff.inHours >= 1) {
      final hours = diff.inHours;
      return 'Joined $hours hour${hours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes >= 1) {
      final mins = diff.inMinutes;
      return 'Joined $mins minute${mins > 1 ? 's' : ''} ago';
    } else {
      return 'Joined just now';
    }
  }

  // 🔤 Pretty label from snake_case key
  String prettyKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  // 🧭 Optional mapping for a few known enums/fields
  String prettyValue(String key, dynamic value) {
    if (value == null) return '-';

    if (key == 'role') {
      switch (value) {
        case 1:
          return 'Employee';
        case 2:
          return 'Employer';
        case 3:
          return 'HR';
      }
    }
    if (key == 'status') {
      return value == 1
          ? 'Active'
          : (value == 2 ? 'Blocked' : value.toString());
    }
    if (key == 'approval') {
      switch (value) {
        case 1:
          return 'Approved';
        case 2:
          return 'Pending';
        case 3:
          return 'Rejected';
        default:
          return value.toString();
      }
    }
    if (key == 'wallet_balance') {
      return '₹$value';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return HrDashboardWrapper(
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "My Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: FutureBuilder<Map<String, dynamic>?>(
                    future: _profileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text("No profile found"));
                      }

                      final data = snapshot.data!;
                      return _buildProfileContent(isWeb, data);
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

  Widget _buildProfileContent(bool isWeb, Map<String, dynamic> data) {
    final String? imageUrl = (data['profile_image_url'] as String?);

    // Copy the API map and remove fields we never want to show as rows
    final Map<String, dynamic> displayMap = Map<String, dynamic>.from(data);

    // Hide these keys from the details list
    const hiddenKeys = <String>{
      'updated_at',
      'fcm_token',
      'profile_image_url', // keep for avatar only
      'profile_image', // hide raw filename
      'otp_code', // hide OTP
      'id',
      'first_name',
      'last_name',
    };
    hiddenKeys.forEach(displayMap.remove);

    // Header pieces
    final String firstName = (data['first_name'] ?? '').toString();
    final String lastName = (data['last_name'] ?? '').toString();
    final String fullName = [
      firstName,
      lastName,
    ].where((e) => e.isNotEmpty).join(' ').trim();
    final int? id = data['id'] is int
        ? data['id'] as int
        : int.tryParse('${data['id']}');

    // "Joined X ago"
    final String? createdAt = data['created_at']?.toString();
    final String? joinedAgo = createdAt != null ? timeAgoFrom(createdAt) : null;

    // Keys you prefer to show first (if present)
    final List<String> preferredOrder = [
      'mobile',
      'email',
      'referral_code',
      'referred_by',
      'role',
      'status',
      'approval',
      'wallet_balance',
      'created_at', // handled specially (we show "Joined ... ago")
    ];

    // Build ordered entries
    final List<MapEntry<String, dynamic>> ordered = [];
    final seen = <String>{};

    for (final k in preferredOrder) {
      if (displayMap.containsKey(k)) {
        ordered.add(MapEntry(k, displayMap[k]));
        seen.add(k);
      }
    }
    displayMap.forEach((k, v) {
      if (!seen.contains(k)) ordered.add(MapEntry(k, v));
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar (uses profile_image_url only here)
              Row(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                        ? NetworkImage(imageUrl)
                        : const AssetImage('assets/job_bgr.png')
                              as ImageProvider,
                  ),
                  SizedBox(width: 15,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName.isNotEmpty ? fullName : '—',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (id != null)
                        Text(
                          "ID: $id",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      const SizedBox(height: 6),

                      if (joinedAgo != null)
                        Text(
                          joinedAgo,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Header name + ID (not in details list)

              // Details
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      for (int i = 0; i < ordered.length; i++) ...[
                        if (ordered[i].key != 'created_at')
                          ProfileInfoRow(
                            title: prettyKey(ordered[i].key),
                            value: prettyValue(
                              ordered[i].key,
                              ordered[i].value,
                            ),
                          ),
                        if (i != ordered.length - 1) const Divider(),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit, size: 22),
                  label: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text("Edit Profile", style: TextStyle(fontSize: 18)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HrEditProfilePage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Profile Info Row Widget
class ProfileInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontSize: 14.5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
