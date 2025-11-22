// hr - redesigned to match admin review UI
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/ratings/raters_of_employee.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

const String kApiBase = 'https://dialfirst.in/quantapixel/badhyata/api/';

class EmployeeToEmployerRatingsPage extends StatefulWidget {
  const EmployeeToEmployerRatingsPage({super.key});

  @override
  State<EmployeeToEmployerRatingsPage> createState() =>
      _EmployeeToEmployerRatingsPageState();
}

class _EmployeeToEmployerRatingsPageState
    extends State<EmployeeToEmployerRatingsPage> {
  bool _loading = false;
  String? _error;
  List<EmployerSummary> _items = [];
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
      final uri = Uri.parse('${kApiBase}employersWithRatings').replace(
        queryParameters: {
          'per_page': _perPage.toString(),
          'page': page.toString(),
          'min_count': '1',
          if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
        },
      );

      // POST with EMPTY body as requested
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
            .map((e) => EmployerSummary.fromJson(e as Map<String, dynamic>))
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
              // Sticky AppBar with quick actions
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                automaticallyImplyLeading: !isWeb,
                title: const Text(
                  "Employer Ratings",
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
                        ? const _SkeletonList()
                        : _error != null
                        ? _ErrorBox(
                            message: _error!,
                            onRetry: () => _fetch(page: 1, q: _searchCtrl.text),
                          )
                        : _items.isEmpty
                        ? const _EmptyState()
                        : ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              final r = _items[index];
                              _loadMoreIfNeeded(index);

                              return _EmployerCard(
                                data: r,
                                onViewDetails: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => EmployerRatingsDetailPage(
                                        employerId: r.employerId,
                                        employerName:
                                            '${r.firstName} ${r.lastName}'
                                                .trim(),
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

class EmployerSummary {
  final int employerId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? profileImage;
  final double average;
  final int count;
  final Map<int, int> distribution;
  final String? lastRatedAt;

  EmployerSummary({
    required this.employerId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImage,
    required this.average,
    required this.count,
    required this.distribution,
    required this.lastRatedAt,
  });

  factory EmployerSummary.fromJson(Map<String, dynamic> j) {
    final distRaw = (j['distribution'] as Map<String, dynamic>? ?? {});
    final dist = <int, int>{};
    for (final k in distRaw.keys) {
      final ki = int.tryParse(k) ?? 0;
      dist[ki] = (distRaw[k] as num?)?.toInt() ?? 0;
    }
    return EmployerSummary(
      employerId: (j['employer_id'] as num).toInt(),
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

/// ======= UI pieces (admin-style card for HR) =======

class _EmployerCard extends StatefulWidget {
  final EmployerSummary data;
  final VoidCallback onViewDetails;
  const _EmployerCard({required this.data, required this.onViewDetails});

  @override
  State<_EmployerCard> createState() => _EmployerCardState();
}

class _EmployerCardState extends State<_EmployerCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final fullName = '${data.firstName} ${data.lastName}'.trim();

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.symmetric(vertical: 8),
        transform: _hover
            ? (Matrix4.identity()..translate(0, -4))
            : Matrix4.identity(),
        child: Material(
          elevation: _hover ? 6 : 2,
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onViewDetails,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // left: avatar + rating badge
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _AvatarInitials(
                        name: fullName,
                        imageUrl: data.profileImage,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 2, bottom: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            data.average.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  // middle: main content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // title row
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                fullName.isEmpty ? '—' : fullName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // compact count
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person_2_outlined,
                                    size: 14,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${data.count}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        if ((data.email ?? '').isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            data.email!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),

                        // distribution + last rated
                        Row(
                          children: [
                            Expanded(
                              child: _DistributionBarSimple(
                                distribution: data.distribution,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    _StarBar(value: data.average),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        data.average.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Last rated: ${data.lastRatedAt ?? '-'}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // right: actions
                  const SizedBox(width: 12),
                  PopupMenuButton<int>(
                    tooltip: 'Actions',
                    onSelected: (v) {
                      if (v == 1) widget.onViewDetails();
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          leading: Icon(Icons.people),
                          title: Text('View raters'),
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      child: const Icon(Icons.more_vert, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// compact distribution - horizontal stacked thin bars
class _DistributionBarSimple extends StatelessWidget {
  final Map<int, int> distribution;
  const _DistributionBarSimple({required this.distribution});

  @override
  Widget build(BuildContext context) {
    final total = distribution.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) {
      return Container(
        height: 14,
        alignment: Alignment.centerLeft,
        child: Text(
          'No ratings',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      );
    }

    final children = <Widget>[];
    for (var s = 5; s >= 1; s--) {
      final val = distribution[s] ?? 0;
      final pct = total == 0 ? 0.0 : val / total;
      children.add(
        Expanded(
          flex: (pct * 1000).round().clamp(1, 1000),
          child: Tooltip(
            message: '$s ★ — $val (${(pct * 100).toStringAsFixed(0)}%)',
            child: Container(
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.14 + (s * 0.04)),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      );
    }

    return Row(children: children);
  }
}

class _AvatarInitials extends StatelessWidget {
  final String name;
  final String? imageUrl;
  const _AvatarInitials({required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase())
        .take(2)
        .join();

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
          image: DecorationImage(
            image: NetworkImage(imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primary.withOpacity(0.12),
      ),
      alignment: Alignment.center,
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    );
  }
}

class _StarBar extends StatelessWidget {
  final double value; // 0..5
  const _StarBar({required this.value});

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
      widgets.add(Icon(icon, color: Colors.amber, size: 14));
    }
    return Row(children: widgets);
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

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
                    Container(
                      width: 64,
                      height: 64,
                      color: Colors.grey.shade200,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 42, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          const Text(
            'No employers found.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBox({required this.message, required this.onRetry});

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
