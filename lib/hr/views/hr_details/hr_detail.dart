import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/constants.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_side_bar.dart';

class HrDetailsPage extends StatefulWidget {
  const HrDetailsPage({super.key});

  @override
  State<HrDetailsPage> createState() => _HrDetailsPageState();
}

class _HrDetailsPageState extends State<HrDetailsPage> {
  late Future<Map<String, dynamic>?> _hrFuture;

  @override
  void initState() {
    super.initState();
    _hrFuture = fetchHrDetails();
  }

  // 🧩 API CALL — getHrProfileByUserId
  Future<Map<String, dynamic>?> fetchHrDetails() async {
    final userId = await SessionManager.getValue('hr_id');
    final url = Uri.parse("${ApiConstants.baseUrl}getHrProfileByUserId");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        } else {
          debugPrint("⚠️ API returned error: ${data['message']}");
          return null;
        }
      } else {
        debugPrint("❌ HTTP Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
      return null;
    }
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
                  "HR Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),

              // ✅ Body Section
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: FutureBuilder<Map<String, dynamic>?>(
                    future: _hrFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text("No HR details found"));
                      }

                      final hr = snapshot.data!;
                      return _buildHrDetails(isWeb, hr);
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

  Widget _buildHrDetails(bool isWeb, Map<String, dynamic> hr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👤 HR Avatar Placeholder
              Row(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage('assets/job_bgr.png'),
                  ),
                    const SizedBox(width: 16),
                  Text(
                    "HR Profile",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // const SizedBox(height: 24),

              // 🧾 HR Info Card
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
                      InfoRow(
                        title: "Position Title",
                        value: hr['position_title'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Experience (Years)",
                        value: hr['experience_years']?.toString() ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "LinkedIn",
                        value: hr['linkedin_url'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(title: "Bio", value: hr['bio'] ?? "-"),
                      const Divider(),
                      InfoRow(
                        title: "Bank Name",
                        value: hr['bank_name'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(title: "Branch", value: hr['bank_branch'] ?? "-"),
                      const Divider(),
                      InfoRow(
                        title: "Account Holder",
                        value: hr['bank_account_name'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Account Number",
                        value: hr['bank_account_number'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Account No.",
                        value: hr['bank_account_number'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "IFSC Code",
                        value: hr['bank_ifsc'] ?? "-",
                      ),

                      // "bank_branch": "dfghj",
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ✏️ Edit Button
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     icon: const Icon(Icons.edit),
              //     label: const Text("Edit HR Details"),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.primary,
              //       foregroundColor: Colors.white,
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       elevation: 2,
              //     ),
              //     onPressed: () {
              //       // TODO: Navigate to HR Edit Page
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({super.key, required this.title, required this.value});

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
