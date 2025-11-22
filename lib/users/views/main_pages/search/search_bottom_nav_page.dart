import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/users/views/main_pages/search/jobs_by_category.dart';
import 'package:jobshub/users/views/main_pages/common_search/search_placeholder.dart';

const String kApiBase = 'https://dialfirst.in/quantapixel/badhyata/api/';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;

  bool _loading = false;
  String? _error;

  // API model: id, category_name, image, ...
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filtered = [];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _fetchCategories();
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
    _debounce = Timer(const Duration(milliseconds: 250), () {
      final q = _searchCtrl.text.trim().toLowerCase();
      if (q.isEmpty) {
        setState(() => _filtered = List.from(_categories));
      } else {
        setState(() {
          _filtered = _categories.where((c) {
            final name = (c['category_name'] ?? '').toString().toLowerCase();
            return name.contains(q);
          }).toList();
        });
      }
    });
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // The endpoint in your Postman screenshot is GET getallcategory
      final uri = Uri.parse('${kApiBase}getallcategory');
      final res = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final json = jsonDecode(res.body);
        // Postman response had "status":1 and "data":[ ... ]
        final data = (json['data'] as List<dynamic>?) ?? [];

        final parsed = data.map<Map<String, dynamic>>((e) {
          if (e is Map<String, dynamic>) return e;
          return Map<String, dynamic>.from(e as Map);
        }).toList();

        setState(() {
          _categories = parsed;
          _filtered = List.from(parsed);
        });
      } else {
        setState(() {
          _error = 'Failed to load categories (${res.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching categories: $e';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 600;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: isWeb
              ? null
              : AppBar(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  centerTitle: true,
                  title: const Text(
                    "Search",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  leading: Builder(
                    builder: (context) => IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ),
          drawer: const AppDrawer(),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 80 : 16,
                  vertical: 16,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: isWeb ? 500 : double.infinity,
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
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 80 : 16,
                    vertical: 0,
                  ),
                  child: _buildContent(isWeb),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(bool isWeb) {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Loading categories...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _fetchCategories,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.inbox_outlined, size: 56, color: Colors.grey),
            SizedBox(height: 8),
            Text('No categories found', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWeb ? 4 : 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: isWeb ? 1.3 : 1.1,
      ),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final c = _filtered[index];
        final title = (c['category_name'] ?? 'Unknown').toString();
        final imageUrl = (c['image'] ?? '').toString();

        return _CategoryCard(
          title: title,
          imageUrl: imageUrl,
          isWeb: isWeb,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryJobsPage(category: title),
              ),
            );
          },
        );
      },
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final bool isWeb;
  final VoidCallback onTap;
  const _CategoryCard({
    required this.title,
    required this.imageUrl,
    required this.isWeb,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    Widget child = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: _hover && widget.isWeb
          ? (Matrix4.identity()..scale(1.04))
          : Matrix4.identity(),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _hover && widget.isWeb
            ? [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // show image if available else icon
            if (widget.imageUrl.isNotEmpty)
              SizedBox(
                height: 68,
                width: 68,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: AppColors.white,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.category,
                          color: AppColors.primary,
                          size: 34,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: AppColors.primary.withOpacity(0.06),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                    (progress.expectedTotalBytes ?? 1)
                              : null,
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              Icon(Icons.category, size: 48, color: AppColors.white),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );

    if (widget.isWeb) {
      child = MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: child,
      );
    }

    return child;
  }
}

class _HoverJobCardCategory extends StatefulWidget {
  final Map<String, String> job;
  final bool isWeb;
  final VoidCallback onTap;
  const _HoverJobCardCategory({
    required this.job,
    required this.isWeb,
    required this.onTap,
  });

  @override
  State<_HoverJobCardCategory> createState() => _HoverJobCardCategoryState();
}

class _HoverJobCardCategoryState extends State<_HoverJobCardCategory> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: _isHovered && widget.isWeb
          ? (Matrix4.identity()..scale(1.03))
          : Matrix4.identity(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: _isHovered && widget.isWeb
            ? [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.job["title"] ?? "",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            widget.job["company"] ?? "",
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                widget.job["location"] ?? "",
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: widget.onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text("View"),
            ),
          ),
        ],
      ),
    );

    if (widget.isWeb) {
      card = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: card,
      );
    }

    return GestureDetector(onTap: widget.onTap, child: card);
  }
}
