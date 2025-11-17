import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/users/views/main_pages/search_placeholder.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = kIsWeb && constraints.maxWidth > 800;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawer: const AppDrawer(),
          appBar: !isWeb
              ? AppBar(
                  toolbarHeight: 80,
                  elevation: 0,
                  title: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: TextField(
                              readOnly:
                                  true, // IMPORTANT — lets us intercept the tap
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SearchScreen(),
                                  ),
                                );
                              },
                              decoration: const InputDecoration(
                                hintText: "Search jobs",
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 40),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  backgroundColor: AppColors.primary,
                )
              : null,
          body: SizedBox.expand(
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 60 : 0,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Promo Banner — now visible on both
                        _buildPromoBanner(),
                        const SizedBox(height: 20),

                        // ✅ Quick Steps — now visible on both
                        _buildQuickSteps(context),
                        const SizedBox(height: 20),

                        // ✅ Search bar for web
                        if (isWeb)
                          Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              width: 600,
                              child: TextField(
                                readOnly: true,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const SearchScreen(),
                                    ),
                                  );
                                },
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
                          ),

                        const SizedBox(height: 30),

                        // 🔹 Trending Jobs
                        // 🔹 Trending Jobs (fetched from API)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Trending Jobs",
                            style: TextStyle(
                              fontSize: isWeb ? 26 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TrendingCategories(isWeb: isWeb),
                        const SizedBox(height: 30),

                        // 🔹 Featured Jobs
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Featured Jobs",
                            style: TextStyle(
                              fontSize: isWeb ? 26 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FeaturedJobs(isWeb: isWeb),

                        // ✅ Featured Jobs both web & mobile
                        // isWeb
                        //     ? GridView.count(
                        //         crossAxisCount: 3,
                        //         shrinkWrap: true,
                        //         physics: const NeverScrollableScrollPhysics(),
                        //         crossAxisSpacing: 20,
                        //         mainAxisSpacing: 20,
                        //         childAspectRatio: 1.3,
                        //         children: const [
                        //           _HoverJobCard(
                        //             "UI/UX Designer",
                        //             "Google",
                        //             "Remote",
                        //           ),
                        //           _HoverJobCard(
                        //             "Flutter Developer",
                        //             "Microsoft",
                        //             "Bangalore",
                        //           ),
                        //           _HoverJobCard(
                        //             "Delivery Executive",
                        //             "Zomato",
                        //             "Mumbai",
                        //           ),
                        //         ],
                        //       )
                        //     : SizedBox(
                        //         height: 160,
                        //         child: ListView(
                        //           scrollDirection: Axis.horizontal,
                        //           padding: const EdgeInsets.symmetric(
                        //             horizontal: 16,
                        //           ),
                        //           children: [
                        //             _jobCard(
                        //               "UI/UX Designer",
                        //               "Google",
                        //               "Remote",
                        //             ),
                        //             _jobCard(
                        //               "Flutter Developer",
                        //               "Microsoft",
                        //               "Bangalore",
                        //             ),
                        //             _jobCard(
                        //               "Delivery Executive",
                        //               "Zomato",
                        //               "Mumbai",
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ Promo Banner (Shared)
  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Get Your Dream Job",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "One stop solution for all your career and freelancing needs.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          Icon(Icons.work, size: 48, color: AppColors.primary),
        ],
      ),
    );
  }

  // ✅ Quick Steps (Shared)
  Widget _buildQuickSteps(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Get Hired in 3 Easy Steps",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _StepWidget(icon: Icons.person, text: "Create Profile"),
              Icon(Icons.arrow_forward_ios, size: 16),
              _StepWidget(icon: Icons.work, text: "Apply Jobs"),
              Icon(Icons.arrow_forward_ios, size: 16),
              _StepWidget(icon: Icons.check_circle, text: "Get Hired"),
            ],
          ),
        ],
      ),
    );
  }

}

