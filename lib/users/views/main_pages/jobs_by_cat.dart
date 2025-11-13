// CategoryJobsPage with Indeed/WorkIndia style filters (client-side)
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jobshub/common/utils/AppColor.dart';

const String kApiBase = 'https://dialfirst.in/quantapixel/badhyata/api/';

class CategoryJobsPage extends StatefulWidget {
  final String category;
  const CategoryJobsPage({super.key, required this.category});

  @override
  State<CategoryJobsPage> createState() => _CategoryJobsPageState();
}

class _CategoryJobsPageState extends State<CategoryJobsPage> {
  bool _loading = false;
  String? _error;
  List<Map<String, dynamic>> _jobs = [];

  // UI filtering state
  List<Map<String, dynamic>> _visibleJobs = [];
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;
  String _keyword = '';
  String _sort = 'newest'; // newest, oldest, salary_high, salary_low

  // advanced filters
  String _approvalFilter =
      '1'; // default: approved (you mentioned fetching approved)
  final Set<String> _selectedJobTypes = {};
  String _experienceFilter = 'any';
  String _locationFilter = '';
  double _salaryMin = 0;
  double _salaryMax = 0;
  RangeValues _salaryRange = const RangeValues(0, 100000);

  // derived sets for filter controls
  final Set<String> _jobTypes = {};
  final Set<String> _experienceLevels = {};

  // pagination - client-side
  int _perPage = 10;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _fetchJobsByCategory();
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

  Future<void> _refresh() async {
    await _fetchJobsByCategory();
  }

