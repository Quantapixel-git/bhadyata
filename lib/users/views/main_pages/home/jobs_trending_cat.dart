// trending_category_jobs_page.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/main_pages/search/job_detail_page.dart';

class TrendingCategoryJobsPage extends StatefulWidget {
  final String category;
  const TrendingCategoryJobsPage({super.key, required this.category});

  @override
  State<TrendingCategoryJobsPage> createState() =>
      _TrendingCategoryJobsPageState();
}

class _TrendingCategoryJobsPageState extends State<TrendingCategoryJobsPage> {
  bool _loading = false;
  String? _error;
  List<Map<String, dynamic>> _jobs = [];

  // filtering / UI state (kept same as CategoryJobsPage)
  List<Map<String, dynamic>> _visibleJobs = [];
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;
  String _keyword = '';
  String _sort = 'newest';

  String _approvalFilter = '1';
  final Set<String> _selectedJobTypes = {};
  String _experienceFilter = 'any';
  String _locationFilter = '';
  RangeValues _salaryRange = const RangeValues(0, 100000);

  final Set<String> _jobTypes = {};
  final Set<String> _experienceLevels = {};

  // pagination - client side
  int _perPage = 10;
  int _page = 1;

  int get _totalItems => _filteredItems.length;
  int get _lastPage =>
      _perPage > 0 ? ((_totalItems + _perPage - 1) ~/ _perPage) : 1;

  String _profileJobType = '';
  List<Map<String, dynamic>> _filteredItems = [];

