import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/constants/base_url.dart';

class EmployerUserDetailPage extends StatefulWidget {
  final int userId;
  const EmployerUserDetailPage({super.key, required this.userId});

  @override
  State<EmployerUserDetailPage> createState() => _EmployerUserDetailPageState();
}

class _EmployerUserDetailPageState extends State<EmployerUserDetailPage> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final String url = "${ApiConstants.baseUrl}getEmployerProfileByUserId";

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": widget.userId}),
      );

      if (res.statusCode == 200) {
        final jsonBody = jsonDecode(res.body) as Map<String, dynamic>;
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          setState(() {
            // API returns data: { ...profile fields... }
            _profile = (jsonBody['data'] as Map<String, dynamic>)
                .cast<String, dynamic>();
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

  Widget _rowLabelValue(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Employer #${widget.userId}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _fetchProfile,
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
                    onPressed: _fetchProfile,
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
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
                            child: Icon(
                              Icons.business,
                              color: AppColors.primary,
                              size: 36,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _profile?['company_name']?.toString() ?? '—',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if ((_profile?['designation']?.toString() ?? '')
                                    .isNotEmpty)
                                  Text(
                                    _profile!['designation']!.toString(),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Chip(
                                      backgroundColor:
                                          (_profile?['kyc_approval'] == 1)
                                          ? Colors.green.withOpacity(0.12)
                                          : Colors.orange.withOpacity(0.12),
                                      label: Text(
                                        _kycStatusText(
                                          _profile?['kyc_approval'],
                                        ),
                                        style: TextStyle(
                                          color:
                                              (_profile?['kyc_approval'] == 1)
                                              ? Colors.green[800]
                                              : Colors.orange[800],
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if ((_profile?['created_at']?.toString() ??
                                            '')
                                        .isNotEmpty)
                                      Text(
                                        _formatDate(
                                          _profile!['created_at']!.toString(),
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

                  // Quick info card
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
                          if ((_profile?['company_website']?.toString() ?? '')
                              .isNotEmpty)
                            _infoTile(
                              Icons.language,
                              'Website',
                              _profile!['company_website']!.toString(),
                            ),
                          _infoTile(
                            Icons.apartment,
                            'Industry',
                            _profile?['industry_type']?.toString(),
                          ),
                          _infoTile(
                            Icons.people,
                            'Company size',
                            _profile?['company_size']?.toString(),
                          ),
                          _infoTile(
                            Icons.location_on,
                            'Office location',
                            _profile?['office_location']?.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // About / Bio
                  if ((_profile?['about_company']?.toString() ?? '')
                      .isNotEmpty) ...[
                    _sectionTitle('About Company'),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(_profile!['about_company']!.toString()),
                      ),
                    ),
                  ],

                  // KYC documents
                  if ((_profile?['kyc_pan']?.toString() ?? '').isNotEmpty ||
                      (_profile?['kyc_aadhaar']?.toString() ?? '')
                          .isNotEmpty) ...[
                    _sectionTitle('KYC Documents'),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            if ((_profile!['kyc_pan']?.toString() ?? '')
                                .isNotEmpty)
                              TextButton.icon(
                                onPressed: () =>
                                    _openUrl(_profile!['kyc_pan']!.toString()),
                                icon: const Icon(Icons.picture_as_pdf),
                                label: const Text('View PAN'),
                              ),
                            if ((_profile!['kyc_aadhaar']?.toString() ?? '')
                                .isNotEmpty)
                              TextButton.icon(
                                onPressed: () => _openUrl(
                                  _profile!['kyc_aadhaar']!.toString(),
                                ),
                                icon: const Icon(Icons.picture_as_pdf),
                                label: const Text('View Aadhaar'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Meta card
                  // Card(
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   elevation: 0,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(12.0),
                  //     child: Column(
                  //       children: [
                  //         _rowLabelValue(
                  //           'Created',
                  //           _formatDate(
                  //             _profile?['created_at']?.toString() ?? '',
                  //           ),
                  //         ),
                  //         const SizedBox(height: 6),
                  //         _rowLabelValue(
                  //           'Updated',
                  //           _formatDate(
                  //             _profile?['updated_at']?.toString() ?? '',
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 18),

                  // Actions
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ElevatedButton.icon(
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: AppColors.primary,
                  //         ),
                  //         onPressed: _fetchProfile,
                  //         icon: const Icon(Icons.refresh),
                  //         label: const Text('Refresh'),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 12),
                  //     Expanded(
                  //       child: OutlinedButton.icon(
                  //         onPressed: () => Navigator.pop(context),
                  //         icon: const Icon(Icons.close),
                  //         label: const Text('Close'),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
    );
  }
}
