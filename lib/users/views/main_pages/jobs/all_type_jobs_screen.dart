import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/main_pages/search/job_detail_page.dart';

class AllJobsPage extends StatefulWidget {
  const AllJobsPage({super.key});

  @override
  State<AllJobsPage> createState() => _AllJobsPageState();
}

class _JobItem {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final Map<String, dynamic> raw;

  _JobItem({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.raw,
  });
}

class JobCard extends StatefulWidget {
  final Map<String, String> job;
  final VoidCallback onTap;
  final VoidCallback? onApply;
  final bool isApplying;

  JobCard({
    super.key,
    required Map<String, dynamic> job,
    required this.onTap,
    this.onApply,
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

    // Use LayoutBuilder to adapt layout based on available width
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final narrow =
            width < 520; // breakpoint: stack vertically on narrow cards
        final isWide = !narrow && MediaQuery.of(context).size.width > 900;

        Widget icon = Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.work_outline, color: AppColors.primary, size: 30),
        );

        Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title - constrain to avoid overflow
            Text(
              title,
              style: TextStyle(
                fontSize: isWide ? 18 : 15,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // location + experience
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

            // salary + type + openings
            Row(
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    salaryText,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // skills
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: skills.map((s) => _skillChip(s)).toList(),
            ),
          ],
        );

