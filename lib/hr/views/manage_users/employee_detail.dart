import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/constants/base_url.dart';

class EmployeeUserDetailPage extends StatefulWidget {
  final int userId;
  const EmployeeUserDetailPage({super.key, required this.userId});

  @override
  State<EmployeeUserDetailPage> createState() => _EmployeeUserDetailPageState();
}

class _EmployeeUserDetailPageState extends State<EmployeeUserDetailPage> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _user; // json['data']['user']
  Map<String, dynamic>? _profile; // json['data']['profile']
  bool _hasProfile = false;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeProfile();
  }

  Future<void> _fetchEmployeeProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final String url = "${ApiConstants.baseUrl}employeeProfileByUserId";

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": widget.userId}),
      );

      if (res.statusCode == 200) {
        final jsonBody = jsonDecode(res.body) as Map<String, dynamic>;
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          final data = jsonBody['data'] as Map<String, dynamic>;
          setState(() {
            _user = (data['user'] as Map<String, dynamic>?)
                ?.cast<String, dynamic>();
            _profile = (data['profile'] as Map<String, dynamic>?)
                ?.cast<String, dynamic>();
            _hasProfile = data['has_profile'] == true;
            _loading = false;
          });
        } else {
          setState(() {
            _error = jsonBody['message']?.toString() ?? 'Unexpected response';
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

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      DateTime dt = DateTime.parse(raw);
      dt = dt.toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      try {
        final alt = raw.replaceFirst(' ', 'T');
        DateTime dt = DateTime.parse(alt);
        dt = dt.toLocal();
        return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
      } catch (__) {
        return raw;
      }
    }
  }

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cannot open link')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error opening link: $e')));
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
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
      child: Text(
        label,
        style: TextStyle(color: AppColors.primary, fontSize: 13),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String? value) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value ?? '—'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Employee #${widget.userId}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _fetchEmployeeProfile,
            icon: const Icon(Icons.refresh),
          ),
        ],
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
                  OutlinedButton(
                    onPressed: _fetchEmployeeProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: AppColors.primary.withOpacity(
                              0.12,
                            ),
                            backgroundImage:
                                (_user != null &&
                                    (_user!['profile_image']?.toString() ?? '')
                                        .startsWith('http'))
                                ? NetworkImage(
                                        _user!['profile_image']!.toString(),
                                      )
                                      as ImageProvider
                                : null,
                            child:
                                (_user == null ||
                                    (_user!['profile_image']?.toString() ?? '')
                                        .isEmpty ||
                                    !(_user!['profile_image']!
                                        .toString()
                                        .startsWith('http')))
                                ? Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                    size: 36,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ((_user != null)
                                              ? '${_user!['first_name'] ?? ''} ${_user!['last_name'] ?? ''}'
                                              : '')
                                          .trim()
                                          .isEmpty
                                      ? '—'
                                      : '${_user!['first_name'] ?? ''} ${_user!['last_name'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Chip(
                                      backgroundColor:
                                          (_user != null &&
                                              _user!['approval'] == 1)
                                          ? Colors.green.withOpacity(0.12)
                                          : Colors.orange.withOpacity(0.12),
                                      label: Text(
                                        (_user != null &&
                                                _user!['approval'] == 1)
                                            ? 'Approved'
                                            : 'Pending',
                                        style: TextStyle(
                                          color:
                                              (_user != null &&
                                                  _user!['approval'] == 1)
                                              ? Colors.green[800]
                                              : Colors.orange[800],
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (_user != null &&
                                        (_user!['created_at']?.toString() ?? '')
                                            .isNotEmpty)
                                      Text(
                                        _formatDate(
                                          _user!['created_at']!.toString(),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Basic info card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          _infoTile(
                            Icons.smartphone,
                            'Mobile',
                            _user?['mobile']?.toString() ?? '—',
                          ),
                          if (_user != null &&
                              (_user!['email']?.toString() ?? '').isNotEmpty)
                            _infoTile(
                              Icons.email,
                              'Email',
                              _user!['email']!.toString(),
                            ),
                          if (_user != null &&
                              (_user!['wallet_balance']?.toString() ?? '')
                                  .isNotEmpty)
                            _infoTile(
                              Icons.account_balance_wallet,
                              'Wallet',
                              '₹${_user!['wallet_balance']?.toString() ?? '0.00'}',
                            ),
                        ],
                      ),
                    ),
                  ),

                  // If no profile
                  if (!_hasProfile)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'No detailed profile available.',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ),

                  // Profile content
                  if (_profile != null && _profile!.isNotEmpty) ...[
                    _sectionTitle('Professional'),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,

                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Skills as chips
                            if ((_profile!['skills']?.toString() ?? '')
                                .isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Skills',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    children:
                                        (_profile!['skills']!.toString().split(
                                          ',',
                                        )).map((s) => _chip(s.trim())).toList(),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),

                            _rowLabelValue(
                              'Education',
                              _profile!['education']?.toString(),
                            ),
                            _rowLabelValue(
                              'Experience',
                              _profile!['experience']?.toString(),
                            ),
                            _rowLabelValue(
                              'Job type',
                              _profile!['job_type']?.toString(),
                            ),
                            _rowLabelValue(
                              'Category',
                              _profile!['category']?.toString(),
                            ),
                            const SizedBox(height: 8),

                            // Bio
                            if ((_profile!['bio']?.toString() ?? '').isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'About',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(_profile!['bio']!.toString()),
                                ],
                              ),

                            const SizedBox(height: 12),

                            // Links row
                            Row(
                              children: [
                                if ((_profile!['linkedin_url']?.toString() ??
                                        '')
                                    .isNotEmpty)
                                  TextButton.icon(
                                    onPressed: () => _openUrl(
                                      _profile!['linkedin_url']!.toString(),
                                    ),
                                    icon: const Icon(Icons.link),
                                    label: const Text('LinkedIn'),
                                  ),
                                if ((_profile!['resume_url']?.toString() ?? '')
                                    .isNotEmpty)
                                  TextButton.icon(
                                    onPressed: () => _openUrl(
                                      _profile!['resume_url']!.toString(),
                                    ),
                                    icon: const Icon(Icons.picture_as_pdf),
                                    label: const Text('Resume'),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // KYC status & docs
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'KYC: ${_kycStatusText(_profile!['kyc_approval'])}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if ((_profile!['kyc_pan']?.toString() ?? '')
                                        .isNotEmpty ||
                                    (_profile!['kyc_aadhaar']?.toString() ?? '')
                                        .isNotEmpty)
                                  Row(
                                    children: [
                                      if ((_profile!['kyc_pan']?.toString() ??
                                              '')
                                          .isNotEmpty)
                                        IconButton(
                                          tooltip: 'View PAN',
                                          onPressed: () => _openUrl(
                                            _profile!['kyc_pan']!.toString(),
                                          ),
                                          icon: const Icon(
                                            Icons.picture_as_pdf,
                                          ),
                                        ),
                                      if ((_profile!['kyc_aadhaar']
                                                  ?.toString() ??
                                              '')
                                          .isNotEmpty)
                                        IconButton(
                                          tooltip: 'View Aadhaar',
                                          onPressed: () => _openUrl(
                                            _profile!['kyc_aadhaar']!
                                                .toString(),
                                          ),
                                          icon: const Icon(
                                            Icons.picture_as_pdf,
                                          ),
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Created / Updated meta
                  ],

                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _rowLabelValue(String label, String? value) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(label, style: const TextStyle(color: Colors.black87)),
        ),
        Expanded(
          flex: 5,
          child: Text(value?.isNotEmpty == true ? value! : '—'),
        ),
      ],
    );
  }

  String _kycStatusText(dynamic v) {
    if (v == null) return 'Unknown';
    try {
      final n = int.parse(v.toString());
      if (n == 1) return 'Approved';
      if (n == 2) return 'Pending';
      if (n == 3) return 'Rejected';
      return 'Unknown';
    } catch (_) {
      return v.toString();
    }
  }
}
