import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/ratings/raters_of_employer.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

const String kApiBase = 'https://dialfirst.in/quantapixel/badhyata/api/';

class EmployerToEmployeeRatingsPage extends StatefulWidget {
  const EmployerToEmployeeRatingsPage({super.key});

  @override
  State<EmployerToEmployeeRatingsPage> createState() =>
      _EmployerToEmployeeRatingsPageState();
}

class _EmployerToEmployeeRatingsPageState
    extends State<EmployerToEmployeeRatingsPage> {
  bool _loading = false;
  String? _error;
  List<EmployeeSummary> _items = [];
  int _total = 0;
  int _currentPage = 1;
  final int _perPage = 20;

  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetch(page: 1);
  }

  Future<void> _fetch({int page = 1, String? q}) async {
    setState(() {
      _loading = true;
      _error = null;
      if (page == 1) _items = [];
    });

    try {
      final uri = Uri.parse('${kApiBase}employeesWithRatings').replace(
        queryParameters: {
          'per_page': _perPage.toString(),
          'page': page.toString(),
          'min_count': '1',
          if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
        },
      );

      // POST with EMPTY body as required
      final res = await http.post(
        uri,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: '',
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final data = (json['data'] as List<dynamic>? ?? [])
            .map((e) => EmployeeSummary.fromJson(e as Map<String, dynamic>))
            .toList();

        setState(() {
          _items = page == 1 ? data : [..._items, ...data];
          _total = (json['total'] ?? 0) as int;
          _currentPage = (json['current_page'] ?? page) as int;
        });
      } else {
        setState(() {
          _error =
              'Failed (${res.statusCode}). ${res.reasonPhrase ?? 'Unknown error'}';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onRefresh() async {
    await _fetch(page: 1, q: _searchCtrl.text);
  }

  void _loadMoreIfNeeded(int index) {
    final haveMore = _items.length < _total;
    if (!haveMore || _loading) return;
    if (index >= _items.length - 4) {
      _fetch(page: _currentPage + 1, q: _searchCtrl.text);
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
              // AppBar
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Employee Ratings",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 2,
                actions: [
                  IconButton(
                    onPressed: () => _fetch(page: 1, q: _searchCtrl.text),
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    tooltip: 'Refresh',
                  ),
                ],
              ),

              // Search + Clear
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    _fetch(page: 1);
                                  },
                                  icon: const Icon(Icons.clear),
                                  tooltip: 'Clear',
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        onSubmitted: (v) => _fetch(page: 1, q: v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _fetch(page: 1, q: _searchCtrl.text),
                        icon: const Icon(Icons.search),
                        label: const Text('Search'),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.all(12),
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: _loading && _items.isEmpty
                        ? const _EE_SkeletonList()
                        : _error != null
                        ? _EE_ErrorBox(
                            message: _error!,
                            onRetry: () => _fetch(page: 1, q: _searchCtrl.text),
                          )
                        : _items.isEmpty
                        ? const _EE_EmptyState()
                        : ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              final r = _items[index];
                              _loadMoreIfNeeded(index);

                              return _EE_EmployeeCard(
                                data: r,
                                onViewDetails: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => EmployeeRatingsDetailPage(
                                        employeeId: r.employeeId,
                                        employeeName:
                                            '${r.firstName} ${r.lastName}',
                                      ),
                                    ),
                                  );
                                },
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

/// ======= Data model =======

class EmployeeSummary {
  final int employeeId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? profileImage;
  final double average;
  final int count;
  final Map<int, int> distribution;
  final String? lastRatedAt;

  EmployeeSummary({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImage,
    required this.average,
    required this.count,
    required this.distribution,
    required this.lastRatedAt,
  });

  factory EmployeeSummary.fromJson(Map<String, dynamic> j) {
    final distRaw = (j['distribution'] as Map<String, dynamic>? ?? {});
    final dist = <int, int>{};
    for (final k in distRaw.keys) {
      final ki = int.tryParse(k) ?? 0;
      dist[ki] = (distRaw[k] as num?)?.toInt() ?? 0;
    }
    return EmployeeSummary(
      employeeId: (j['employee_id'] as num).toInt(),
      firstName: (j['first_name'] ?? '').toString(),
      lastName: (j['last_name'] ?? '').toString(),
      email: j['email']?.toString(),
      profileImage: j['profile_image']?.toString(),
      average: (j['average'] as num?)?.toDouble() ?? 0.0,
      count: (j['count'] as num?)?.toInt() ?? 0,
      distribution: dist,
      lastRatedAt: j['last_rated_at']?.toString(),
    );
  }
}

/// ======= UI pieces (names prefixed with _EE_ to avoid collisions) =======

class _EE_EmployeeCard extends StatelessWidget {
  final EmployeeSummary data;
  final VoidCallback onViewDetails;

  const _EE_EmployeeCard({required this.data, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    final fullName = '${data.firstName} ${data.lastName}'.trim();

    return Card(
      elevation: 2.5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                _EE_AvatarInitials(name: fullName),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName.isEmpty ? '—' : fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if ((data.email ?? '').isNotEmpty)
                        Text(
                          data.email!,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12.5,
                          ),
                        ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onViewDetails,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('View'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Rating Bar + Average + Count
            Row(
              children: [
                _EE_StarBar(value: data.average),
                const SizedBox(width: 8),
                Text(
                  data.average.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                _EE_ChipStat(label: 'Total', value: data.count.toString()),
              ],
            ),
            const SizedBox(height: 8),

            // Distribution line
            _EE_DistributionBar(distribution: data.distribution),
            const SizedBox(height: 8),

            // Footer
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Last rated: ${data.lastRatedAt ?? '-'}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EE_DistributionBar extends StatelessWidget {
  final Map<int, int> distribution; // 1..5
  const _EE_DistributionBar({required this.distribution});

  @override
  Widget build(BuildContext context) {
    final total = distribution.values.fold<int>(0, (a, b) => a + b);

    Widget bar(int star) {
      final val = distribution[star] ?? 0;
      final pct = total == 0 ? 0.0 : val / total;
      return Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$star★',
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(
              '$val',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        bar(5),
        const SizedBox(height: 6),
        bar(4),
        const SizedBox(height: 6),
        bar(3),
        const SizedBox(height: 6),
        bar(2),
        const SizedBox(height: 6),
        bar(1),
      ],
    );
  }
}

class _EE_AvatarInitials extends StatelessWidget {
  final String name;
  const _EE_AvatarInitials({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase())
        .take(2)
        .join();
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.primary.withOpacity(0.12),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _EE_StarBar extends StatelessWidget {
  final double value; // 0..5
  const _EE_StarBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    for (var i = 1; i <= 5; i++) {
      final diff = value - i + 1;
      IconData icon;
      if (diff >= 1) {
        icon = Icons.star;
      } else if (diff >= 0.5) {
        icon = Icons.star_half;
      } else {
        icon = Icons.star_border;
      }
      widgets.add(Icon(icon, color: Colors.amber, size: 18));
    }
    return Row(children: widgets);
  }
}

class _EE_ChipStat extends StatelessWidget {
  final String label;
  final String value;
  const _EE_ChipStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _EE_SkeletonList extends StatelessWidget {
  const _EE_SkeletonList();

  @override
  Widget build(BuildContext context) {
    Widget box({double h = 14, double w = 120}) => Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          box(w: 160),
                          const SizedBox(height: 8),
                          box(w: 120, h: 12),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    box(w: 70, h: 30),
                  ],
                ),
                const SizedBox(height: 12),
                box(w: double.infinity),
                const SizedBox(height: 8),
                box(w: double.infinity),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EE_EmptyState extends StatelessWidget {
  const _EE_EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 42, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          const Text(
            'No employees found.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _EE_ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _EE_ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 28,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
