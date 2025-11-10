import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/admin/views/side_bar_dashboard/admin_sidebar.dart';

import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/constants/constants.dart';
// import 'package:jobshub/hr/views/hr_comapy_detail.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({super.key});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  List<Map<String, dynamic>> _companies = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse("${ApiConstants.baseUrl}employersCompanies");
      final res = await http.get(uri, headers: {"Accept": "application/json"});

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final List data = (json['data'] as List?) ?? [];
        setState(() {
          _companies = data.cast<Map<String, dynamic>>();
        });
      } else {
        setState(() => _error = "Error ${res.statusCode}");
      }
    } catch (e) {
      setState(() => _error = "Network error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _safeStr(dynamic v) => (v ?? '').toString();
  String _approvalText(dynamic v) {
    final a = int.tryParse(v?.toString() ?? '');
    if (a == 1) return 'Approved';
    if (a == 3) return 'Rejected';
    return 'Pending';
  }

  Color _approvalColor(dynamic v) {
    final a = int.tryParse(v?.toString() ?? '');
    if (a == 1) return Colors.green;
    if (a == 3) return Colors.red;
    return Colors.orange;
  }

  Widget _pill(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.w700),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;

        return AdminDashboardWrapper(
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Companies",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
              ),

              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.all(10),
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
                              OutlinedButton(
                                onPressed: _fetchCompanies,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchCompanies,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: _companies.length,
                            itemBuilder: (context, index) {
                              final c = _companies[index];
                              final approvalTxt = _approvalText(c['approval']);
                              final approvalClr = _approvalColor(c['approval']);

                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.15),
                                    child: Icon(
                                      Icons.business,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  title: Text(
                                    _safeStr(
                                      c['company_name'].toString().isEmpty
                                          ? '—'
                                          : c['company_name'],
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (_safeStr(
                                        c['industry_type'],
                                      ).isNotEmpty)
                                        Text(
                                          "Industry: ${_safeStr(c['industry_type'])}",
                                        ),
                                      if (_safeStr(
                                        c['office_location'],
                                      ).isNotEmpty)
                                        Text(
                                          "Location: ${_safeStr(c['office_location'])}",
                                        ),
                                      if (_safeStr(
                                        c['company_website'],
                                      ).isNotEmpty)
                                        Text(
                                          "Website: ${_safeStr(c['company_website'])}",
                                        ),
                                    ],
                                  ),
                                  trailing: _pill(approvalTxt, approvalClr),
                                  onTap: () {
                                   
                                  },
                                ),
                              );
                            },
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