/// Step Widget
class _StepWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  const _StepWidget({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class TrendingCategories extends StatefulWidget {
  final bool isWeb;
  final int limit;
  const TrendingCategories({Key? key, required this.isWeb, this.limit = 10})
    : super(key: key);

  @override
  State<TrendingCategories> createState() => _TrendingCategoriesState();
}

class _TrendingCategoriesState extends State<TrendingCategories> {
  bool _loading = true;
  String? _error;
  List<_CategoryModel> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchTrending();
  }

  Future<void> _fetchTrending() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}getTrendingCategories');
      final res = await http.get(uri, headers: {'Accept': 'application/json'});

      if (res.statusCode < 200 || res.statusCode >= 300) {
        setState(() {
          _error = 'Failed (${res.statusCode})';
        });
        return;
      }

      final raw = jsonDecode(res.body);
      if (raw is! Map || raw['status'] != 1) {
        setState(() {
          _error = raw is Map
              ? (raw['message']?.toString() ?? 'Bad response')
              : 'Unexpected response';
        });
        return;
      }

      final List data = (raw['data'] as List? ?? []);
      _items = data.map<_CategoryModel>((e) {
        final m = Map<String, dynamic>.from(e as Map);
        return _CategoryModel(
          id: (m['id'] as num?)?.toInt() ?? 0,
          name: m['category_name']?.toString() ?? '',
          imageUrl: m['image']?.toString(),
          trending: (m['trending'] as num?)?.toInt() ?? 2,
        );
      }).toList();

      if (widget.limit > 0 && _items.length > widget.limit) {
        _items = _items.take(widget.limit).toList();
      }
    } catch (e, st) {
      debugPrint('Trending fetch error: $e\n$st');
      setState(() {
        _error = 'Exception: $e';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(
        height: widget.isWeb ? 140 : 90,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: _fetchTrending,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return SizedBox(
        height: 90,
        child: Center(child: Text('No trending categories found.')),
      );
    }

    // Web: grid-like, Mobile: horizontal list
    if (widget.isWeb) {
      return GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3.2,
        children: _items.map((c) => _TrendingCard(item: c)).toList(),
      );
    } else {
      return SizedBox(
        height: 100,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: _items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final c = _items[i];
            return _MobileTrendingItem(item: c);
          },
        ),
      );
    }
  }
}

class _CategoryModel {
  final int id;
  final String name;
  final String? imageUrl;
  final int trending;
  _CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.trending,
  });
}

class _TrendingCard extends StatelessWidget {
  final _CategoryModel item;
  const _TrendingCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigate to category listing or filter by category
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4)],
        ),
        child: Row(
          children: [
            if (item.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              )
            else
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(Icons.work, color: AppColors.primary),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (item.trending == 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade100),
                ),
                child: const Text(
                  'Trending',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileTrendingItem extends StatelessWidget {
  final _CategoryModel item;
  const _MobileTrendingItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigate/ filter
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (item.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl!,
                  width: 64,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 64,
                    height: 40,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 18),
                  ),
                ),
              )
            else
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(Icons.work, color: AppColors.primary, size: 20),
              ),
            const SizedBox(height: 8),
            Text(
              item.name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// -------------- Usage --------------
// In HomePage build replace the hard-coded Featured Jobs block with:
//   FeaturedJobs(isWeb: isWeb)
// ------------------------------------

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:jobshub/common/constants/base_url.dart';
// import 'package:jobshub/common/utils/app_color.dart';

class FeaturedJobs extends StatefulWidget {
  final bool isWeb;
  final int limit;
  const FeaturedJobs({Key? key, required this.isWeb, this.limit = 12})
    : super(key: key);

  @override
  State<FeaturedJobs> createState() => _FeaturedJobsState();
}

class _FeaturedJobsState extends State<FeaturedJobs> {
  bool _loading = true;
  String? _error;
  List<_JobModel> _jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchFeatured();
  }

  Future<void> _fetchFeatured() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}getFeaturedJobs');
      final res = await http.get(uri, headers: {'Accept': 'application/json'});

      if (res.statusCode < 200 || res.statusCode >= 300) {
        setState(() => _error = 'Failed to fetch (${res.statusCode})');
        return;
      }

      final raw = jsonDecode(res.body);
      if (raw is! Map || raw['success'] != true) {
        setState(
          () => _error = raw is Map
              ? (raw['message']?.toString() ?? 'Bad response')
              : 'Unexpected response',
        );
        return;
      }

      final List data = (raw['data'] as List? ?? []);
      final items = data.map<_JobModel>((e) {
        final m = Map<String, dynamic>.from(e as Map);
        return _JobModel(
          id: (m['id'] as num?)?.toInt() ?? 0,
          title: m['title']?.toString() ?? '',
          category: m['category']?.toString() ?? '',
          jobType: m['job_type']?.toString() ?? '',
          location: m['location']?.toString() ?? '',
          salaryMin: m['salary_min']?.toString() ?? '',
          salaryMax: m['salary_max']?.toString() ?? '',
          approval: (m['approval'] as num?)?.toInt() ?? 2,
          featured: (m['featured'] as num?)?.toInt() ?? 2,
        );
      }).toList();

      setState(() {
        _jobs = widget.limit > 0 ? items.take(widget.limit).toList() : items;
      });
    } catch (e, st) {
      debugPrint('Featured fetch error: $e\n$st');
      setState(() => _error = 'Exception: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(
        height: widget.isWeb ? 360 : 180,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _fetchFeatured,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_jobs.isEmpty) {
      return SizedBox(
        height: 120,
        child: Center(child: Text('No featured jobs at the moment.')),
      );
    }

    // Web: grid; Mobile: horizontal list
    if (widget.isWeb) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _jobs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 1.9,
        ),
        itemBuilder: (_, i) => _FeaturedJobCard(item: _jobs[i]),
      );
    } else {
      return SizedBox(
        height: 170,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: _jobs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) =>
              SizedBox(width: 300, child: _FeaturedJobCard(item: _jobs[i])),
        ),
      );
    }
  }
}

