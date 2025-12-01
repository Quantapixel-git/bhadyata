// ignore_for_file: unused_element_parameter

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/users/views/main_pages/common_search/search_placeholder.dart';
import 'package:jobshub/users/views/main_pages/home/jobs_trending_cat.dart';
import 'package:jobshub/users/views/main_pages/search/job_detail_page.dart'
    show JobDetailPage;

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

                        const SizedBox(height: 10),

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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TrendingCategoryJobsPage(category: item.name),
          ),
        );
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
        // navigate to the category jobs page on mobile as well
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TrendingCategoryJobsPage(category: item.name),
          ),
        );
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

  final Set<String> _applyingJobIds = {};
  String _profileJobType = '';

  @override
  void initState() {
    super.initState();
    _loadJobType();
    _fetchFeatured();
  }

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

    // Decide endpoint based on job_type in profile
    final jtLower = _profileJobType.toLowerCase();

    String endpoint;
    if (jtLower.contains('salary')) {
      endpoint = 'applySalayBased';
    } else if (jtLower.contains('commission') ||
        jtLower.contains('commission-based') ||
        jtLower.contains('commision')) {
      endpoint = 'applyCommissionBased';
    } else if (jtLower.contains('one') ||
        jtLower.contains('one-time') ||
        jtLower.contains('onetime') ||
        jtLower.contains('one time')) {
      endpoint = 'applyOneTimeJob';
    } else if (jtLower.contains('project') ||
        jtLower.contains('projects') ||
        jtLower.contains('freelance')) {
      endpoint = 'applyProject';
    } else {
      endpoint = 'applySalayBased';
    }

    final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");

    final bool isProjectEndpoint = endpoint == 'applyProject';
    final body = isProjectEndpoint
        ? {
            "project_id": jobId,
            "employee_id": employeeId,
            "remarks": "Available for the job.",
          }
        : {
            "job_id": jobId,
            "employee_id": employeeId,
            "remarks": "Available for the job.",
          };

    setState(() => _applyingJobIds.add(jobId));

    try {
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      final json = jsonDecode(res.body);
      final msg = json["message"]?.toString() ?? "Response received";

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error applying: $e")));
    } finally {
      setState(() => _applyingJobIds.remove(jobId));
    }
  }

  bool _isApplying(String jobId) => _applyingJobIds.contains(jobId);

  Future<void> _loadJobType() async {
    final stored = await SessionManager.getValue('job_type') ?? '';
    setState(() => _profileJobType = stored.toString());
  }

  // Returns the endpoint path (not full URL) based on stored job_type
  // Returns the endpoint path (not full URL) based on stored job_type
  String _chooseEndpointFromJobType(String jobType) {
    final jt = jobType.toLowerCase();

    // check commission first (be tolerant to spelling / variants)
    if (jt.contains('commission') ||
        jt.contains('commission-based') ||
        jt.contains('commision')) {
      return 'CommissionBasedgetFeaturedJobs';
    }

    // one-time / onetime
    if (jt.contains('one') ||
        jt.contains('one-time') ||
        jt.contains('onetime') ||
        jt.contains('one time')) {
      return 'OnetimegetFeaturedJobs';
    }

    // project / freelance / it -> projects endpoint if you want that mapping
    if (jt.contains('project') ||
        jt.contains('projects') ||
        jt.contains('freelance') ||
        jt.contains('it')) {
      return 'ProjectgetFeaturedJobs';
    }

    // default to salary featured
    return 'SalaryBasedgetFeaturedJobs';
  }

  Future<void> _fetchFeatured() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // read stored job_type from session
      final stored = (await SessionManager.getValue('job_type')) ?? '';
      final jobType = stored.toString();

      // choose endpoint path (you can adjust the strings below to match server routes)
      final endpoint = _chooseEndpointFromJobType(jobType);

      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      if (kDebugMode) {
        print('🔁 Fetch featured endpoint: $endpoint');
        print('🔁 Full URL: $uri');
        print('🔁 Stored job_type: "$jobType"');
      }

      final res = await http.get(uri, headers: {'Accept': 'application/json'});

      if (kDebugMode) {
        print('⬅️ Status: ${res.statusCode}');
        print('⬅️ Body: ${res.body}');
      }

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

      // Normalize each item into _JobModel (handle salary/min/max/payment/budget variants)
      final items = data.map<_JobModel>((e) {
        final m = Map<String, dynamic>.from(e as Map);

        // Generic title/category/jobType/location extraction
        final title = (m['title'] ?? m['name'] ?? '').toString();
        final category = (m['category'] ?? '').toString();
        final jobTypeField =
            (m['job_type'] ?? m['payment_type'] ?? m['commission_type'] ?? '')
                .toString();
        final location = (m['location'] ?? '').toString();

        // Salary/budget/payment normalization (pick best available)
        String salaryMin = '';
        String salaryMax = '';

        // salary-based keys
        if (m.containsKey('salary_min') || m.containsKey('salary_max')) {
          salaryMin = (m['salary_min'] ?? '').toString();
          salaryMax = (m['salary_max'] ?? '').toString();
        } else if (m.containsKey('budget_min') || m.containsKey('budget_max')) {
          salaryMin = (m['budget_min'] ?? '').toString();
          salaryMax = (m['budget_max'] ?? '').toString();
        } else if (m.containsKey('payment_amount')) {
          salaryMin = (m['payment_amount'] ?? '').toString();
          salaryMax = salaryMin;
        } else if (m.containsKey('potential_earning')) {
          salaryMin = (m['potential_earning'] ?? '').toString();
          salaryMax = salaryMin;
        } else {
          // fallback: use generic 'salary' or empty
          salaryMin = (m['salary'] ?? '').toString();
          salaryMax = salaryMin;
        }

        final id = (m['id'] as num?)?.toInt() ?? 0;
        final approval = (m['approval'] as num?)?.toInt() ?? 2;
        final featured = (m['featured'] as num?)?.toInt() ?? 0;

        return _JobModel(
          id: id,
          title: title,
          category: category,
          jobType: jobTypeField,
          location: location,
          salaryMin: salaryMin,
          salaryMax: salaryMax,
          approval: approval,
          featured: featured,
          raw: m,
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
  final Map<String, dynamic>? raw; // raw response if you need it

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
    this.raw,
  });
}

