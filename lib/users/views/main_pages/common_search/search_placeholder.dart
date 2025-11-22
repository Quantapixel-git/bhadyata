import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/main_pages/search/job_detail_page.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  final ScrollController _scrollCtrl = ScrollController();

  bool _loading = false;
  String? _error;
  List<Map<String, dynamic>> _results = [];
  String _storedJobType = '';

  // pagination meta
  int _page = 1;
  int _perPage = 20;
  int _total = 0;
  String _lastQuery = '';

  // per-item applying set
  final Set<String> _applyingJobIds = {};

  @override
  void initState() {
    super.initState();
    _initJobType();
    _controller.addListener(_onQueryChanged);

    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >=
              _scrollCtrl.position.maxScrollExtent - 200 &&
          !_loading &&
          _results.isNotEmpty &&
          (_page * _perPage) < _total) {
        _loadPage(_page + 1);
      }
    });
  }

  Future<void> _initJobType() async {
    final stored = (await SessionManager.getValue('job_type')) ?? '';
    setState(() => _storedJobType = stored?.toString() ?? '');
    if (kDebugMode) print('🔁 SearchScreen stored job_type: "$_storedJobType"');
  }

  void _onQueryChanged() {
    final q = _controller.text.trim();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _performSearch(q, page: 1);
    });
  }

  String _chooseSearchEndpoint(String jobType) {
    final jt = jobType.toLowerCase();
    if (jt.contains('commission')) return 'searchCommissionJobs';
    if (jt.contains('one') ||
        jt.contains('one-time') ||
        jt.contains('onetime') ||
        jt.contains('one time'))
      return 'searchOneTimeJobs';
    if (jt.contains('project') ||
        jt.contains('projects') ||
        jt.contains('freelance') ||
        jt.contains('it'))
      return 'searchProjects';
    return 'searchSalaryJobs';
  }

  String _chooseApplyEndpoint(String jobType) {
    final jt = jobType.toLowerCase();
    if (jt.contains('commission')) return 'applyCommissionBased';
    if (jt.contains('one') ||
        jt.contains('one-time') ||
        jt.contains('onetime') ||
        jt.contains('one time'))
      return 'applyOneTimeBased';
    if (jt.contains('project') ||
        jt.contains('projects') ||
        jt.contains('freelance') ||
        jt.contains('it'))
      return 'applyProject';
    return 'applySalayBased';
  }

  Future<void> _performSearch(
    String query, {
    int page = 1,
    int perPage = 20,
  }) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _error = null;
        _loading = false;
        _page = 1;
        _perPage = perPage;
        _total = 0;
        _lastQuery = '';
      });
      return;
    }

    final endpoint = _chooseSearchEndpoint(_storedJobType);
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    if (kDebugMode) {
      print('🔁 Search -> endpoint: $endpoint');
      print('🔁 URL: $uri');
      print(
        '🔁 Body: ${jsonEncode({'q': query, 'per_page': perPage, 'page': page})}',
      );
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'q': query, 'per_page': perPage, 'page': page}),
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
          raw is Map && (raw['success'] == true || raw['status'] == 1);

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

      final total = (raw['total'] is int)
          ? raw['total'] as int
          : int.tryParse((raw['total'] ?? '').toString()) ?? parsed.length;
      final per = (raw['per_page'] is int)
          ? raw['per_page'] as int
          : int.tryParse((raw['per_page'] ?? '').toString()) ?? perPage;
      final current = (raw['current_page'] is int)
          ? raw['current_page'] as int
          : int.tryParse((raw['current_page'] ?? '').toString()) ?? page;

      setState(() {
        if (page == 1) {
          _results = parsed;
        } else {
          _results = [..._results, ...parsed];
        }
        _page = current;
        _perPage = per;
        _total = total;
        _lastQuery = query;
      });
    } catch (e, st) {
      if (kDebugMode) print('❌ search error: $e\n$st');
      setState(() => _error = 'Exception: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadPage(int page) async {
    final lastPage = (_perPage > 0) ? ((_total + _perPage - 1) ~/ _perPage) : 1;
    if (page < 1 || page > lastPage) return;
    await _performSearch(_lastQuery, page: page, perPage: _perPage);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onBack() => Navigator.of(context).pop();

  // ---------------------------
  // Apply logic (per-item)
  // ---------------------------
  bool _isApplying(String jobId) => _applyingJobIds.contains(jobId);

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

    final endpoint = _chooseApplyEndpoint(_storedJobType);
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

        // Optionally update UI to mark job applied - depends on response fields
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

  @override
  Widget build(BuildContext context) {
    final lastPage = (_perPage > 0) ? ((_total + _perPage - 1) ~/ _perPage) : 1;
    final showingFrom = _total == 0 ? 0 : ((_page - 1) * _perPage) + 1;
    final showingTo = (_page * _perPage) > _total ? _total : (_page * _perPage);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _onBack,
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (v) =>
                _performSearch(v.trim(), page: 1, perPage: _perPage),
            decoration: InputDecoration(
              hintText: "Search jobs...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // results
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async =>
                  _performSearch(_lastQuery, page: 1, perPage: _perPage),
              child: _loading && _results.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null && _results.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 80),
                        Center(
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () => _performSearch(
                              _controller.text.trim(),
                              page: 1,
                              perPage: _perPage,
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ),
                      ],
                    )
                  : _results.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),
                        Center(
                          child: Icon(
                            Icons.search,
                            size: 72,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: Text(
                            'No results yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      controller: _scrollCtrl,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      itemCount:
                          _results.length +
                          ((_page * _perPage) < _total ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        if (i == _results.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final j = _results[i];
                        final jobMap = j.map(
                          (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
                        );
                        final jobId = jobMap['id'] ?? jobMap['job_id'] ?? '';
                        return JobCard(
                          job: jobMap,
                          onTap: () => _openJobDetail(jobMap),
                          onApply: () => _applyForJob(jobMap),
                          isApplying: _isApplying(jobId),
                        );
                      },
                    ),
            ),
          ),

          // footer pagination
          if (_results.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.grey.shade50,
              child: Row(
                children: [
                  Text(
                    'Showing $showingFrom - $showingTo of $_total',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const Spacer(),

                  IconButton(
                    tooltip: 'Prev',
                    onPressed: (_page > 1 && !_loading)
                        ? () => _loadPage(_page - 1)
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  SizedBox(
                    width: 56,
                    child: TextFormField(
                      initialValue: '$_page',
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                      ),
                      onFieldSubmitted: (v) {
                        final p = int.tryParse(v) ?? _page;
                        final np = p.clamp(1, lastPage);
                        if (np != _page) _loadPage(np);
                      },
                    ),
                  ),
                  Text(' / $lastPage'),
                  IconButton(
                    tooltip: 'Next',
                    onPressed: ((_page * _perPage) < _total && !_loading)
                        ? () => _loadPage(_page + 1)
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _openJobDetail(Map<String, String> job) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JobDetailPage(job: job)),
    );
  }
}

/// JobCard: responsive - actions move below content on narrow widths
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

  Color _approvalColor(String s) {
    switch (s) {
      case '1':
        return Colors.green.shade700;
      case '2':
        return Colors.orange.shade700;
      case '3':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.job;
    final title = m['title'] ?? 'Untitled';
    final salaryMin = m['salary_min'] ?? '';
    final salaryMax = m['salary_max'] ?? '';
    final salaryType = m['salary_type'] ?? '';
    final jobType = m['job_type'] ?? (m['payment_type'] ?? '');
    final experience =
        m['experience_required'] ?? (m['experience_level'] ?? '');
    final location = m['location'] ?? '';
    final openings = m['openings'] ?? '';
    final approval = m['approval'] ?? '';
    final skillsRaw = m['skills'] ?? (m['skills_required'] ?? '');
    final category = m['category'] ?? '';

    final salaryText = (salaryMin.isNotEmpty || salaryMax.isNotEmpty)
        ? (salaryMin == salaryMax
              ? '₹$salaryMin / $salaryType'
              : '₹$salaryMin - ₹$salaryMax / $salaryType')
        : (m['payment_amount'] != null && (m['payment_amount'] ?? '').isNotEmpty
              ? '₹${m['payment_amount']}'
              : (m['budget_min'] != null && (m['budget_min'] ?? '').isNotEmpty
                    ? '₹${m['budget_min']}'
                    : 'Not specified'));

    final skills = skillsRaw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .take(6)
        .toList();

    // Responsive breakpoint - treat < 600 as mobile narrow layout
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow =
            constraints.maxWidth < 600 ||
            MediaQuery.of(context).size.width < 700;

        // icon block
        Widget iconBlock = Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.work_outline, color: AppColors.primary, size: 34),
        );

        // main content
        Widget content = Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // location + experience
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      location,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                  if (experience.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.timeline, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      experience,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              // salary + jobType + openings
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
                  if (!isNarrow && jobType.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.work_outline,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      jobType,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                  if (!isNarrow) const SizedBox(width: 6),
                  if (!isNarrow && openings.isNotEmpty)
                    Text(
                      '$openings openings',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // skills chips
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: skills.map((s) => _skillChip(s)).toList(),
              ),
            ],
          ),
        );

        // action buttons
        Widget viewBtn = SizedBox(
          width: 84,
          height: 36,
          child: ElevatedButton(
            onPressed: () => _onViewPressed(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text(
              'View',
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
        );

        Widget applyBtn = SizedBox(
          width: 84,
          height: 36,
          child: widget.isApplying
              ? const SizedBox(
                  height: 36,
                  child: Center(
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    ),
                  ),
                )
              : OutlinedButton(
                  onPressed: () => _onApplyPressed(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontSize: 13, color: AppColors.primary),
                  ),
                ),
        );

        // Compose card: two variants
        if (isNarrow) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              elevation: 3,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: widget.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // top row: icon + content + approval(badge inline)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          iconBlock,
                          const SizedBox(width: 12),
                          content,
                        ],
                      ),
                      const SizedBox(height: 12),
                      // actions row - stretch to end so buttons align nicely
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [viewBtn, const SizedBox(width: 8), applyBtn],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          // desktop/tablet: original horizontal layout
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: MouseRegion(
              onEnter: (_) => setState(() => _hover = true),
              onExit: (_) => setState(() => _hover = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                transform: _hover
                    ? (Matrix4.identity()..translate(0, -2))
                    : Matrix4.identity(),
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
                      child: Row(
                        children: [
                          iconBlock,
                          const SizedBox(width: 14),
                          content,
                          const SizedBox(width: 12),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatDate(
                                  widget.job['application_deadline'] ??
                                      widget.job['created_at'],
                                ),
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 8),
                              viewBtn,
                              const SizedBox(height: 8),
                              applyBtn,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
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
