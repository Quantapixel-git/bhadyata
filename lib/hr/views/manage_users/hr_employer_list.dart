import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/hr/views/manage_users/employer_detail.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

class HrEmployerUsersPage extends StatefulWidget {
  const HrEmployerUsersPage({super.key});

  @override
  State<HrEmployerUsersPage> createState() => _HrEmployerUsersPageState();
}

class _HrEmployerUsersPageState extends State<HrEmployerUsersPage>
    with TickerProviderStateMixin {
  late final TabController _tab;
  bool isWeb = false;

  // caches
  List<Map<String, dynamic>> _pending = [];
  List<Map<String, dynamic>> _approved = [];
  List<Map<String, dynamic>> _rejected = [];

  bool _loadingPending = false;
  bool _loadingApproved = false;
  bool _loadingRejected = false;

  String? _errPending;
  String? _errApproved;
  String? _errRejected;

  static const int _role = 2; // Employers

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([
      _fetchUsers('pending'),
      _fetchUsers('approved'),
      _fetchUsers('rejected'),
    ]);
  }

  Future<void> _fetchUsers(String type) async {
    setState(() {
      switch (type) {
        case 'pending':
          _loadingPending = true;
          _errPending = null;
          break;
        case 'approved':
          _loadingApproved = true;
          _errApproved = null;
          break;
        case 'rejected':
          _loadingRejected = true;
          _errRejected = null;
          break;
      }
    });

    final String url = switch (type) {
      'pending' => "${ApiConstants.baseUrl}usersPending",
      'approved' => "${ApiConstants.baseUrl}usersApproved",
      'rejected' => "${ApiConstants.baseUrl}usersRejected",
      _ => throw ArgumentError('Invalid type'),
    };

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"role": _role}),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final List data = (json['data'] as List?) ?? [];

        setState(() {
          final list = data.cast<Map<String, dynamic>>();
          if (type == 'pending') _pending = list;
          if (type == 'approved') _approved = list;
          if (type == 'rejected') _rejected = list;
        });
      } else {
        final msg = "Error ${res.statusCode}";
        setState(() {
          if (type == 'pending') _errPending = msg;
          if (type == 'approved') _errApproved = msg;
          if (type == 'rejected') _errRejected = msg;
        });
      }
    } catch (e) {
      setState(() {
        final msg = "Network error: $e";
        if (type == 'pending') _errPending = msg;
        if (type == 'approved') _errApproved = msg;
        if (type == 'rejected') _errRejected = msg;
      });
    } finally {
      setState(() {
        if (type == 'pending') _loadingPending = false;
        if (type == 'approved') _loadingApproved = false;
        if (type == 'rejected') _loadingRejected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    isWeb = width >= 900;

    return HrDashboardWrapper(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            automaticallyImplyLeading: !isWeb,
            title: const Text(
              "Employers",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primary,
            bottom: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "Pending"),
                Tab(text: "Approved"),
                Tab(text: "Rejected"),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    _buildList(
                      _pending,
                      _loadingPending,
                      _errPending,
                      color: Colors.orange,
                      onRetry: () => _fetchUsers('pending'),
                    ),
                    _buildList(
                      _approved,
                      _loadingApproved,
                      _errApproved,
                      color: Colors.green,
                      onRetry: () => _fetchUsers('approved'),
                    ),
                    _buildList(
                      _rejected,
                      _loadingRejected,
                      _errRejected,
                      color: Colors.red,
                      onRetry: () => _fetchUsers('rejected'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(
    List<Map<String, dynamic>> items,
    bool loading,
    String? error, {
    required Color color,
    required VoidCallback onRetry,
  }) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (items.isEmpty) {
      return const Center(
        child: Text('No users found', style: TextStyle(fontSize: 16)),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final u = items[i];
          final id = _parseId(u['id']);
          final name = _fullName(u) ?? '—';
          final mobile = u['mobile']?.toString() ?? '—';
          final email = u['email']?.toString() ?? '';
          final imgUrl = _pickImageUrl(u);
          final referral = u['referral_code']?.toString() ?? '';
          final wallet = u['wallet_balance']?.toString() ?? '0.00';
          final createdAtRaw = u['created_at']?.toString() ?? '';
          final createdAt = _formatJoinedAt(createdAtRaw);

          final approval = u['approval'];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: color.withOpacity(0.08),
                foregroundImage:
                    (imgUrl.isNotEmpty && imgUrl.startsWith('http'))
                    ? NetworkImage(imgUrl) as ImageProvider
                    : null,
                child: (imgUrl.isEmpty || !imgUrl.startsWith('http'))
                    ? Text(
                        _initials(name),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              title: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User ID: $id',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text('Mobile: $mobile'),
                  if (email.isNotEmpty) Text('Email: $email'),
                  // if (referral.isNotEmpty) Text('Referral: $referral'),
                  Text('Wallet: ₹$wallet'),
                  if (createdAt.isNotEmpty) Text('Joined: $createdAt'),
                ],
              ),
              trailing: SizedBox(
                width: 110,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: _statusPill(color, approval)),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        tooltip: 'View details',
                        icon: const Icon(Icons.visibility),
                        onPressed: () =>
                            _openUserDetail(context, id, isEmployee: false),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () => _openUserDetail(context, id, isEmployee: false),
            ),
          );
        },
      ),
    );
  }

  String _pickImageUrl(Map<String, dynamic> u) {
    final url = u['profile_image_url']?.toString() ?? '';
    if (url.isNotEmpty) return url;
    final raw = u['profile_image']?.toString() ?? '';
    return raw;
  }

  int _parseId(dynamic idVal) {
    if (idVal is int) return idVal;
    if (idVal is String) return int.tryParse(idVal) ?? 0;
    return 0;
  }

  String _initials(String name) {
    final parts = name.split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    final a = parts[0][0];
    final b = parts.length > 1 ? parts[1][0] : '';
    return (a + b).toUpperCase();
  }

  String? _fullName(Map<String, dynamic> u) {
    final f = (u['first_name'] ?? '').toString().trim();
    final l = (u['last_name'] ?? '').toString().trim();
    if (f.isEmpty && l.isEmpty) return null;
    return [f, l].where((e) => e.isNotEmpty).join(' ');
  }

  Widget _statusPill(Color color, dynamic approval) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(
      (approval == 1)
          ? 'Approved'
          : (approval == 3)
          ? 'Rejected'
          : 'Pending',
      style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
    ),
  );

  // Format 'created_at' into a readable local string:
  // Example: '17 Nov 2025, 09:12 PM'
  String _formatJoinedAt(String raw) {
    if (raw.isEmpty) return '';
    try {
      DateTime dt = DateTime.parse(raw);
      dt = dt.toLocal();
      final fmt = DateFormat('dd MMM yyyy, hh:mm a');
      return fmt.format(dt);
    } catch (_) {
      try {
        final alt = raw.replaceFirst(' ', 'T');
        DateTime dt = DateTime.parse(alt);
        dt = dt.toLocal();
        final fmt = DateFormat('dd MMM yyyy, hh:mm a');
        return fmt.format(dt);
      } catch (__) {
        return raw;
      }
    }
  }

  void _openUserDetail(
    BuildContext context,
    int userId, {
    required bool isEmployee,
  }) {
    if (userId <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid user id')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EmployerUserDetailPage(userId: userId)),
    );
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }
}

// // Placeholder detail page - replace with your API call and full UI
// class EmployerUserDetailPage extends StatelessWidget {
//   final int userId;
//   const EmployerUserDetailPage({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Employer #$userId'),
//         backgroundColor: AppColors.primary,
//       ),
//       body: Center(
//         child: Text(
//           'Load and show full details for employer id: $userId here.',
//         ),
//       ),
//     );
//   }
// }