  // per-item applying set (new)
  final Set<String> _applyingJobIds = {};

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _initAndFetch();
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      setState(() {
        _keyword = _searchCtrl.text.trim().toLowerCase();
        _page = 1;
        _applyFilters();
      });
    });
  }

  Future<void> _initAndFetch() async {
    // read and normalize stored job_type so pages behave consistently
    final storedRaw = (await SessionManager.getValue('job_type')) ?? '';
    String normalized = storedRaw.toString().trim();

    // Normalize common variants into canonical labels (keeps only for local decision)
    final low = normalized.toLowerCase();
    if (low.contains('commission') || low.contains('commision')) {
      normalized = 'Commission-based';
    } else if (low.contains('salary')) {
      normalized = 'Salary-based';
    } else if (low.contains('one') ||
        low.contains('one-time') ||
        low.contains('onetime') ||
        low.contains('one time')) {
      normalized = 'One-time';
    } else if (low.contains('project') ||
        low.contains('projects') ||
        low.contains('freelance')) {
      normalized = 'Project';
    }
    setState(() => _profileJobType = normalized);

    await _fetchJobsForCategory();
  }

  Future<void> _refresh() async => _fetchJobsForCategory();

  Future<void> _fetchJobsForCategory() async {
    setState(() {
      _loading = true;
      _error = null;
      _jobs = [];
      _visibleJobs = [];
      _jobTypes.clear();
      _experienceLevels.clear();
      _selectedJobTypes.clear();
      _experienceFilter = 'any';
      _locationFilter = '';
      _salaryRange = const RangeValues(0, 100000);
      _page = 1;
      _filteredItems = [];
    });

    final jtLower = _profileJobType.toLowerCase();
    // final jtLower = _profileJobType.toLowerCase();
    String endpoint;

    // tolerant matching — handle common misspellings and variants
    if (jtLower.contains('commission') ||
        jtLower.contains('commision') ||
        jtLower.contains('commission-based')) {
      endpoint = 'commissionJobsByCategory';
    } else if (jtLower.contains('one') ||
        jtLower.contains('one-time') ||
        jtLower.contains('one time') ||
        jtLower.contains('onetime')) {
      endpoint = 'oneTimeJobsByCategory';
    } else if (jtLower.contains('project') ||
        jtLower.contains('projects') ||
        jtLower.contains('freelance') ||
        jtLower.contains('it')) {
      endpoint = 'getProjectsByCategory';
    } else {
      endpoint = 'salaryJobsByCategory';
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    if (kDebugMode) {
      print(
        '🔁 TrendingCategoryJobs -> storedRaw (Session): ${await SessionManager.getValue('job_type')}',
      );
      print('🔁 Normalized _profileJobType: $_profileJobType');
      print('🔁 jtLower: $jtLower');
      print('🔁 Selected endpoint: $endpoint');
      print('🔁 Full URL: $uri');
      print('🔁 POST body: ${jsonEncode({'category': widget.category})}');
    }

    try {
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'category': widget.category}),
      );

      if (kDebugMode) {
        print('⬅️ Status: ${res.statusCode}');
        print('⬅️ Body: ${res.body}');
      }

      if (res.statusCode < 200 || res.statusCode >= 300) {
        setState(() => _error = 'Failed (${res.statusCode})');
        return;
      }

      final raw = jsonDecode(res.body);
      final success =
          (raw is Map && ((raw['success'] == true) || (raw['status'] == 1)));
      if (!success) {
        setState(
          () => _error = raw is Map
              ? (raw['message']?.toString() ?? 'API error')
              : 'Unexpected response',
        );
        return;
      }

      final List data = (raw['data'] as List? ?? []);
      final parsed = data.map<Map<String, dynamic>>((e) {
        if (e is Map<String, dynamic>) return e;
        return Map<String, dynamic>.from(e as Map);
      }).toList();

      // derive ranges/types similar to CategoryJobsPage
      double minSalary = double.infinity;
      double maxSalary = 0;
      for (final p in parsed) {
        final jt = (p['job_type'] ?? '').toString().trim();
        if (jt.isNotEmpty) _jobTypes.add(jt);

        final exp = (p['experience_required'] ?? '').toString().trim();
        if (exp.isNotEmpty) _experienceLevels.add(exp);

        final smin = double.tryParse((p['salary_min'] ?? '').toString()) ?? 0.0;
        final smax = double.tryParse((p['salary_max'] ?? '').toString()) ?? 0.0;
        if (smin > 0) minSalary = smin < minSalary ? smin : minSalary;
        if (smax > 0) maxSalary = smax > maxSalary ? smax : maxSalary;
      }

      if (minSalary == double.infinity) minSalary = 0.0;
      if (maxSalary == 0 && minSalary > 0) maxSalary = minSalary;
      if (maxSalary == 0 && minSalary == 0) {
        minSalary = 0;
        maxSalary = 100000;
      }

      setState(() {
        _jobs = parsed;
        _salaryRange = RangeValues(
          minSalary,
          maxSalary == 0 ? minSalary : maxSalary,
        );
        _filteredItems = List.from(parsed);
      });

      _applyFilters();
    } catch (e, st) {
      if (kDebugMode) print('❌ fetch error: $e\n$st');
      setState(() => _error = 'Exception: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    List<Map<String, dynamic>> items = List.from(_jobs);

    // approval
    if (_approvalFilter != 'all') {
      items = items
          .where((it) => it['approval']?.toString() == _approvalFilter)
          .toList();
    }

    // job type multi-select
    if (_selectedJobTypes.isNotEmpty) {
      items = items
          .where(
            (it) =>
                _selectedJobTypes.contains((it['job_type'] ?? '').toString()),
          )
          .toList();
    }

    // experience filter
    if (_experienceFilter != 'any') {
      items = items
          .where(
            (it) =>
                (it['experience_required'] ?? '').toString() ==
                _experienceFilter,
          )
          .toList();
    }

    // location filter
    if (_locationFilter.trim().isNotEmpty) {
      final loc = _locationFilter.trim().toLowerCase();
      items = items
          .where(
            (it) =>
                (it['location'] ?? '').toString().toLowerCase().contains(loc),
          )
          .toList();
    }

    // salary range
    items = items.where((it) {
      final a = double.tryParse((it['salary_min'] ?? '').toString()) ?? 0.0;
      final b = double.tryParse((it['salary_max'] ?? '').toString()) ?? 0.0;
      final low = _salaryRange.start;
      final high = _salaryRange.end;
      if (a == 0 && b == 0) return true;
      final within =
          (a >= low && a <= high) ||
          (b >= low && b <= high) ||
          (a <= low && b >= high);
      return within;
    }).toList();

    // keyword search
    final q = _keyword.trim().toLowerCase();
    if (q.isNotEmpty) {
      items = items.where((it) {
        final title = (it['title'] ?? '').toString().toLowerCase();
        final skills = (it['skills'] ?? '').toString().toLowerCase();
        final location = (it['location'] ?? '').toString().toLowerCase();
        return title.contains(q) || skills.contains(q) || location.contains(q);
      }).toList();
    }

    // sorting
    items.sort((a, b) {
      if (_sort == 'newest' || _sort == 'oldest') {
        final da =
            DateTime.tryParse(a['created_at']?.toString() ?? '') ??
            DateTime(1970);
        final db =
            DateTime.tryParse(b['created_at']?.toString() ?? '') ??
            DateTime(1970);
        return _sort == 'newest' ? db.compareTo(da) : da.compareTo(db);
      } else {
        final sa =
            (double.tryParse((a['salary_max'] ?? '').toString()) ??
            double.tryParse((a['salary_min'] ?? '').toString()) ??
            0.0);
        final sb =
            (double.tryParse((b['salary_max'] ?? '').toString()) ??
            double.tryParse((b['salary_min'] ?? '').toString()) ??
            0.0);
        return _sort == 'salary_high' ? sb.compareTo(sa) : sa.compareTo(sb);
      }
    });

    _filteredItems = items;
    final start = (_page - 1) * _perPage;
    final end = start + _perPage;
    final paged = items.sublist(start, items.length < end ? items.length : end);

    setState(() {
      _visibleJobs = paged;
    });
  }

  void _setPage(int p) {
    if (p < 1) p = 1;
    if (p > _lastPage) p = _lastPage;
    if (p == _page) return;
    setState(() {
      _page = p;
      _applyFilters();
    });
  }

  void _openJobDetail(Map<String, String> job) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JobDetailPage(job: job)),
    );
  }

  // -----------------------
  // Apply logic (copied/adapted from CategoryJobsPage)
  // -----------------------
  Future<void> _applyForJob(Map<String, String> job) async {
    final jobId = job['id'] ?? job['job_id'] ?? '';
    if (jobId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Job id missing')));
      return;
    }

    if (_applyingJobIds.contains(jobId)) return;

    final emp = await SessionManager.getValue('user_id') ?? '';
    final employeeId = emp.toString();
    if (employeeId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Employee not logged in')));
      return;
    }

    final jtLower = _profileJobType.toLowerCase();
    String endpoint;
    if (jtLower.contains('salary')) {
      endpoint = 'applySalayBased';
    } else if (jtLower.contains('commission') ||
        jtLower.contains('commision') ||
        jtLower.contains('commission-based')) {
      endpoint = 'applyCommissionBased';
    } else if (jtLower.contains('one') ||
        jtLower.contains('one-time') ||
        jtLower.contains('onetime') ||
        jtLower.contains('one time')) {
      endpoint = 'applyOneTimeBased';
    } else if (jtLower.contains('project') ||
        jtLower.contains('projects') ||
        jtLower.contains('freelance')) {
      endpoint = 'applyProject';
    } else {
      endpoint = 'applySalayBased';
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final body = {
      "job_id": jobId,
      "employee_id": employeeId,
      "remarks": "Available for the job.",
    };

    setState(() => _applyingJobIds.add(jobId));
    if (kDebugMode) {
      print(
        '➡️ Applying to $jobId via $endpoint with body: ${jsonEncode(body)}',
      );
    }

    try {
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (kDebugMode) {
        print('⬅️ Apply status: ${res.statusCode}');
        print('⬅️ Apply body: ${res.body}');
      }

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final jsonBody = jsonDecode(res.body) as Map<String, dynamic>;
        final success = jsonBody['success'] == true || jsonBody['status'] == 1;
        final message = jsonBody['message']?.toString() ?? 'Response received';

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));

        // Optionally mark job as applied locally here
      } else {
        String msg = 'Failed to apply (${res.statusCode})';
        try {
          final bodyJson = jsonDecode(res.body);
          if (bodyJson is Map && bodyJson['message'] != null) {
            msg = bodyJson['message'].toString();
          }
        } catch (_) {}
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e, st) {
      if (kDebugMode) print('❌ apply error: $e\n$st');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error applying: $e')));
    } finally {
      setState(() => _applyingJobIds.remove(jobId));
    }
  }

  bool _isApplying(String jobId) => _applyingJobIds.contains(jobId);

  @override
  Widget build(BuildContext context) {
    // Responsive breakpoints
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1000;
    final bool isDesktop = width >= 1000;

    final sidePadding = isDesktop ? 56.0 : (isTablet ? 24.0 : 12.0);

    final showingFrom = _totalItems == 0 ? 0 : ((_page - 1) * _perPage) + 1;
    final showingTo = ((_page * _perPage) > _totalItems)
        ? _totalItems
        : (_page * _perPage);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: true,
        elevation: 2,
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: sidePadding),
        child: Column(
          children: [
            // optional search row for larger widths
            if (!isMobile)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Search jobs...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _sort,
                      items: const [
                        DropdownMenuItem(
                          value: 'newest',
                          child: Text('Newest'),
                        ),
                        DropdownMenuItem(
                          value: 'oldest',
                          child: Text('Oldest'),
                        ),
                        DropdownMenuItem(
                          value: 'salary_high',
                          child: Text('Salary high'),
                        ),
                        DropdownMenuItem(
                          value: 'salary_low',
                          child: Text('Salary low'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _sort = v);
                        _applyFilters();
                      },
                    ),
                  ],
                ),
              ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: _buildBody(isMobile, isTablet, isDesktop),
              ),
            ),

            if (_totalItems > 0)
              Container(
                padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Text(
                      'Showing $showingFrom - $showingTo of $_totalItems',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const Spacer(),

                    IconButton(
                      tooltip: 'Previous',
                      onPressed: (_page > 1 && !_loading)
                          ? () => _setPage(_page - 1)
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    SizedBox(
                      width: 36,
                      child: TextFormField(
                        initialValue: '$_page',
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (v) {
                          final p = int.tryParse(v) ?? _page;
                          _setPage(p.clamp(1, _lastPage));
                        },
                      ),
                    ),
                    Text(' / $_lastPage'),
                    IconButton(
                      tooltip: 'Next',
                      onPressed: ((_page < _lastPage) && !_loading)
                          ? () => _setPage(_page + 1)
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(bool isMobile, bool isTablet, bool isDesktop) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 8),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _fetchJobsForCategory,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_visibleJobs.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Center(child: Text('No jobs match your filters.')),
        ],
      );
    }

    // Desktop: grid with 2 columns; Tablet: single column list with wider padding; Mobile: single column list
    if (isDesktop) {
      return GridView.builder(
        padding: const EdgeInsets.only(bottom: 18),
        shrinkWrap: false,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _visibleJobs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 3.2,
        ),
        itemBuilder: (context, idx) {
          final j = _visibleJobs[idx];
          final jobMap = j.map(
            (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
          );
          return JobCard(
            job: jobMap,
            onTap: () => _openJobDetail(jobMap),
            onApply: () => _applyForJob(jobMap),
            isApplying: _isApplying(jobMap['id'] ?? jobMap['job_id'] ?? ''),
          );
        },
      );
    } else {
      // mobile/tablet list
      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 18),
        itemCount: _visibleJobs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final j = _visibleJobs[index];
          final jobMap = j.map(
            (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
          );
          return JobCard(
            job: jobMap,
            onTap: () => _openJobDetail(jobMap),
            onApply: () => _applyForJob(jobMap),
            isApplying: _isApplying(jobMap['id'] ?? jobMap['job_id'] ?? ''),
          );
        },
      );
    }
  }
}

