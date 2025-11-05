import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/constants.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/model/employer_profile_model.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_side_bar.dart';

class EmployerProfilePage extends StatefulWidget {
  const EmployerProfilePage({super.key});

  @override
  State<EmployerProfilePage> createState() => _EmployerProfilePageState();
}

class _EmployerProfilePageState extends State<EmployerProfilePage> {
  late Future<EmployerProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchEmployerProfile();
  }

  // 🧩 API CALL - getProfileById
  Future<EmployerProfile?> fetchEmployerProfile() async {
    final userId = await SessionManager.getValue('employer_id');

    final url = Uri.parse("${ApiConstants.baseUrl}getProfileById");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return EmployerProfile.fromJson(data['data']);
      } else {
        debugPrint("⚠️ API error: ${data['message']}");
        return null;
      }
    } else {
      debugPrint("❌ HTTP error: ${response.statusCode}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
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
                  child: FutureBuilder<EmployerProfile?>(
                    future: _profileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text("No profile found"));
                      }

                      final user = snapshot.data!;
                      return _buildProfileContent(isWeb, user);
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

  Widget _buildProfileContent(bool isWeb, EmployerProfile user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👤 Profile Picture
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: user.profileImage != null
                        ? NetworkImage(user.profileImage!)
                        : const AssetImage('assets/job_bgr.png')
                              as ImageProvider,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🧑‍💼 Name
              Text(
                "${user.firstName} ${user.lastName}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Employer ID: ${user.id}",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              // 🗂️ Profile Info Card
              Container(
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
                      ProfileInfoRow(
                        title: "Full Name",
                        value: "${user.firstName} ${user.lastName}",
                      ),
                      const Divider(),
                      ProfileInfoRow(title: "Email", value: user.email),
                      const Divider(),
                      ProfileInfoRow(
                        title: "Referral Code",
                        value: user.referralCode ?? "-",
                      ),
                      const Divider(),
                      // ProfileInfoRow(
                      //   title: "Referred By",
                      //   value: user.referredBy ?? "-",
                      // ),
                      // const Divider(),
                      ProfileInfoRow(
                        title: "Status",
                        value: user.status == 1 ? "Active" : "Inactive",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ✏️ Edit Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {},
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
            width: 120,
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
