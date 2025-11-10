import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/constants/constants.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_sidebar.dart';

class CompanyDetailsPage extends StatefulWidget {
  const CompanyDetailsPage({super.key});

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  late Future<Map<String, dynamic>?> _companyFuture;

  @override
  void initState() {
    super.initState();
    _companyFuture = fetchCompanyDetails();
  }

  // 🧩 API CALL — getEmployerProfileByUserId
  Future<Map<String, dynamic>?> fetchCompanyDetails() async {
    final userId = await SessionManager.getValue('employer_id');
    final url = Uri.parse("${ApiConstants.baseUrl}getEmployerProfileByUserId");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Map<String, dynamic>.from(data['data'] as Map);
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

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Company Details",
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
                    future: _companyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                          child: Text("No company details found"),
                        );
                      }

                      final company = snapshot.data!;
                      return _buildCompanyDetails(isWeb, company);
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

  Widget _buildCompanyDetails(bool isWeb, Map<String, dynamic> company) {
    final logoUrl = company['company_logo_url']?.toString(); // optional

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🏢 Header avatar + title (matches HRDetailsPage style)
              Row(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: (logoUrl != null && logoUrl.isNotEmpty)
                        ? NetworkImage(logoUrl)
                        : const AssetImage('assets/job_bgr.png')
                              as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Company Profile",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 🗂️ Details Card (same visual language as HR)
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
                        title: "Company Name",
                        value: company['company_name'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Industry Type",
                        value: company['industry_type'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Company Size",
                        value: company['company_size'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Designation",
                        value: company['designation'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Website",
                        value: company['company_website'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Office Location",
                        value: company['office_location'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "About Company",
                        value: company['about_company'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Bank Name",
                        value: company['bank_name'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Branch",
                        value: company['bank_branch'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Account Holder",
                        value: company['bank_account_name'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "Account Number",
                        value: company['bank_account_number'] ?? "-",
                      ),
                      const Divider(),
                      InfoRow(
                        title: "IFSC Code",
                        value: company['bank_ifsc'] ?? "-",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // (Optional) Edit Button — uncomment and wire when ready
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     icon: const Icon(Icons.edit),
              //     label: const Text("Edit Company Details"),
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
              //       // TODO: Navigate to edit company details
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

// Same row widget style/spacing as HRDetailsPage
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
            width: 150, // match HR page label width for perfect alignment
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
