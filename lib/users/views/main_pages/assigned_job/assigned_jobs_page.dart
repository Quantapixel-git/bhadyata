// users/views/main_pages/assigned/assigned_jobs_page.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/users/views/main_pages/search/job_detail_page.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';

/// Locked Assigned Job page (demo)
/// For now this page will always show "No assigned job" UI.
/// You can re-enable dynamic behavior later by restoring the source list logic.
class AssignedJobsPage extends StatefulWidget {
  const AssignedJobsPage({super.key});

  @override
  State<AssignedJobsPage> createState() => _AssignedJobsPageState();
}

class _AssignedJobsPageState extends State<AssignedJobsPage> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Keep loading false so UI immediately shows locked "no job" state.
    // If you want a small loader on open, set _loading = true and call a fake delay.
    _loading = false;
  }

  Future<void> _refresh() async {
    // no-op for locked UI (keeps showing "no assigned job")
    await Future.delayed(const Duration(milliseconds: 250));
  }

  void _openDetail(Map<String, String> job) {
    // If needed later, navigate to JobDetailPage; currently not used because there's no job.
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => JobDetailPage(job: job)));
  }

  Widget _buildEmpty() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Column(
            children: const [
              Icon(Icons.assignment_late, size: 68, color: Colors.grey),
              SizedBox(height: 12),
              Text('No assigned job', style: TextStyle(fontSize: 18)),
              SizedBox(height: 6),
              Text(
                'You have no active assigned job at the moment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine whether to show mobile AppBar+Drawer.
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 1000; // show appbar on narrower screens

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      // show drawer for mobile; on wider screens you can place a persistent sidebar elsewhere
      drawer: isMobile ? const AppDrawer() : null,
      appBar: isMobile
          ? AppBar(
              backgroundColor: AppColors.primary,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Assigned Job',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _buildEmpty(),
      ),
    );
  }
}