/// JobCard with Apply + View buttons and responsive layout
class JobCard extends StatefulWidget {
  final Map<String, String> job;
  final VoidCallback onTap;
  final VoidCallback onApply;
  final bool isApplying;

  JobCard({
    super.key,
    required Map<String, dynamic> job,
    required this.onTap,
    required this.onApply,
    this.isApplying = false,
  }) : job = job.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.job;
    final title = m['title'] ?? 'Untitled';
    final salaryMin = m['salary_min'] ?? '';
    final salaryMax = m['salary_max'] ?? '';
    final salaryType = m['salary_type'] ?? '';
    final jobType = m['job_type'] ?? '';
    final experience = m['experience_required'] ?? '';
    final location = m['location'] ?? '';
    final openings = m['openings'] ?? '';
    final skillsRaw = m['skills'] ?? '';

    final salaryText = (salaryMin.isNotEmpty || salaryMax.isNotEmpty)
        ? (salaryMin == salaryMax
              ? '₹$salaryMin / $salaryType'
              : '₹$salaryMin - ₹$salaryMax / $salaryType')
        : 'Not specified';

    final skills = skillsRaw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .take(6)
        .toList();

    // We'll adapt layout based on max width of card via LayoutBuilder
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final bool narrow = maxW < 520; // stack vertically for narrow cards
        final bool wideScreen = MediaQuery.of(context).size.width > 900;

