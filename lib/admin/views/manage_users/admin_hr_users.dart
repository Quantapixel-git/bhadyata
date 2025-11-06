import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/admin/views/side_bar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/constants/constants.dart'; // for ApiConstants.baseUrl

class HrUsersPage extends StatefulWidget {
  const HrUsersPage({super.key});

  @override
  State<HrUsersPage> createState() => _HrUsersPageState();
}

class _HrUsersPageState extends State<HrUsersPage>
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

  static const int _role = 3; // HR

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

    return AdminDashboardWrapper(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            automaticallyImplyLeading: !isWeb,
            title: const Text(
              "HR Users",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primary,
            bottom: const TabBar(
              labelColor: Colors.white,
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
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
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
      return const Center(child: Text('No users found'));
    }

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final u = items[i];
          final name = _fullName(u) ?? '—';
          final mobile = u['mobile']?.toString() ?? '—';
          final email = u['email']?.toString();
          final img = u['profile_image']?.toString();

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
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                foregroundImage: img != null && img.isNotEmpty
                    ? (img.startsWith('http') ? NetworkImage(img) : null)
                    : null,
                child: Icon(Icons.person, color: color),
              ),
              title: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mobile: $mobile'),
                  if (email != null && email.isNotEmpty) Text('Email: $email'),
                ],
              ),
              trailing: _statusPill(color),
            ),
          );
        },
      ),
    );
  }

  String? _fullName(Map<String, dynamic> u) {
    final f = (u['first_name'] ?? '').toString().trim();
    final l = (u['last_name'] ?? '').toString().trim();
    if (f.isEmpty && l.isEmpty) return null;
    return [f, l].where((e) => e.isNotEmpty).join(' ');
  }

  Widget _statusPill(Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(
      color == Colors.green
          ? 'Approved'
          : color == Colors.red
          ? 'Rejected'
          : 'Pending',
      style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
    ),
  );

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }
}
