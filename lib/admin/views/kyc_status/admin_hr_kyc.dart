// users_kyc_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/app_color.dart';

class HrKYCPage extends StatefulWidget {
  const HrKYCPage({super.key});

  @override
  State<HrKYCPage> createState() => _HrKYCPageState();
}

class _HrKYCPageState extends State<HrKYCPage> {
  // API config
  static const String _baseApi =
      'https://dialfirst.in/quantapixel/badhyata/api/'; // provided
  static const String _profilesPath = 'HrProfilesAll';
  static const String _kycStatusPath = 'HrKycStatus';

  // pagination (per_page fixed to 10)
  int _currentPage = 1;
  final int _perPage = 10;
  int _lastPage = 1;
  int _total = 0;

  // data
  List<_UserWithProfile> _items = [];
  bool _loading = false;
  bool _actionInProgress = false;
  String? _error;

  // scroll
  final ScrollController _scrollController = ScrollController();

  // KYC filter: null => All, 1 => Approved, 2 => Pending, 3 => Rejected
  int? _filterKycStatus;

  // lifecycle
  @override
  void initState() {
    super.initState();
    _fetchPage(page: _currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage({int page = 1}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final uri = Uri.parse(_baseApi + _profilesPath);

    // prepare body and include kyc_status only when filter is active
    final Map<String, dynamic> bodyMap = {
      'page': page,
      'per_page': _perPage,
      'role': 3, // keep role filter as requested
    };
    if (_filterKycStatus != null) {
      bodyMap['kyc_status'] = _filterKycStatus;
    }

    final body = jsonEncode(bodyMap);

    try {
      final res = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final Map<String, dynamic> jsonBody =
            json.decode(res.body) as Map<String, dynamic>;
        final success = jsonBody['success'] as bool? ?? false;
        if (!success) {
          setState(() {
            _error = jsonBody['message'] as String? ?? 'Failed to fetch users';
            _loading = false;
          });
          return;
        }

        final dataList = (jsonBody['data'] as List<dynamic>?) ?? [];
        final meta = jsonBody['meta'] as Map<String, dynamic>? ?? {};
        setState(() {
          _items = dataList
              .map((e) => _UserWithProfile.fromJson(e as Map<String, dynamic>))
              .toList();
          _currentPage = (meta['current_page'] as num?)?.toInt() ?? page;
          _lastPage = (meta['last_page'] as num?)?.toInt() ?? 1;
          _total = (meta['total'] as num?)?.toInt() ?? _items.length;
          _loading = false;
        });

        // guard: only jump if controller is attached to some scroll view
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      } else {
        final msg = res.body.isNotEmpty
            ? _parseMessage(res.body)
            : 'Server error (${res.statusCode})';
        setState(() {
          _error = msg;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: ${e.toString()}';
        _loading = false;
      });
    }
  }

  String _parseMessage(String rawBody) {
    try {
      final Map<String, dynamic> j =
          json.decode(rawBody) as Map<String, dynamic>;
      return j['message'] as String? ?? rawBody;
    } catch (_) {
      return rawBody;
    }
  }

  Future<void> _updateKycStatus({
    required int userId,
    required int kycStatus,
    required int profileId,
    required int itemIndex,
  }) async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    final uri = Uri.parse(_baseApi + _kycStatusPath);
    final body = jsonEncode({'user_id': userId, 'kyc_status': kycStatus});

    final oldStatus = _items[itemIndex].profile?.kycApproval ?? 2;

    // optimistic update
    setState(() {
      if (_items[itemIndex].profile != null) {
        _items[itemIndex].profile = _items[itemIndex].profile!.copyWith(
          kycApproval: kycStatus,
        );
      }
    });

    try {
      final res = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final Map<String, dynamic> jsonBody =
            json.decode(res.body) as Map<String, dynamic>;
        final success = jsonBody['success'] as bool? ?? false;
        if (!success) {
          // rollback
          setState(() {
            if (_items[itemIndex].profile != null) {
              _items[itemIndex].profile = _items[itemIndex].profile!.copyWith(
                kycApproval: oldStatus,
              );
            }
          });
          _showSnack(jsonBody['message'] as String? ?? 'Failed to update KYC');
        } else {
          final data = jsonBody['data'] as Map<String, dynamic>?;
          if (data != null) {
            final updatedApproval =
                (data['kyc_approval'] as num?)?.toInt() ?? kycStatus;
            final updatedAtStr = data['updated_at'] as String?;
            setState(() {
              if (_items[itemIndex].profile != null) {
                _items[itemIndex].profile = _items[itemIndex].profile!.copyWith(
                  kycApproval: updatedApproval,
                  updatedAt: updatedAtStr,
                );
              }
            });
            _showSnack('KYC status updated successfully');
          } else {
            _showSnack('KYC status updated');
          }
        }
      } else {
        // rollback
        setState(() {
          if (_items[itemIndex].profile != null) {
            _items[itemIndex].profile = _items[itemIndex].profile!.copyWith(
              kycApproval: oldStatus,
            );
          }
        });
        final msg = res.body.isNotEmpty
            ? _parseMessage(res.body)
            : 'Server error (${res.statusCode})';
        _showSnack(msg);
      }
    } catch (e) {
      // rollback
      setState(() {
        if (_items[itemIndex].profile != null) {
          _items[itemIndex].profile = _items[itemIndex].profile!.copyWith(
            kycApproval: oldStatus,
          );
        }
      });
      _showSnack('Network error: ${e.toString()}');
    } finally {
      setState(() => _actionInProgress = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showSnack('Invalid URL');
      return;
    }
    if (!await canLaunchUrl(uri)) {
      _showSnack('Cannot open link');
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // Build small filter chips at top
  Widget _buildStatusFilter() {
    const items = [
      {'label': 'All', 'value': null},
      {'label': 'Pending', 'value': 2},
      {'label': 'Approved', 'value': 1},
      {'label': 'Rejected', 'value': 3},
    ];

    return Wrap(
      spacing: 8,
      children: items.map((it) {
        final label = it['label'] as String;
        final val = it['value'] as int?;
        final selected = _filterKycStatus == val;

        return ChoiceChip(
          label: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: selected,
          onSelected: (sel) {
            if (sel) {
              setState(() {
                _filterKycStatus = val;
                _currentPage = 1;
              });
              _fetchPage(page: 1);
            }
          },

          // 🔥 Your requested behavior
          selectedColor: AppColors.primary,
          backgroundColor: Colors.white,
          checkmarkColor: Colors.white,
          showCheckmark: true,

          side: BorderSide(
            color: selected ? Colors.transparent : Colors.grey.shade300,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListItem(int index, _UserWithProfile item, bool isWide) {
    final user = item.user;
    final profile = item.profile;
    final kycStatus = profile?.kycApproval ?? 2;

    // NEW: whether KYC documents exist (either PAN or Aadhaar)
    final bool hasKycDocs =
        (profile?.kycPan != null && profile!.kycPan!.isNotEmpty) ||
        (profile?.kycAadhaar != null && profile!.kycAadhaar!.isNotEmpty);

    Color statusColor;
    String statusText;
    switch (kycStatus) {
      case 1:
        statusColor = Colors.green;
        statusText = 'Approved';
        break;
      case 3:
        statusColor = Colors.red;
        statusText = 'Rejected';
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Pending';
    }

    // card content
    final card = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 14.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // avatar
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary.withOpacity(0.08),
                      backgroundImage: user.profileImage != null
                          ? NetworkImage(user.profileImage!)
                          : null,
                      child: user.profileImage == null
                          ? const Icon(Icons.person, color: AppColors.primary)
                          : null,
                    ),
                    const SizedBox(width: 14),

                    // info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // name row
                          Row(
                            children: [
                              Text(
                                (user.firstName ?? '').trim().isEmpty &&
                                        (user.lastName ?? '').trim().isEmpty
                                    ? (user.mobile ?? 'Unknown')
                                    : '${(user.firstName ?? '').trim()} ${(user.lastName ?? '').trim()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (user.email != null)
                                Text(
                                  user.email!,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (user.email != null) const SizedBox(width: 12),
                              Text(
                                'Role: ${_roleLabel(user.role)}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // kyc links
                          Row(
                            children: [
                              if (profile?.kycPan != null)
                                GestureDetector(
                                  onTap: () => _openUrl(profile!.kycPan!),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: const Text(
                                      'View PAN',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              if (profile?.kycPan != null)
                                const SizedBox(width: 8),
                              if (profile?.kycAadhaar != null)
                                GestureDetector(
                                  onTap: () => _openUrl(profile!.kycAadhaar!),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: const Text(
                                      'View Aadhaar',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              if ((profile?.kycPan == null) &&
                                  (profile?.kycAadhaar == null))
                                const Text(
                                  'No KYC documents',
                                  style: TextStyle(color: Colors.black45),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // actions
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isWide ? 150 : 120),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // APPROVE button: enabled only if profile exists AND has docs AND not already approved
                          Tooltip(
                            message: hasKycDocs
                                ? (kycStatus == 1
                                      ? 'Already approved'
                                      : 'Approve KYC')
                                : 'Cannot approve — no KYC documents uploaded',
                            child: SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      (kycStatus == 1 || !hasKycDocs)
                                      ? Colors.grey.shade300
                                      : Colors.green,
                                  foregroundColor:
                                      (kycStatus == 1 || !hasKycDocs)
                                      ? Colors.black54
                                      : Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed:
                                    (kycStatus == 1 ||
                                        profile == null ||
                                        _actionInProgress ||
                                        !hasKycDocs)
                                    ? null
                                    : () => _confirmAndChangeStatus(
                                        index,
                                        user.id,
                                        1,
                                        profile.id,
                                      ),
                                child: Text(
                                  kycStatus == 1 ? 'Approved' : 'Approve',
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // REJECT button: enabled only if profile exists AND has docs AND not already rejected
                          Tooltip(
                            message: hasKycDocs
                                ? (kycStatus == 3
                                      ? 'Already rejected'
                                      : 'Reject KYC')
                                : 'Cannot reject — no KYC documents uploaded',
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: (kycStatus == 3 || !hasKycDocs)
                                        ? Colors.grey.shade300
                                        : Colors.red,
                                  ),
                                  foregroundColor:
                                      (kycStatus == 3 || !hasKycDocs)
                                      ? Colors.black54
                                      : Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed:
                                    (kycStatus == 3 ||
                                        profile == null ||
                                        _actionInProgress ||
                                        !hasKycDocs)
                                    ? null
                                    : () => _confirmAndChangeStatus(
                                        index,
                                        user.id,
                                        3,
                                        profile.id,
                                      ),
                                child: Text(
                                  kycStatus == 3 ? 'Rejected' : 'Reject',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return card;
  }

  static String _roleLabel(int role) {
    switch (role) {
      case 2:
        return 'Employer';
      case 3:
        return 'HR';
      default:
        return 'Employee';
    }
  }

  void _confirmAndChangeStatus(
    int index,
    int userId,
    int newStatus,
    int profileId,
  ) {
    final action = newStatus == 1 ? 'Approve' : 'Reject';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$action KYC?'),
        content: Text('Are you sure you want to $action this user\'s KYC?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _updateKycStatus(
                userId: userId,
                kycStatus: newStatus,
                profileId: profileId,
                itemIndex: index,
              );
            },
            child: Text(action),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      children: [
        Text('$_total users', style: const TextStyle(color: Colors.black54)),
        const SizedBox(width: 12),
        IconButton(
          onPressed: (_currentPage > 1 && !_loading)
              ? () => _fetchPage(page: _currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          'Page $_currentPage of $_lastPage',
          style: const TextStyle(color: Colors.black54),
        ),
        IconButton(
          onPressed: (_currentPage < _lastPage && !_loading)
              ? () => _fetchPage(page: _currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;
        final double horizontalPadding = isWeb ? 28 : 12;

        return AdminDashboardWrapper(
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Hr KYC",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                actions: [
                  IconButton(
                    tooltip: 'Refresh',
                    onPressed: _loading
                        ? null
                        : () => _fetchPage(page: _currentPage),
                    icon: const Icon(Icons.refresh),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      // top bar: filters + pagination
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            // Filters on the left
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: _buildStatusFilter(),
                              ),
                            ),

                            // pagination on the right
                            _buildPaginationControls(),
                          ],
                        ),
                      ),

                      // list area
                      Expanded(
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
                                    FilledButton(
                                      onPressed: () =>
                                          _fetchPage(page: _currentPage),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : _items.isEmpty
                            ? const Center(child: Text('No users found'))
                            : RawScrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                radius: const Radius.circular(10),
                                thickness: 10,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 24,
                                  ),
                                  itemCount: _items.length,
                                  itemBuilder: (context, index) {
                                    // give each item horizontal padding instead of padding the whole list
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 22.0,
                                      ),
                                      child: _buildListItem(
                                        index,
                                        _items[index],
                                        isWeb,
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
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

/// --- Models used internally by the page ---

class _UserWithProfile {
  final _User user;
  _Profile? profile;
  final bool hasProfile;

  _UserWithProfile({
    required this.user,
    required this.profile,
    required this.hasProfile,
  });

  factory _UserWithProfile.fromJson(Map<String, dynamic> json) {
    final user = _User.fromJson(json['user'] as Map<String, dynamic>);
    final profileJson = json['profile'] as Map<String, dynamic>?;
    final profile = profileJson != null ? _Profile.fromJson(profileJson) : null;
    final hasProfile = json['has_profile'] as bool? ?? (profile != null);
    return _UserWithProfile(
      user: user,
      profile: profile,
      hasProfile: hasProfile,
    );
  }
}

class _User {
  final int id;
  final String? mobile;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImage;
  final int role;
  final int approval;

  _User({
    required this.id,
    this.mobile,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImage,
    required this.role,
    required this.approval,
  });

  factory _User.fromJson(Map<String, dynamic> json) {
    return _User(
      id: (json['id'] as num).toInt(),
      mobile: json['mobile'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      profileImage: json['profile_image'] as String?,
      role: (json['role'] as num?)?.toInt() ?? 1,
      approval: (json['approval'] as num?)?.toInt() ?? 2,
    );
  }
}

class _Profile {
  final int id;
  final int userId;
  final String? kycPan;
  final String? kycAadhaar;
  final int kycApproval;
  final String? createdAt;
  final String? updatedAt;

  _Profile({
    required this.id,
    required this.userId,
    this.kycPan,
    this.kycAadhaar,
    required this.kycApproval,
    this.createdAt,
    this.updatedAt,
  });

  factory _Profile.fromJson(Map<String, dynamic> json) {
    return _Profile(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      kycPan: json['kyc_pan'] as String?,
      kycAadhaar: json['kyc_aadhaar'] as String?,
      kycApproval: (json['kyc_approval'] as num?)?.toInt() ?? 2,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  _Profile copyWith({int? kycApproval, String? updatedAt}) {
    return _Profile(
      id: id,
      userId: userId,
      kycPan: kycPan,
      kycAadhaar: kycAadhaar,
      kycApproval: kycApproval ?? this.kycApproval,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
