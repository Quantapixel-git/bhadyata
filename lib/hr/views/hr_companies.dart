import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/constants/constants.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_side_bar.dart';

class HrCompanies extends StatefulWidget {
  const HrCompanies({super.key});

  @override
  State<HrCompanies> createState() => _HrCompaniesState();
}

class _HrCompaniesState extends State<HrCompanies> {
  List<Map<String, dynamic>> _companies = [];
  bool _loading = true;
  String? _error;

  // ---- UI state ----
  final TextEditingController _search = TextEditingController();
  _ApprovalFilter _filter = _ApprovalFilter.all;

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
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

  // ---- helpers ----
  String _safeStr(dynamic v) {
    if (v == null) return '—';
    final s = v.toString().trim();
    return s.isEmpty ? '—' : s;
  }

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
    return Colors.orange; // pending / unknown
  }

  bool _matchesFilter(Map<String, dynamic> c) {
    final status = _approvalText(c['approval']);
    switch (_filter) {
      case _ApprovalFilter.all:
        return true;
      case _ApprovalFilter.approved:
        return status == 'Approved';
      case _ApprovalFilter.pending:
        return status == 'Pending';
      case _ApprovalFilter.rejected:
        return status == 'Rejected';
    }
  }

  bool _matchesSearch(Map<String, dynamic> c) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return true;
    final hay = [
      c['company_name'],
      c['industry_type'],
      c['office_location'],
      c['company_website'],
      c['designation'],
      c['about_company'],
    ].whereType<Object?>().map((e) => e.toString().toLowerCase());
    return hay.any((e) => e.contains(q));
  }

  int _gridCount(double width) {
    if (width >= 1400) return 4;
    if (width >= 1100) return 3;
    if (width >= 750) return 2;
    return 1;
  }

  Future<void> _launchWebsite(String url) async {
    final s = url.trim();
    if (s.isEmpty || s == '—') return;
    final uri = Uri.tryParse(s.startsWith('http') ? s : 'https://$s');
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,

          content: Text('Could not open website'),
        ),
      );
    }
  }

  // ---- widgets ----
  Widget _noteBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE0A3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Note: These are Companies of Registered Employers (with employer profile approval status).",
              style: TextStyle(
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBar() {
    Chip _f(String label, _ApprovalFilter f) => Chip(
      label: Text(label),
      backgroundColor: _filter == f
          ? AppColors.primary.withOpacity(.12)
          : Colors.grey.shade100,
      side: BorderSide(
        color: _filter == f ? AppColors.primary : Colors.grey.shade300,
      ),
      labelStyle: TextStyle(
        color: _filter == f ? AppColors.primary : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 280,
          child: TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              isDense: true,
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _search.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear),
                    ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _filter = _ApprovalFilter.all),
          child: _f('All', _ApprovalFilter.all),
        ),
        GestureDetector(
          onTap: () => setState(() => _filter = _ApprovalFilter.approved),
          child: _f('Approved', _ApprovalFilter.approved),
        ),
        GestureDetector(
          onTap: () => setState(() => _filter = _ApprovalFilter.pending),
          child: _f('Pending', _ApprovalFilter.pending),
        ),
        GestureDetector(
          onTap: () => setState(() => _filter = _ApprovalFilter.rejected),
          child: _f('Rejected', _ApprovalFilter.rejected),
        ),
      ],
    );
  }

  Widget _statusPill(dynamic approval) {
    final txt = _approvalText(approval);
    final clr = _approvalColor(approval);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: clr.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: clr.withOpacity(0.3)),
      ),
      child: Text(
        txt,
        style: TextStyle(color: clr, fontWeight: FontWeight.w700),
      ),
    );
  }

  void _openDetails(Map<String, dynamic> c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final bool isWeb = MediaQuery.of(context).size.width > 900;

        Widget row(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  k,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(v)),
            ],
          ),
        );
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, controller) => Center(
            // ✅ added
            child: Container(
              // ✅ added width control
              constraints: BoxConstraints(
                maxWidth: isWeb
                    ? 700
                    : double.infinity, // ✅ wider sheet for web
              ),
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: controller,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: Icon(Icons.business, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _safeStr(c['company_name']),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                if (_safeStr(c['industry_type']) != '—')
                                  Chip(
                                    label: Text(
                                      'Industry: ${_safeStr(c['industry_type'])}',
                                    ),
                                  ),
                                if (_safeStr(c['office_location']) != '—')
                                  Chip(
                                    label: Text(
                                      'Location: ${_safeStr(c['office_location'])}',
                                    ),
                                  ),
                                _statusPill(c['approval']),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  // row('ID', _safeStr(c['id'])),
                  // row('User ID', _safeStr(c['user_id'])),
                  // row('Designation', _safeStr(c['designation'])),
                  row('Company Size', _safeStr(c['company_size'])),
                  row('Website', _safeStr(c['company_website'])),
                  row('About Company', _safeStr(c['about_company'])),
                  // row('Approval (raw)', _safeStr(c['approval'])),
                  // row('Created At', _safeStr(c['created_at'])),
                  // row('Updated At', _safeStr(c['updated_at'])),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () =>
                          _launchWebsite(_safeStr(c['company_website'])),
                      icon: const Icon(Icons.open_in_new, color: Colors.white),
                      label: const Text(
                        'Open Website',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _companyCard(Map<String, dynamic> c) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openDetails(c),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: Icon(Icons.business, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _safeStr(c['company_name']),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Text('Employer: '),
                          Text(
                            _safeStr(c['designation']) == '—'
                                ? _safeStr(c['industry_type'])
                                : _safeStr(c['designation']),
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _statusPill(c['approval']),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _infoChip(Icons.category, _safeStr(c['industry_type'])),
                _infoChip(Icons.location_on, _safeStr(c['office_location'])),
                _infoChip(Icons.people_alt, _safeStr(c['company_size'])),
                GestureDetector(
                  onTap: () => _launchWebsite(_safeStr(c['company_website'])),
                  child: _infoChip(Icons.link, _safeStr(c['company_website'])),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Register: ${_safeStr(c['created_at'])}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(text)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = constraints.maxWidth >= 900;
        final width = constraints.maxWidth;

        // filter + search
        final filtered = _companies
            .where((c) => _matchesFilter(c) && _matchesSearch(c))
            .toList();

        return HrDashboardWrapper(
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
                  padding: const EdgeInsets.all(12),
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
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(child: _noteBanner()),
                              SliverToBoxAdapter(
                                child: Row(
                                  children: [
                                    Expanded(child: _filterBar()),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Text(
                                        '${filtered.length} / ${_companies.length} shown',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (filtered.isEmpty)
                                const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(
                                    child: Text(
                                      'No companies match your filters.',
                                    ),
                                  ),
                                )
                              else
                                SliverPadding(
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    bottom: 24,
                                  ),
                                  sliver: SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: _gridCount(width),
                                          mainAxisSpacing: 12,
                                          crossAxisSpacing: 12,
                                          childAspectRatio: 1.6,
                                        ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, i) => _companyCard(filtered[i]),
                                      childCount: filtered.length,
                                    ),
                                  ),
                                ),
                            ],
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

enum _ApprovalFilter { all, approved, pending, rejected }