        Widget icon = Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.work_outline, color: AppColors.primary, size: 34),
        );

        Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // meta row
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(color: Colors.grey.shade700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (experience.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Icon(Icons.timeline, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      experience,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    salaryText,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                if (jobType.isNotEmpty) ...[
                  Icon(
                    Icons.work_outline,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      jobType,
                      style: TextStyle(color: Colors.grey.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const SizedBox(width: 6),
                const Text(" | "),
                const SizedBox(width: 6),
                if (openings.isNotEmpty)
                  Flexible(
                    child: Text(
                      '$openings openings',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: skills.map((s) => _skillChip(s)).toList(),
            ),
          ],
        );

        Widget actionsColumn = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatDate(
                widget.job['application_deadline'] ?? widget.job['created_at'],
              ),
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 84,
              height: 36,
              child: ElevatedButton(
                onPressed: () => _onViewPressed(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'View',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 84,
              height: 36,
              child: widget.isApplying
                  ? const Center(
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () => _onApplyPressed(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
            ),
          ],
        );

        Widget actionsRow = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () => _onViewPressed(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'View',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 36,
              child: widget.isApplying
                  ? const Center(
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () => _onApplyPressed(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );

        // full card child
        Widget cardChild;
        if (narrow) {
          // stacked variant: icon + content, then actions row to the bottom (buttons side-by-side)
          cardChild = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  icon,
                  const SizedBox(width: 12),
                  Expanded(child: content),
                ],
              ),
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerRight, child: actionsRow),
            ],
          );
        } else {
          // horizontal: icon + content + actions column
          cardChild = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(width: 12),
              Expanded(child: content),
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
                child: actionsColumn,
              ),
            ],
          );
        }

        final card = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            elevation: 3,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: cardChild,
              ),
            ),
          ),
        );

        if (wideScreen) {
          return MouseRegion(
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              transform: _hover
                  ? (Matrix4.identity()..translate(0, -3))
                  : Matrix4.identity(),
              child: card,
            ),
          );
        }
        return card;
      },
    );
  }

  void _onApplyPressed() {
    widget.onApply();
  }

  void _onViewPressed() {
    widget.onTap();
  }

  Widget _skillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  String _formatDate(String? d) {
    if (d == null || d.isEmpty) return '';
    try {
      final dt = DateTime.parse(d);
      final fmt = DateFormat('dd MMM');
      return fmt.format(dt);
    } catch (_) {
      return d;
    }
  }
}