        // Build action buttons; they vary depending on narrow/wide
        Widget actionsColumn() {
          return Column(
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
                  onPressed: () => _onViewPressed(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
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
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),
            ],
          );
        }

        Widget actionsRowForNarrow() {
          // Horizontal buttons for mobile: they expand to fill available width
          return Column(
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
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => _onViewPressed(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: widget.isApplying
                          ? const Center(
                              child: SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        // Card container
        Widget cardChild;
        if (narrow) {
          // vertical layout on small widths: icon + content, then actions as a row underneath
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
              // use full-width row for buttons on mobile
              actionsRowForNarrow(),
            ],
          );
        } else {
          // horizontal layout for wider cards
          cardChild = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(width: 12),
              Expanded(child: content),
              const SizedBox(width: 12),
              // prevent actions from forcing overflow - wrap with ConstrainedBox
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 80, maxWidth: 110),
                child: actionsColumn(),
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

        // subtle hover effect only when wide enough
        if (isWide) {
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
    if (widget.onApply != null) widget.onApply!();
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

class _AllJobsPageState extends State<AllJobsPage> {
  List<String> carouselImages = [
    'assets/six.jpg',
    'assets/two.jpg',
    'assets/five.jpg',
  ];

  int _carouselIndex = 0;
  final String _query = '';
  final String _selectedFilter = 'All';

  List<_JobItem> _jobs = [];
  bool _loading = true;
  String? _error;

  String _profileCategory = '';
  String _profileJobType = '';

  final Set<String> _applyingJobIds = {};

  @override
  void initState() {
    super.initState();
    _fetchBanners().whenComplete(() => _loadJobsFromProfile());
  }

  bool _isApplying(String jobId) => _applyingJobIds.contains(jobId);

  String _chooseApplyEndpoint(String jobType) {
    final jt = jobType.toLowerCase();
    if (jt.contains('commission')) return 'applyCommissionBased';
    if (jt.contains('one') ||
        jt.contains('one-time') ||
        jt.contains('onetime') ||
        jt.contains('one time')) {
      return 'applyOneTimeBased';
    }
    if (jt.contains('project') ||
        jt.contains('projects') ||
        jt.contains('freelance') ||
        jt.contains('it')) {
      return 'applyProject';
    }
    return 'applySalayBased';
  }

  Future<void> _applyForJob(Map<String, dynamic> rawJob) async {
    final jobId = (rawJob['id'] ?? rawJob['job_id'] ?? '').toString();
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

    final endpoint = _chooseApplyEndpoint(_profileJobType);
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
        final message = jsonBody['message']?.toString() ?? 'Response received';

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
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

  Future<void> _fetchBanners() async {
    try {
      final uri = Uri.parse("${ApiConstants.baseUrl}getBanner");
      if (kDebugMode) {
        print('🔁 Fetching banners -> URL: $uri');
      }

      final resp = await http.get(uri);

      if (kDebugMode) {
        print('⬅️ Banners response status: ${resp.statusCode}');
        print('⬅️ Banners response body: ${resp.body}');
      }

      if (resp.statusCode != 200) {
        if (kDebugMode) print('⚠️ getBanner returned ${resp.statusCode}');
        return;
      }

      final decoded = jsonDecode(resp.body);
      final status = decoded['status'] ?? decoded['success'];
      if ((status == 1 || status == true) && decoded['data'] != null) {
        final List<dynamic> data = decoded['data'];
        final images = data
            .map(
              (item) => item is Map && item['image'] != null
                  ? item['image'].toString()
                  : null,
            )
            .whereType<String>()
            .toList();

        if (images.isNotEmpty) {
          setState(() {
            carouselImages = images;
          });
          if (kDebugMode) {
            print('✅ Loaded ${images.length} banners for carousel');
          }
        } else {
          if (kDebugMode) {
            print(
              '⚠️ No images found in getBanner response; keeping asset fallback',
            );
          }
        }
      } else {
        if (kDebugMode) print('⚠️ getBanner returned no data or status!=1');
      }
    } catch (e, st) {
      if (kDebugMode) print('❌ Error fetching banners: $e\n$st');
      // keep default assets
    }
  }

  Future<void> _loadJobsFromProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final category = (await SessionManager.getValue('category')) ?? '';
      final jobType = (await SessionManager.getValue('job_type')) ?? '';

      // store locally for UI (carousel overlay)
      setState(() {
        _profileCategory = category.toString();
        _profileJobType = jobType.toString();
      });

      if (category.toString().isEmpty) {
        setState(() {
          _jobs = [];
          _loading = false;
          _error = 'No category set in profile.';
        });
        return;
      }

      final jt = _profileJobType.toLowerCase();
      String endpoint;
      Map<String, dynamic> body;

      if (jt.contains('commission')) {
        endpoint = 'commissionJobsByCategory';
        body = {'category': _profileCategory};
      } else if (jt.contains('one') ||
          jt.contains('one-time') ||
          jt.contains('onetime') ||
          jt.contains('one time')) {
        endpoint = 'oneTimeJobsByCategory';
        body = {'category': _profileCategory};
      } else if (jt.contains('project') ||
          jt.contains('projects') ||
          jt.contains('it') ||
          jt.contains('freelance')) {
        endpoint = 'getProjectsByCategory';
        body = {'category': _profileCategory};
      } else {
        endpoint = 'salaryJobsByCategory';
        body = {'category': _profileCategory};
      }

      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");

      if (kDebugMode) {
        print('🔁 Fetching jobs for profile -> endpoint: $endpoint');
        print('🔁 Request URL: $uri');
        print('🔁 Request body: ${jsonEncode(body)}');
        print(
          '🔁 Stored job_type: "$_profileJobType", stored category: "$_profileCategory"',
        );
      }

      final resp = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (kDebugMode) {
        print('⬅️ Response status: ${resp.statusCode}');
        print('⬅️ Response body: ${resp.body}');
      }

      if (resp.statusCode != 200) {
        throw Exception('Server returned ${resp.statusCode}');
      }

      final decoded = jsonDecode(resp.body);
      if (decoded['success'] != true || decoded['data'] == null) {
        throw Exception(decoded['message'] ?? 'Invalid response');
      }

      final List<dynamic> data = decoded['data'];
      final normalized = data.map<_JobItem>((raw) {
        final map = Map<String, dynamic>.from(raw);
        final title = map['title']?.toString() ?? 'Untitled';
        final location = map['location']?.toString() ?? '';
        final employerId = map['employer_id']?.toString() ?? '';
        String company = '';
        if (map.containsKey('company')) {
          company = map['company']?.toString() ?? '';
        } else {
          company = map['contact_email']?.toString() ?? 'Employer $employerId';
        }

        String salaryDisplay = '';
        if (map.containsKey('salary_min') || map.containsKey('salary_max')) {
          final min = map['salary_min']?.toString() ?? '0';
          final max = map['salary_max']?.toString() ?? '0';
          salaryDisplay = '₹$min - ₹$max / ${map['salary_type'] ?? 'month'}';
        } else if (map.containsKey('payment_amount')) {
          salaryDisplay = '₹${map['payment_amount']}';
        } else if (map.containsKey('potential_earning')) {
          salaryDisplay = 'Potential: ₹${map['potential_earning']}';
        } else if (map.containsKey('budget_min') ||
            map.containsKey('budget_max')) {
          final min = map['budget_min']?.toString() ?? '0';
          final max = map['budget_max']?.toString() ?? '0';
          salaryDisplay = '₹$min - ₹$max (${map['budget_type'] ?? ''})';
        } else {
          salaryDisplay = map['salary']?.toString() ?? '';
        }

        return _JobItem(
          id: map['id']?.toString() ?? '',
          title: title,
          company: company,
          location: location,
          salary: salaryDisplay,
          raw: map,
        );
      }).toList();

      setState(() {
        _jobs = normalized;
        _loading = false;
        _error = null;
      });
    } catch (e, st) {
      if (kDebugMode) {
        print('❌ Error loading jobs: $e\n$st');
      }
      setState(() {
        _jobs = [];
        _loading = false;
        _error = 'Failed to load jobs: ${e.toString()}';
      });
    }
  }

  List<_JobItem> get _filteredJobs {
    final q = _query.trim().toLowerCase();
    return _jobs.where((job) {
      final matchesQuery =
          q.isEmpty ||
          job.title.toLowerCase().contains(q) ||
          job.company.toLowerCase().contains(q);
      final matchesFilter =
          _selectedFilter == 'All' ||
          (_selectedFilter == 'Remote' &&
              job.location.toLowerCase().contains('remote'));
      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // responsive breakpoints
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1000;
    final bool isDesktop = width >= 1000;
    final bool showDrawer = !isDesktop;

    final sidePadding = isDesktop ? 56.0 : (isTablet ? 24.0 : 12.0);
    final carouselHeight = isDesktop ? 360.0 : (isTablet ? 260.0 : 200.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: showDrawer ? const AppDrawer() : null,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.primary,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Recommended Jobs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadJobsFromProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Carousel
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sidePadding,
                        vertical: 10,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          height: carouselHeight,
                          color: Colors.black12,
                          child: Stack(
                            children: [
                              CarouselSlider.builder(
                                itemCount: carouselImages.length,
                                itemBuilder: (context, index, realIdx) {
                                  final img = carouselImages[index];
                                  if (img.startsWith('http')) {
                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.network(
                                          img,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, progress) {
                                            if (progress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    progress.expectedTotalBytes !=
                                                        null
                                                    ? progress.cumulativeBytesLoaded /
                                                          (progress
                                                                  .expectedTotalBytes ??
                                                              1)
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                final fallback = carouselImages
                                                    .firstWhere(
                                                      (e) => e.startsWith(
                                                        'assets/',
                                                      ),
                                                      orElse: () =>
                                                          'assets/six.jpg',
                                                    );
                                                return Image.asset(
                                                  fallback,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.45),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(img, fit: BoxFit.cover),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.45),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                                options: CarouselOptions(
                                  viewportFraction: 1.0,
                                  height: carouselHeight,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) =>
                                      setState(() => _carouselIndex = index),
                                ),
                              ),
                              Positioned(
                                left: isDesktop
                                    ? sidePadding
                                    : (isTablet ? 24 : 16),
                                bottom: isDesktop ? 36 : 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _recommendationText,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isDesktop
                                            ? 22
                                            : (isTablet ? 16 : 14),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _profileCategory.isNotEmpty ||
                                              _profileJobType.isNotEmpty
                                          ? 'Showing ${_profileJobType.isNotEmpty ? _profileJobType : 'jobs'} in ${_profileCategory.isNotEmpty ? _profileCategory : 'your category'}'
                                          : 'Explore jobs that match your profile',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: isDesktop
                                            ? 14
                                            : (isTablet ? 12 : 11),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${_carouselIndex + 1}/${carouselImages.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Content area
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sidePadding),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),

                          if (_loading)
                            const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (_error != null)
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Center(
                                child: Text(
                                  _error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            )
                          else if (_jobs.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(
                                child: Text('No jobs found for your profile'),
                              ),
                            )
                          else
                            // Responsive list/grid: only desktop uses 2 columns to avoid overflow
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final displayJobs = _filteredJobs;
                                final useGrid =
                                    isDesktop; // only desktop uses grid
                                if (!useGrid) {
                                  // simple vertical list - safe for smaller widths
                                  return Column(
                                    children: displayJobs.map((job) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12.0,
                                        ),
                                        child: JobCard(
                                          job: job.raw.map(
                                            (k, v) => MapEntry(
                                              k.toString(),
                                              v?.toString() ?? '',
                                            ),
                                          ),
                                          onTap: () =>
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => JobDetailPage(
                                                    job: job.raw.map(
                                                      (k, v) => MapEntry(
                                                        k.toString(),
                                                        v?.toString() ?? '',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          onApply: () => _applyForJob(job.raw),
                                          isApplying: _isApplying(job.id),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                } else {
                                  // desktop: grid with controlled aspect ratio
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 12,
                                          crossAxisSpacing: 12,
                                          // slightly taller cards to avoid internal overflow
                                          childAspectRatio: 3.2,
                                        ),
                                    itemCount: displayJobs.length,
                                    itemBuilder: (context, idx) {
                                      final job = displayJobs[idx];
                                      return JobCard(
                                        job: job.raw.map(
                                          (k, v) => MapEntry(
                                            k.toString(),
                                            v?.toString() ?? '',
                                          ),
                                        ),
                                        onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => JobDetailPage(
                                              job: job.raw.map(
                                                (k, v) => MapEntry(
                                                  k.toString(),
                                                  v?.toString() ?? '',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onApply: () => _applyForJob(job.raw),
                                        isApplying: _isApplying(job.id),
                                      );
                                    },
                                  );
                                }
                              },
                            ),

                          const SizedBox(height: 40),
                        ],
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
  }

  String get _recommendationText {
    final cat = _profileCategory.trim();
    var jt = _profileJobType.trim();
    if (jt.isEmpty && cat.isEmpty) return 'Recommended jobs for you';
    final normalized = <String, String>{
      'salary-based': 'Salary jobs',
      'salary': 'Salary jobs',
      'one-time': 'One-time gigs',
      'one time': 'One-time gigs',
      'onetime': 'One-time gigs',
      'commission-based': 'Commission roles',
      'commission': 'Commission roles',
      'projects': 'Projects',
      'project': 'Projects',
      'freelance': 'Projects',
    };

    final jtLower = jt.toLowerCase();
    String jtLabel = normalized.entries
        .firstWhere(
          (e) => jtLower.contains(e.key.toLowerCase()),
          orElse: () => const MapEntry('', ''),
        )
        .value;

    if (jtLabel.isEmpty) {
      jt = jt.replaceAll('-', ' ').replaceAll('based', '').trim();
      if (jt.isEmpty) jt = 'Jobs';
      jtLabel = jt[0].toUpperCase() + jt.substring(1);
    }

    if (cat.isEmpty) return 'Recommending $jtLabel for your profile';
    return 'Recommending $jtLabel in $cat';
  }
}