class _JobModel {
  final int id;
  final String title;
  final String category;
  final String jobType;
  final String location;
  final String salaryMin;
  final String salaryMax;
  final int approval;
  final int featured;

  _JobModel({
    required this.id,
    required this.title,
    required this.category,
    required this.jobType,
    required this.location,
    required this.salaryMin,
    required this.salaryMax,
    required this.approval,
    required this.featured,
  });
}

class _FeaturedJobCard extends StatelessWidget {
  final _JobModel item;
  const _FeaturedJobCard({Key? key, required this.item}) : super(key: key);

  String _salaryText() {
    if ((item.salaryMin.isEmpty ||
            item.salaryMin == '0' ||
            item.salaryMin == '0.00') &&
        (item.salaryMax.isEmpty ||
            item.salaryMax == '0' ||
            item.salaryMax == '0.00')) {
      return 'Salary not disclosed';
    }
    if (item.salaryMin.isEmpty || item.salaryMax.isEmpty) {
      return '₹${item.salaryMin.isNotEmpty ? item.salaryMin : item.salaryMax}';
    }
    return '₹${item.salaryMin} - ₹${item.salaryMax}';
  }

  String _companyInitials() {
    // Try category as company-ish label; fall back to title first letter
    final source = (item.category.isNotEmpty) ? item.category : item.title;
    if (source.trim().isEmpty) return 'J';
    final parts = source.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final approved = item.approval == 1;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // header row
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: Text(
                    _companyInitials(),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              item.category,
                              style: TextStyle(color: Colors.grey.shade700),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // badges
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (item.featured == 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.14),
                          ),
                        ),
                        child: const Text(
                          'FEATURED',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: approved
                            ? Colors.green.withOpacity(0.08)
                            : Colors.orange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: approved
                              ? Colors.green.withOpacity(0.14)
                              : Colors.orange.withOpacity(0.14),
                        ),
                      ),
                      child: Text(
                        approved ? 'APPROVED' : 'PENDING',
                        style: TextStyle(
                          color: approved ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // details row
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.location.isEmpty
                        ? 'Location not specified'
                        : item.location,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(item.jobType.isEmpty ? '—' : item.jobType),
              ],
            ),

            const SizedBox(height: 10),

            // salary + actions
            Row(
              children: [
                Expanded(
                  child: Text(
                    _salaryText(),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: navigate to job details or apply screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
