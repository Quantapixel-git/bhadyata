import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/employer/views/drawer_dashboard/employer_side_bar.dart';

class CompanyDetailsPage extends StatelessWidget {
  const CompanyDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return EmployerDashboardWrapper(
          child: Column(
            children: [
              // ✅ Consistent AppBar like AdminDashboard
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading:
                    !isWeb, // ✅ hide drawer icon on web
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

              // ✅ Main body content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 🏢 Company Logo
                          const CircleAvatar(
                            radius: 55,
                            backgroundImage: AssetImage('assets/job_bgr.png'),
                          ),
                          const SizedBox(height: 16),

                          // 🧾 Company Name
                          const Text(
                            "ABC Pvt. Ltd.",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 🗂️ Company Info Card
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
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  InfoRow(
                                    title: "Company Name",
                                    value: "ABC Pvt. Ltd.",
                                  ),
                                  Divider(),
                                  InfoRow(
                                      title: "Industry",
                                      value: "IT & Software"),
                                  Divider(),
                                  InfoRow(
                                    title: "Company Size",
                                    value: "50–100 Employees",
                                  ),
                                  Divider(),
                                  InfoRow(
                                      title: "Established", value: "2018"),
                                  Divider(),
                                  InfoRow(
                                      title: "Email", value: "info@abc.com"),
                                  Divider(),
                                  InfoRow(
                                      title: "Phone", value: "+91 9812345678"),
                                  Divider(),
                                  InfoRow(
                                    title: "Address",
                                    value:
                                        "123 Business Avenue, Gurugram, Haryana",
                                  ),
                                  Divider(),
                                  InfoRow(
                                      title: "Website", value: "www.abc.com"),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // ✏️ Edit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.edit),
                              label:
                                  const Text("Edit Company Details"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () {
                                // TODO: Navigate to edit company details
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
            width: 130,
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
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
