import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/users/views/drawer_pages/profile/edit_user_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  String? _error;

  Map<String, dynamic>? _user; // users table
  Map<String, dynamic>? _profile; // employee_profiles table
  bool _hasProfile = false;

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

    try {
      final userIdStr = await SessionManager.getValue('user_id');
      final userId = (userIdStr != null && userIdStr.isNotEmpty)
          ? int.tryParse(userIdStr)
          : null;

      if (userId == null) {
        setState(() {
          _loading = false;
          _error = "User ID not found. Please log in again.";
        });
        return;
      }

      final uri = Uri.parse("${ApiConstants.baseUrl}employeeProfileByUserId");

      final res = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is Map<String, dynamic>) {
          final d = data['data'] as Map<String, dynamic>;
          setState(() {
            _user = (d['user'] as Map?)?.cast<String, dynamic>();
            _profile = (d['profile'] as Map?)?.cast<String, dynamic>();
            _hasProfile = (d['has_profile'] == true);
            _loading = false;
          });
        } else {
          setState(() {
            _loading = false;
            _error = data['message']?.toString() ?? "Failed to fetch profile.";
          });
        }
      } else {
        setState(() {
          _loading = false;
          _error = "Server returned ${res.statusCode}.";
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "Error: $e";
      });
    }
  }

  // Helpers
  String _fullName() {
    final f = (_user?['first_name'] ?? '').toString().trim();
    final l = (_user?['last_name'] ?? '').toString().trim();
    final name = [f, l].where((s) => s.isNotEmpty).join(' ');
    return name.isEmpty ? "—" : name;
  }

  String _roleLabel(int? role) {
    switch (role) {
      case 1:
        return "User";
      case 2:
        return "Employer";
      case 3:
        return "HR";
      default:
        return "Unknown";
    }
  }

  String _approvalLabel(int? code) {
    switch (code) {
      case 1:
        return "Approved";
      case 3:
        return "Rejected";
      case 2:
      default:
        return "Pending";
    }
  }

  Color _approvalColor(int? code) {
    switch (code) {
      case 1:
        return Colors.green;
      case 3:
        return Colors.red;
      case 2:
      default:
        return Colors.orange;
    }
  }

  List<String> _skillsList() {
    final s = (_profile?['skills'] ?? '').toString().trim();
    if (s.isEmpty) return [];
    // Accept comma or pipe separated
    final parts = s.split(RegExp(r'[,\|]')).map((e) => e.trim()).toList();
    return parts.where((p) => p.isNotEmpty).toList();
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDrawerWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 1100; // wide layout when big
          final horizontalPad = isWeb
              ? MediaQuery.of(context).size.width * 0.16
              : 16.0;

          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.white,
              elevation: 1,
              title: const Text(
                "My Profile",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: "Refresh",
                  onPressed: _fetchProfile,
                  icon: const Icon(Icons.refresh, color: Colors.black87),
                ),
              ],
            ),
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? _ErrorState(message: _error!, onRetry: _fetchProfile)
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPad,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _headerCard(isWeb),
                        const SizedBox(height: 20),

                        // Contact
                        _sectionTitle("Contact Information"),
                        _infoTile(
                          Icons.phone,
                          "Mobile",
                          (_user?['mobile'] ?? '—').toString(),
                        ),
                        _infoTile(
                          Icons.email,
                          "Email",
                          (_user?['email'] ?? '—').toString(),
                        ),
                        _infoTile(
                          Icons.badge_outlined,
                          "Role",
                          _roleLabel(_user?['role'] as int?),
                        ),
                        _infoTile(
                          Icons.verified_user,
                          "Account Approval",
                          _approvalLabel(_user?['approval'] as int?),
                        ),

                        if ((_profile?['linkedin_url'] ?? '')
                            .toString()
                            .isNotEmpty)
                          _linkTile(
                            icon: Icons.link,
                            title: "LinkedIn",
                            url: (_profile?['linkedin_url'] ?? '').toString(),
                          ),
                        if ((_profile?['resume_url'] ?? '')
                            .toString()
                            .isNotEmpty)
                          _linkTile(
                            icon: Icons.picture_as_pdf,
                            title: "Resume",
                            url: (_profile?['resume_url'] ?? '').toString(),
                          ),

                        const SizedBox(height: 20),

                        // Education
                        _sectionTitle("Education"),
                        _infoTile(
                          Icons.school,
                          "Education",
                          (_profile?['education'] ?? '—').toString(),
                        ),

                        const SizedBox(height: 20),

                        // Experience
                        _sectionTitle("Experience"),
                        _infoTile(
                          Icons.work_outline,
                          "Experience",
                          (_profile?['experience'] ?? '—').toString(),
                        ),
                        _infoTile(
                          Icons.category_outlined,
                          "Preferred Category",
                          (_profile?['category'] ?? '—').toString(),
                        ),
                        _infoTile(
                          Icons.work_history_outlined,
                          "Preferred Job Type",
                          (_profile?['job_type'] ?? '—').toString(),
                        ),

                        const SizedBox(height: 20),

                        // Skills
                        if (_skillsList().isNotEmpty) ...[
                          _sectionTitle("Skills"),
                          _skillsSection(_skillsList()),
                          const SizedBox(height: 20),
                        ],

                        // Bio
                        if ((_profile?['bio'] ?? '').toString().isNotEmpty) ...[
                          _sectionTitle("About"),
                          _aboutCard((_profile?['bio'] ?? '').toString()),
                          const SizedBox(height: 20),
                        ],

                        // KYC
                        // _sectionTitle("KYC"),
                        // _kycCard(),
                        const SizedBox(height: 20),

                        // Bank
                        _sectionTitle("Bank Details"),
                        _infoTile(
                          Icons.account_circle,
                          "Account Holder",
                          (_profile?['bank_account_name'] ?? '—').toString(),
                        ),
                        _infoTile(
                          Icons.confirmation_number,
                          "Account Number",
                          (_profile?['bank_account_number'] ?? '—').toString(),
                        ),
                        _infoTile(
                          Icons.account_balance_wallet,
                          "IFSC Code",
                          (_profile?['bank_ifsc'] ?? '—').toString(),
                        ),
                        _infoTile(
                          Icons.account_balance,
                          "Bank Name",
                          (_profile?['bank_name'] ?? '—').toString(),
                        ),
                        _infoTile(
                          Icons.location_city,
                          "Branch",
                          (_profile?['bank_branch'] ?? '—').toString(),
                        ),

                        const SizedBox(height: 32),

                        // Edit / Complete button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const UserEditProfilePage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 22,
                            ),
                            label: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                _hasProfile
                                    ? "Edit Profile"
                                    : "Complete Profile",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  // UI Pieces

  Widget _headerCard(bool isWeb) {
    final profileImage = (_user?['profile_image'] ?? '').toString();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: profileImage.isNotEmpty
                ? NetworkImage(profileImage)
                : null,
            child: profileImage.isEmpty
                ? const Icon(Icons.person, size: 42, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            _fullName(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            (_user?['email'] ?? '').toString().isNotEmpty
                ? (_user?['email'] ?? '').toString()
                : (_user?['mobile'] ?? '—').toString(),
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4, top: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  (value.isEmpty) ? "—" : value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _linkTile({
    required IconData icon,
    required String title,
    required String url,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              url,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _openUrl(url),
            child: Text("Open", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _skillsSection(List<String> skills) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: skills
            .map(
              (s) => Chip(
                label: Text(s, style: const TextStyle(color: Colors.white)),
                backgroundColor: AppColors.primary.withOpacity(0.90),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _aboutCard(String bio) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        bio,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _kycCard() {
    final panUrl = (_profile?['kyc_pan'] ?? '').toString();
    final aadhaarUrl = (_profile?['kyc_aadhaar'] ?? '').toString();
    final kycApproval = _profile?['kyc_approval'] as int?;
    final kycText = _approvalLabel(kycApproval);
    final kycColor = _approvalColor(kycApproval);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.assignment_turned_in, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                "KYC Status: $kycText",
                style: TextStyle(fontWeight: FontWeight.w600, color: kycColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (panUrl.isNotEmpty) _kycRow("PAN PDF", panUrl),
          if (aadhaarUrl.isNotEmpty) _kycRow("Aadhaar PDF", aadhaarUrl),
          if (panUrl.isEmpty && aadhaarUrl.isEmpty)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "No KYC PDFs uploaded yet.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _kycRow(String label, String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _openUrl(url),
            child: Text("View", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  "Retry",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
