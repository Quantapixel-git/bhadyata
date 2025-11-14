import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_sidebar.dart';

const String kApiBase = 'https://dialfirst.in/quantapixel/badhyata/api/';

class EmployerRatingsDetailPage extends StatefulWidget {
  final int employerId;
  final String employerName;

  const EmployerRatingsDetailPage({
    super.key,
    required this.employerId,
    required this.employerName,
  });

  @override
  State<EmployerRatingsDetailPage> createState() =>
      _EmployerRatingsDetailPageState();
}

class _EmployerRatingsDetailPageState extends State<EmployerRatingsDetailPage> {
  bool _loading = false;
  String? _error;
  List<EmployerRatingItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
      _items = [];
    });

    try {
      final uri = Uri.parse('${kApiBase}employerRatings');

      final res = await http.post(
        uri,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'employer_id': widget.employerId}),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final data = (json['data'] as List<dynamic>? ?? [])
            .map((e) => EmployerRatingItem.fromJson(e as Map<String, dynamic>))
            .toList();

        setState(() => _items = data);
      } else {
        setState(() {
          _error =
              'Failed (${res.statusCode}). ${res.reasonPhrase ?? 'Unknown error'}';
        });
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HrDashboardWrapper(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primary,
            title: Text(
              'Ratings: ${widget.employerName}',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: _fetch,
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Refresh',
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(12),
              child: _loading
                  ? const _DetailSkeleton()
                  : _error != null
                      ? _ErrorBox(message: _error!, onRetry: _fetch)
                      : _items.isEmpty
                          ? const _EmptyDetailState()
                          : ListView.separated(
                              itemCount: _items.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final r = _items[index];
                                final raterName =
                                    '${r.raterFirstName} ${r.raterLastName}'.trim();

                                return Card(
                                  elevation: 2.5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            _AvatarInitials(name: raterName),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    raterName.isEmpty
                                                        ? '—'
                                                        : raterName,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Rated on: ${r.createdAt ?? '-'}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Rating number
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.amber
                                                    .withOpacity(0.15),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.star,
                                                      size: 16,
                                                      color: Colors.amber),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    r.rating
                                                        .toStringAsFixed(1),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        _StarBar(value: r.rating),
                                        if ((r.review ?? '').isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            '"${r.review}"',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---- detail models / UI bits ----

class EmployerRatingItem {
  final int id;
  final int raterId;
  final int rateeId;
  final double rating;
  final String? review;
  final String? createdAt;
  final String? updatedAt;
  final String raterFirstName;
  final String raterLastName;
  final String? raterProfileImage;

  EmployerRatingItem({
    required this.id,
    required this.raterId,
    required this.rateeId,
    required this.rating,
    required this.review,
    required this.createdAt,
    required this.updatedAt,
    required this.raterFirstName,
    required this.raterLastName,
    required this.raterProfileImage,
  });

  factory EmployerRatingItem.fromJson(Map<String, dynamic> j) {
    return EmployerRatingItem(
      id: (j['id'] as num).toInt(),
      raterId: (j['rater_id'] as num).toInt(),
      rateeId: (j['ratee_id'] as num).toInt(),
      rating: (j['rating'] as num).toDouble(),
      review: j['review']?.toString(),
      createdAt: j['created_at']?.toString(),
      updatedAt: j['updated_at']?.toString(),
      raterFirstName: (j['rater_first_name'] ?? '').toString(),
      raterLastName: (j['rater_last_name'] ?? '').toString(),
      raterProfileImage: j['rater_profile_image']?.toString(),
    );
  }
}

class _AvatarInitials extends StatelessWidget {
  final String name;
  const _AvatarInitials({required this.name});

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
      radius: 20,
      backgroundColor: AppColors.primary.withOpacity(0.12),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
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
      widgets.add(Icon(icon, color: Colors.amber, size: 18));
    }
    return Row(children: widgets);
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

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
      itemCount: 5,
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
                    CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade200),
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
                    box(w: 60, h: 26),
                  ],
                ),
                const SizedBox(height: 10),
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

class _EmptyDetailState extends StatelessWidget {
  const _EmptyDetailState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.rate_review_outlined, size: 42, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        const Text(
          'No ratings yet.',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ]),
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
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.error_outline, size: 28, color: Colors.redAccent),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            )
          ]),
        ),
      ),
    );
  }
}