  Future<void> _fetchJobsByCategory() async {
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
      _salaryMin = 0;
      _salaryMax = 0;
      _salaryRange = const RangeValues(0, 100000);
      _page = 1;
    });

    final uri = Uri.parse('${kApiBase}salaryJobsByCategory');

    try {
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'category': widget.category}),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final jsonBody = jsonDecode(res.body) as Map<String, dynamic>;
        if (jsonBody['success'] == true) {
          final data = (jsonBody['data'] as List<dynamic>?) ?? [];
          final parsed = data.map<Map<String, dynamic>>((e) {
            if (e is Map<String, dynamic>) return e;
            return Map<String, dynamic>.from(e as Map);
          }).toList();

          // derive job types, experience and salary min/max
          double minSalary = double.infinity;
          double maxSalary = 0;
          for (final p in parsed) {
            final jt = (p['job_type'] ?? '').toString().trim();
            if (jt.isNotEmpty) _jobTypes.add(jt);

            final exp = (p['experience_required'] ?? '').toString().trim();
            if (exp.isNotEmpty) _experienceLevels.add(exp);

            final smin =
                double.tryParse((p['salary_min'] ?? '').toString()) ?? 0.0;
            final smax =
                double.tryParse((p['salary_max'] ?? '').toString()) ?? 0.0;
            if (smin > 0) minSalary = smin < minSalary ? smin : minSalary;
            if (smax > 0) maxSalary = smax > maxSalary ? smax : maxSalary;
          }

          if (minSalary == double.infinity) minSalary = 0.0;
          if (maxSalary == 0 && minSalary > 0) maxSalary = minSalary;
          if (maxSalary == 0 && minSalary == 0) {
            // fallback range
            minSalary = 0;
            maxSalary = 100000;
          }

          setState(() {
            _jobs = parsed;
            _salaryMin = minSalary;
            _salaryMax = maxSalary;
            _salaryRange = RangeValues(
              minSalary,
              maxSalary == 0 ? minSalary : maxSalary,
            );
            _visibleJobs = List.from(parsed);
          });

          _applyFilters();
        } else {
          setState(() {
            _error = jsonBody['message']?.toString() ?? 'API returned an error';
          });
        }
      } else {
        setState(() {
          _error = 'Failed (${res.statusCode}). ${res.reasonPhrase ?? ''}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    List<Map<String, dynamic>> items = List.from(_jobs);

    // approval (if you already fetch approved ones on server, this is mostly a no-op)
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
      // treat missing as match
      if (a == 0 && b == 0) return true;
      final within =
          (a >= low && a <= high) ||
          (b >= low && b <= high) ||
          (a <= low && b >= high);
      return within;
    }).toList();

    // keyword search (title, skills, location)
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
        // salary sort
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

    // pagination - client-side
    final start = (_page - 1) * _perPage;
    final end = start + _perPage;
    final paged = items.sublist(0, items.length < end ? items.length : end);

    setState(() {
      _visibleJobs = paged;
    });
  }

  void _toggleJobType(String jt) {
    setState(() {
      if (_selectedJobTypes.contains(jt))
        _selectedJobTypes.remove(jt);
      else
        _selectedJobTypes.add(jt);
      _page = 1;
      _applyFilters();
    });
  }

  void _changeExperience(String e) {
    setState(() {
      _experienceFilter = e;
      _page = 1;
      _applyFilters();
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedJobTypes.clear();
      _experienceFilter = 'any';
      _locationFilter = '';
      _searchCtrl.clear();
      _keyword = '';
      _salaryRange = RangeValues(_salaryMin, _salaryMax);
      _approvalFilter = '1';
      _sort = 'newest';
      _page = 1;
      _applyFilters();
    });
  }

  void _loadMore() {
    setState(() {
      _page++;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 2,
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _openAdvancedFilters(context, isWide),
            tooltip: 'Advanced filters',
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 28 : 12,
          vertical: 12,
        ),
        child: Column(
          children: [
            // Top quick filter row: keyword + active chips
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Search jobs by title, skills or location...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _applyFilters(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // sort dropdown compact
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
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
                          child: Text('Salary: High → Low'),
                        ),
                        DropdownMenuItem(
                          value: 'salary_low',
                          child: Text('Salary: Low → High'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            _sort = v;
                            _page = 1;
                            _applyFilters();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Active filter chips
            _buildActiveChips(),

            const SizedBox(height: 10),

            // Body list
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: _buildBody(isWide),
              ),
            ),
            const SizedBox(height: 8),

            // Show load more if there could be more (client-side unknown total - we attempt)
            if ((_jobs.length > _visibleJobs.length))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loadMore,
                  child: const Text('Load more'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveChips() {
    final List<Widget> chips = [];

    if (_selectedJobTypes.isNotEmpty) {
      for (final t in _selectedJobTypes) {
        chips.add(
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InputChip(
              label: Text(t),
              onDeleted: () => _toggleJobType(t),
              selected: true,
              selectedColor: AppColors.primary.withOpacity(0.12),
            ),
          ),
        );
      }
    }

    if (_experienceFilter != 'any') {
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InputChip(
            label: Text(_experienceFilter),
            onDeleted: () => _changeExperience('any'),
          ),
        ),
      );
    }

    if (_locationFilter.trim().isNotEmpty) {
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InputChip(
            label: Text('Loc: $_locationFilter'),
            onDeleted: () => setState(() {
              _locationFilter = '';
              _applyFilters();
            }),
          ),
        ),
      );
    }

    if ((_salaryRange.start != _salaryMin) ||
        (_salaryRange.end != _salaryMax)) {
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InputChip(
            label: Text(
              'Salary: ${_salaryRange.start.toInt()} - ${_salaryRange.end.toInt()}',
            ),
            onDeleted: () {
              setState(() {
                _salaryRange = RangeValues(_salaryMin, _salaryMax);
                _applyFilters();
              });
            },
          ),
        ),
      );
    }

    if (chips.isEmpty) {
      return Row(
        children: [
          Text('Filters', style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _openAdvancedFiltersPressed,
            child: const Text('Show filters'),
          ),
          const Spacer(),
          TextButton(onPressed: _clearFilters, child: const Text('Clear all')),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: chips),
          ),
        ),
        TextButton(
          onPressed: _openAdvancedFiltersPressed,
          child: const Text('Edit'),
        ),
        TextButton(onPressed: _clearFilters, child: const Text('Clear all')),
      ],
    );
  }

  void _openAdvancedFiltersPressed() {
    _openAdvancedFilters(context, MediaQuery.of(context).size.width > 900);
  }

  Widget _buildBody(bool isWide) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
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
              onPressed: _fetchJobsByCategory,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_visibleJobs.isEmpty) {
      return const Center(child: Text('No jobs match your filters.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 18),
      itemCount: _visibleJobs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final j = _visibleJobs[index];
        final jobMap = j.map(
          (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
        );
        return JobCard(job: jobMap, onTap: () => _openJobDetail(jobMap));
      },
    );
  }

  void _openJobDetail(Map<String, String> job) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JobDetailPage(job: job)),
    );
  }

  Future<void> _openAdvancedFilters(BuildContext context, bool isWide) async {
    // show modal bottom sheet for mobile, side sheet for web
    if (isWide) {
      await showDialog(
        context: context,
        builder: (_) => Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: SizedBox(width: 700, child: _advancedFiltersContent()),
        ),
      );
    } else {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _advancedFiltersContent(),
          ),
        ),
      );
    }
  }

  Widget _advancedFiltersContent() {
    return StatefulBuilder(
      builder: (context, setStateSB) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Advanced Filters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Approval (small)
              Row(
                children: [
                  const Text(
                    'Approval: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Approved'),
                    selected: _approvalFilter == '1',
                    onSelected: (_) => setStateSB(() => _approvalFilter = '1'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Pending'),
                    selected: _approvalFilter == '2',
                    onSelected: (_) => setStateSB(() => _approvalFilter = '2'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Rejected'),
                    selected: _approvalFilter == '3',
                    onSelected: (_) => setStateSB(() => _approvalFilter = '3'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Any'),
                    selected: _approvalFilter == 'all',
                    onSelected: (_) =>
                        setStateSB(() => _approvalFilter = 'all'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Job types grid
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Job type',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _jobTypes.map((jt) {
                  final sel = _selectedJobTypes.contains(jt);
                  return FilterChip(
                    label: Text(jt),
                    selected: sel,
                    onSelected: (v) => setStateSB(() => _toggleJobType(jt)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Experience + location row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _experienceFilter,
                      items: [
                        const DropdownMenuItem(
                          value: 'any',
                          child: Text('Any experience'),
                        ),
                        ..._experienceLevels.map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)),
                        ),
                      ],
                      onChanged: (v) =>
                          setStateSB(() => _changeExperience(v ?? 'any')),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: _locationFilter,
                      onChanged: (v) => setStateSB(() => _locationFilter = v),
                      decoration: const InputDecoration(
                        hintText: 'Location',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Salary range
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Salary range',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 6),
              RangeSlider(
                values: _salaryRange,
                min: _salaryMin,
                max: _salaryMax == 0 ? (_salaryMin + 100000) : _salaryMax,
                labels: RangeLabels(
                  _salaryRange.start.toInt().toString(),
                  _salaryRange.end.toInt().toString(),
                ),
                onChanged: (vals) => setStateSB(() => _salaryRange = vals),
              ),

              const SizedBox(height: 12),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedJobTypes.clear();
                          _experienceFilter = 'any';
                          _locationFilter = '';
                          _salaryRange = RangeValues(_salaryMin, _salaryMax);
                        });
                        setStateSB(() {}); // update modal state
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // apply: update parent and close
                        setState(() {
                          // already mutated via setState callbacks above
                        });
                        _page = 1;
                        _applyFilters();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Apply filters'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        );
      },
    );
  }
}

/// Job card and detail page (kept neat)
class JobCard extends StatefulWidget {
  final Map<String, String> job;
  final VoidCallback onTap;

  JobCard({super.key, required Map<String, dynamic> job, required this.onTap})
    : job = job.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));

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

  String _approvalLabel(String s) {
    switch (s) {
      case '1':
        return 'Approved';
      case '2':
        return 'Pending';
      case '3':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

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
    final approval = m['approval'] ?? '';
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

    final bool isWeb = MediaQuery.of(context).size.width > 900;

    Widget card = Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.work_outline,
                  color: AppColors.primary,
                  size: 34,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _approvalColor(approval).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _approvalColor(approval).withOpacity(0.18),
                            ),
                          ),
                          child: Text(
                            _approvalLabel(approval),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _approvalColor(approval),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                          Icon(
                            Icons.timeline,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            experience,
                            style: TextStyle(color: Colors.grey.shade700),
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
                        Text(
                          salaryText,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 12),
                        if (jobType.isNotEmpty) ...[
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
                        const Spacer(),
                        if (openings.isNotEmpty)
                          Text(
                            '$openings openings',
                            style: TextStyle(color: Colors.grey.shade600),
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
                ),
              ),
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
                  SizedBox(
                    width: 84,
                    child: ElevatedButton(
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('View'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (isWeb) {
      return MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          transform: _hover
              ? (Matrix4.identity()..translate(0, -6))
              : Matrix4.identity(),
          child: card,
        ),
      );
    }
    return card;
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
      return '${fmt.format(dt)}';
    } catch (_) {
      return d;
    }
  }
}

class JobDetailPage extends StatelessWidget {
  final Map<String, String> job;
  const JobDetailPage({super.key, required this.job});

  String _formatFullDate(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      final dt = DateTime.parse(d);
      return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(dt);
    } catch (_) {
      return d;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = job['title'] ?? 'Job';
    final location = job['location'] ?? 'Location unavailable';
    final salaryMin = job['salary_min'] ?? '';
    final salaryMax = job['salary_max'] ?? '';
    final salaryType = job['salary_type'] ?? '';
    final salaryText = (salaryMin.isNotEmpty || salaryMax.isNotEmpty)
        ? (salaryMin == salaryMax
              ? '₹$salaryMin / $salaryType'
              : '₹$salaryMin - ₹$salaryMax / $salaryType')
        : 'Not specified';
    final jobType = job['job_type'] ?? '';
    final experience = job['experience_required'] ?? '';
    final qualification = job['qualification'] ?? '';
    final skills = (job['skills'] ?? '')
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final deadline = job['application_deadline'];
    final description = job['job_description'] ?? '-';
    final responsibilities = job['responsibilities'] ?? '-';
    final benefits = job['benefits'] ?? '-';
    final contactEmail = job['contact_email'] ?? '';
    final contactPhone = job['contact_phone'] ?? '';

    final bool isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        centerTitle: false,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isWide ? 1100 : double.infinity,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.work_outline,
                            color: AppColors.primary,
                            size: 36,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    location,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  if (jobType.isNotEmpty) ...[
                                    Icon(
                                      Icons.work_outline,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      jobType,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              salaryText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Experience: $experience',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title: 'Job Description',
                  child: Text(description, style: const TextStyle(height: 1.6)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _sectionCard(
                        title: 'Responsibilities',
                        child: Text(responsibilities),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _sectionCard(
                        title: 'Benefits',
                        child: Text(benefits),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _sectionCard(
                  title: 'Skills & Qualification',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (qualification.isNotEmpty)
                        Text('Qualification: $qualification'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: skills
                            .map((s) => Chip(label: Text(s)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _sectionCard(
                  title: 'Meta',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Application deadline: ${deadline != null ? _formatFullDate(deadline) : 'Not specified'}',
                      ),
                      const SizedBox(height: 6),
                      if (contactEmail.isNotEmpty)
                        Text('Contact: $contactEmail'),
                      if (contactPhone.isNotEmpty) Text('Phone: $contactPhone'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Apply (demo)')),
                            ),
                        icon: const Icon(Icons.send),
                        label: const Text('Apply Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved (demo)')),
                          ),
                      icon: const Icon(Icons.bookmark_border),
                      label: const Text('Save'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
