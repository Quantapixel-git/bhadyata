import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class ApprovedCompaniesPage extends StatelessWidget {
  ApprovedCompaniesPage({super.key});

  // Demo data
  final List<Map<String, String>> approvedCompanies = [
    {"name": "ABC Ltd", "approvedBy": "HR John"},
    {"name": "XYZ Corp", "approvedBy": "Admin Mary"},
    {"name": "Tech Solutions", "approvedBy": "HR Alice"},
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isWeb = width >= 900;

    return AdminDashboardWrapper(
      child: Column(
        children: [
          // ✅ Responsive AppBar
          AppBar(
            automaticallyImplyLeading: !isWeb, // hide drawer icon on web
            title: const Text(
              "Approved Companies",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primary,
          ),

          // ✅ Responsive Content
          Expanded(child: _buildContent(isWeb)),
        ],
      ),
    );
  }

  Widget _buildContent(bool isWeb) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey[100],
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mobile Header
              if (!isWeb)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Approved Company List",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

              // ✅ Scrollable list with safe layout
              Expanded(
                child: ListView.builder(
                  itemCount: approvedCompanies.length,
                  itemBuilder: (context, index) {
                    final company = approvedCompanies[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: const Icon(
                            Icons.business,
                            color: Colors.green,
                          ),
                        ),
                        title: Text(
                          company['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "Approved by: ${company['approvedBy'] ?? ''}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