class _FeaturedJobCard extends StatelessWidget {
  final _JobModel item;
  final void Function()? onView;
  final void Function()? onApply;

  const _FeaturedJobCard({
    Key? key,
    required this.item,
    this.onView,
    this.onApply,
  }) : super(key: key);

  String _salaryText() {
    final a = item.salaryMin;
    final b = item.salaryMax;
    if ((a.isEmpty || a == '0' || a == '0.00') &&
        (b.isEmpty || b == '0' || b == '0.00')) {
      return 'Not specified';
    }
    if (a.isEmpty && b.isNotEmpty) return '₹$b';
    if (b.isEmpty && a.isNotEmpty) return '₹$a';
    if (a == b) return '₹$a';
    return '₹$a - ₹$b';
  }

  Map<String, String> _jobMapFromRaw() {
    final raw = item.raw ?? <String, dynamic>{};
    return raw.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    final title = item.title;
    final location = item.location.isEmpty
        ? 'Location not specified'
        : item.location;
    final jobType = item.jobType;
    final salary = _salaryText();
    final jobMap = _jobMapFromRaw();

    final rawDesc =
        (item.raw?['job_description'] ?? item.raw?['description'] ?? '')
            .toString()
            .trim();
    final snippet = rawDesc.isEmpty
        ? ''
        : (rawDesc.length > 100 ? '${rawDesc.substring(0, 100)}...' : rawDesc);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Decide the "mobile" breakpoint either by available width or by overall screen width.
        final bool isNarrow =
            constraints.maxWidth < 360 ||
            MediaQuery.of(context).size.width < 600;

        Widget leftIcon = Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.work_outline, color: AppColors.primary, size: 22),
        );

        Widget centerContent = Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // meta row: location + jobType (wraps)
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(color: Colors.grey.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (jobType.isNotEmpty) ...[
                    const SizedBox(width: 12),
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
                ],
              ),

              const SizedBox(height: 5),

              // salary row
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
                      salary,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 3),

              // description snippet
              if (snippet.isNotEmpty)
                Text(
                  snippet,
                  style: const TextStyle(color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        );

        // Buttons (shared widget, styled)
        Widget viewButton = SizedBox(
          width: 88,
          height: 30,
          child: ElevatedButton(
            onPressed:
                onView ??
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => JobDetailPage(job: jobMap),
                    ),
                  );
                },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.zero,
              minimumSize: const Size(84, 36),
            ),
            child: const Text(
              'View',
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
        );

        Widget applyButton = SizedBox(
          width: 88,
          height: 30,
          child:
              context
                      .findAncestorStateOfType<_FeaturedJobsState>()
                      ?._isApplying(item.id.toString()) ==
                  true
              ? const Center(
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : OutlinedButton(
                  onPressed:
                      onApply ??
                      () {
                        final parent = context
                            .findAncestorStateOfType<_FeaturedJobsState>()!;
                        parent._applyForJob(_jobMapFromRaw());
                      },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Apply",
                    style: TextStyle(fontSize: 13, color: AppColors.primary),
                  ),
                ),
        );

        // Build layout
        if (isNarrow) {
          // Mobile: stack content vertically and place action buttons in a row under the content
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leftIcon,
                      const SizedBox(width: 14),
                      centerContent,
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Buttons row aligned to end but flexible
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // add spacing so buttons don't touch on very small widths
                      viewButton,
                      const SizedBox(width: 8),
                      applyButton,
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          // Wider: original horizontal layout with action column
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 14.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  leftIcon,
                  const SizedBox(width: 14),
                  centerContent,
                  const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      viewButton,
                      const SizedBox(height: 8),
                      applyButton,
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
