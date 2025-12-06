// users/views/bottomnav_sidebar/user_sidedrawer.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_routes.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/common/views/onboarding/mobile_onboarding_screen.dart';
import 'package:jobshub/common/views/onboarding/web_onboarding_screen.dart';
import 'package:jobshub/users/views/drawer_pages/UserNotificationPage.dart';
import 'package:jobshub/users/views/drawer_pages/kyc_upload.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/bottom_nav.dart';
import 'package:jobshub/users/views/drawer_pages/job_application/my_salary_based_job.dart';
import 'package:jobshub/users/views/drawer_pages/profile/profile_screen.dart';
import 'package:jobshub/users/views/drawer_pages/leaves_attendence/user_attendance.dart';
import 'package:jobshub/users/views/drawer_pages/job_application/user_commision_based_jobs.dart';
import 'package:jobshub/users/views/drawer_pages/query_portal.dart';
import 'package:jobshub/users/views/drawer_pages/faq.dart';
import 'package:jobshub/users/views/drawer_pages/leaves_attendence/user_leave_request.dart';
import 'package:jobshub/users/views/drawer_pages/project_application/projects_screen.dart';
import 'package:jobshub/users/views/drawer_pages/job_application/user_one_time_recruit.dart';
import 'package:jobshub/common/utils/app_color.dart';

/// ------------------------
/// Top-level helpers
/// ------------------------

Future<String> _getStoredJobType() async {
  final jt = await SessionManager.getValue('job_type') ?? '';
  return _normalizeJobType(jt.toString());
}

/// Normalize job_type variants to canonical labels used locally
String _normalizeJobType(String raw) {
  String s = raw.toString().trim();
  final low = s.toLowerCase();
  if (low.contains('commission') ||
      low.contains('commision') ||
      low.contains('commission-based')) {
    return 'commission';
  } else if (low.contains('salary')) {
    return 'salary';
  } else if (low.contains('one') ||
      low.contains('one-time') ||
      low.contains('onetime') ||
      low.contains('one time')) {
    return 'one-time';
  } else if (low.contains('project') ||
      low.contains('projects') ||
      low.contains('freelance') ||
      low.contains('it')) {
    return 'project';
  }
  // fallback: return trimmed original (could be '', or some other string)
  return s;
}

/// Build menu children widgets for a given jobType.
/// isWeb controls compact vs full styles. isCollapsed controls icon visibility in web.
List<Widget> _buildMenuChildrenForType(
  BuildContext context,
  String jobType, {
  required bool isWeb,
  required bool isCollapsed,
}) {
  // jobType expected to be normalized (see _getStoredJobType)
  final normalized = jobType.toLowerCase();

  // Project
  Widget projItem = ListTile(
    leading: const Icon(
      Icons.folder_copy_outlined,
      color: Colors.black87,
      size: 22,
    ),
    title: Text(
      "Projects",
      style: TextStyle(
        fontSize: isWeb ? 13.5 : 15,
        color: Colors.black87,
        fontWeight: isWeb ? FontWeight.w400 : FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    dense: isWeb,
    contentPadding: EdgeInsets.only(left: isWeb ? (isCollapsed ? 12 : 16) : 0),
    onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (_) => Projects())),
  );

  // Salary
  Widget salaryItem = ListTile(
    leading: const Icon(Icons.work_outline, color: Colors.black87, size: 22),
    title: Text(
      "Salary Jobs",
      style: TextStyle(
        fontSize: isWeb ? 13.5 : 15,
        color: Colors.black87,
        fontWeight: isWeb ? FontWeight.w400 : FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    dense: isWeb,
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SalaryJobsScreen()),
    ),
  );

  // One-time
  Widget oneTimeItem = ListTile(
    leading: const Icon(Icons.work_outline, color: Colors.black87, size: 22),
    title: Text(
      "One-Time Jobs",
      style: TextStyle(
        fontSize: isWeb ? 13.5 : 15,
        color: Colors.black87,
        fontWeight: isWeb ? FontWeight.w400 : FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    dense: isWeb,
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OneTimeRecruitmentScreen()),
    ),
  );

  // Commission
  Widget commissionItem = ListTile(
    leading: const Icon(Icons.work_outline, color: Colors.black87, size: 22),
    title: Text(
      "Commission Jobs",
      style: TextStyle(
        fontSize: isWeb ? 13.5 : 15,
        color: Colors.black87,
        fontWeight: isWeb ? FontWeight.w400 : FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    dense: isWeb,
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CommissionJobsScreen()),
    ),
  );

  // Show everything if empty or 'all'
  if (normalized.isEmpty || normalized == 'all') {
    return [projItem, salaryItem, oneTimeItem, commissionItem];
  }

  // normalized values: 'project', 'salary', 'one-time', 'commission'
  if (normalized.contains('project')) return [projItem];
  if (normalized.contains('salary')) return [salaryItem];
  if (normalized.contains('one') ||
      normalized.contains('one-time') ||
      normalized.contains('onetime'))
    return [oneTimeItem];
  if (normalized.contains('commission')) return [commissionItem];

  // fallback
  return [projItem, salaryItem, oneTimeItem, commissionItem];
}

/// ------------------------
/// App Drawer Widgets
/// ------------------------

/// ✅ MAIN WRAPPER that decides which sidebar to show
class AppDrawer extends StatelessWidget {
  final bool isWeb;
  final bool isCollapsed;
  final ValueChanged<bool>? onToggle;

  const AppDrawer({
    super.key,
    this.isWeb = false,
    this.isCollapsed = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return AppDrawerWeb(isCollapsed: isCollapsed, onToggle: onToggle);
    } else {
      return const AppDrawerMobile();
    }
  }
}

////////////////////////////////////////////////////////////////
/// 📱 FULL MOBILE VERSION
////////////////////////////////////////////////////////////////
class AppDrawerMobile extends StatelessWidget {
  const AppDrawerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          width: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.white, AppColors.white.withOpacity(0.95)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeaderMobile(),

              Expanded(
                child: FutureBuilder<String>(
                  future: _getStoredJobType(),
                  builder: (context, snap) {
                    final jobType = snap.data ?? '';

                    final preItems = <Widget>[
                      _sectionTitle("👤 Dashboard"),
                      _sidebarItem(context, Icons.home_outlined, "Home", () {
                        Navigator.pushNamed(context, AppRoutes.userDashboard);
                      }),

                      _sidebarItem(
                        context,
                        Icons.person_outline,
                        "Profile",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                      ),
                      _sidebarItem(context, Icons.approval, "KYC", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KycUploadPage(),
                          ),
                        );
                      }),

                      _sidebarItem(
                        context,
                        Icons.notifications_outlined,
                        "Notifications",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const UserNotificationPage(), // <- your screen
                            ),
                          );
                        },
                      ),
                    ];

                    final dynamicChildren = _buildMenuChildrenForType(
                      context,
                      jobType,
                      isWeb: false,
                      isCollapsed: false,
                    );

                    final postItems = <Widget>[
                      const Divider(height: 25),
                      _sectionTitle("🧭 Support & Others"),
                      _sidebarItem(
                        context,
                        Icons.contact_mail_outlined,
                        "Query Portal",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserQueryToAdminPage(),
                            ),
                          );
                        },
                      ),
                      _sidebarItem(context, Icons.help_outline, "FAQ", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Faq()),
                        );
                      }),
                      _sidebarItem(context, Icons.logout, "Logout", () async {
                        await SessionManager.clearAll();
                        debugPrint("✅ SharedPreferences cleared successfully!");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text("Logged out successfully."),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // 👇 Named route: goes to onboarding, which itself picks web/mobile
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (route) => false,
                        );
                      }),
                    ];

                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      children: [...preItems, ...dynamicChildren, ...postItems],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderMobile() {
    Future<Map<String, String>> _fetchProfile() async {
      final first = await SessionManager.getValue('first_name') ?? '';
      final last = await SessionManager.getValue('last_name') ?? '';
      final email = await SessionManager.getValue('email') ?? '';
      final image = await SessionManager.getValue('profile_image') ?? '';

      final fullName = (first + ' ' + last).trim();
      return {
        'name': fullName.isNotEmpty ? fullName : '',
        'email': email,
        'image': image,
      };
    }

    return FutureBuilder<Map<String, String>>(
      future: _fetchProfile(),
      builder: (context, snapshot) {
        final name = (snapshot.data?['name'] ?? '').isNotEmpty
            ? snapshot.data!['name']!
            : 'No data';
        final email = (snapshot.data?['email'] ?? '').isNotEmpty
            ? snapshot.data!['email']!
            : 'No data';
        final image = snapshot.data?['image'] ?? '';

        ImageProvider avatarImage;
        if (image.isNotEmpty &&
            (image.startsWith('http') || image.startsWith('https'))) {
          avatarImage = NetworkImage(image);
        } else {
          avatarImage = const AssetImage('assets/job_bgr.png');
        }

        // CURVED header: bottom-left curve similar to HR header
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.95),
                  AppColors.primary.withOpacity(0.75),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // If you want an elevated look add a subtle shadow:
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: SizedBox(
                      height: 76,
                      width: 76,
                      child: Image(
                        image: avatarImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/job_bgr.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sidebarItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _expTileChild(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 14.5)),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// 💻 WEB VERSION (FULL COLLAPSIBLE SIDEBAR)
////////////////////////////////////////////////////////////////
class AppDrawerWeb extends StatelessWidget {
  final bool isCollapsed;
  final ValueChanged<bool>? onToggle;

  const AppDrawerWeb({super.key, required this.isCollapsed, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isCollapsed ? 80 : 270,
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.white, AppColors.white.withOpacity(0.95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeaderWeb(),
          const Divider(height: 0),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitleWeb("👤 Dashboard"),
                  _menuItem(
                    context,
                    Icons.home_outlined,
                    "Home",
                    () => Navigator.pushNamed(context, AppRoutes.userDashboard),
                  ),

                  _menuItem(
                    context,
                    Icons.person_outline,
                    "Profile",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
                  ),
                  _menuItem(
                    context,
                    Icons.approval,
                    "KYC",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KycUploadPage()),
                    ),
                  ),

                  _menuItem(
                    context,
                    Icons.notifications_outlined,
                    "Notifications",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserNotificationPage(),
                      ),
                    ),
                  ),

                  // DYNAMIC APPLICATIONS AREA (web)
                  FutureBuilder<String>(
                    future: _getStoredJobType(),
                    builder: (context, snap) {
                      final jobType = (snap.data ?? '').toLowerCase();

                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }

                      final children = _buildMenuChildrenForType(
                        context,
                        jobType,
                        isWeb: true,
                        isCollapsed: isCollapsed,
                      );

                      // If only one relevant item, render with _menuItem (keeps icon + spacing identical to other menu entries)
                      if (children.length == 1) {
                        if (jobType.contains('project')) {
                          return _menuItem(
                            context,
                            Icons.folder_copy_outlined,
                            "Projects",
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => Projects()),
                            ),
                          );
                        }
                        if (jobType.contains('salary')) {
                          return _menuItem(
                            context,
                            Icons.work_outline,
                            "Salary Jobs",
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SalaryJobsScreen(),
                              ),
                            ),
                          );
                        }
                        if (jobType.contains('one') ||
                            jobType.contains('one-time') ||
                            jobType.contains('onetime')) {
                          return _menuItem(
                            context,
                            Icons.work_outline,
                            "One-Time Jobs",
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OneTimeRecruitmentScreen(),
                              ),
                            ),
                          );
                        }
                        if (jobType.contains('commission')) {
                          return _menuItem(
                            context,
                            Icons.work_outline,
                            "Commission Jobs",
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CommissionJobsScreen(),
                              ),
                            ),
                          );
                        }

                        // fallback: just return the child (shouldn't usually happen)
                        return children.first;
                      }

                      // multiple children -> show grouped expansion
                      return _expansionGroup(
                        context,
                        Icons.work_outline,
                        "Job Applications",
                        children,
                      );
                    },
                  ),

                  // Leaves & Attendance and rest unchanged
                  _expansionGroup(
                    context,
                    Icons.calendar_today_outlined,
                    "Leaves & Attendance",
                    [
                      _expTileChild(
                        context,
                        "Manage Leaves",
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployeeLeaveRequestScreen(),
                          ),
                        ),
                      ),
                      _expTileChild(
                        context,
                        "Attendance",
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployeeAttendanceScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  _dividerWeb(),
                  _menuItem(
                    context,
                    Icons.contact_mail_outlined,
                    "Query Portal",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserQueryToAdminPage(),
                      ),
                    ),
                  ),
                  _menuItem(
                    context,
                    Icons.help_outline,
                    "FAQ",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Faq()),
                    ),
                  ),
                  _menuItem(context, Icons.logout, "Logout", () async {
                    await SessionManager.clearAll();
                    debugPrint("✅ SharedPreferences cleared successfully!");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Logged out successfully."),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  }),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IconButton(
              icon: Icon(
                isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: AppColors.primary,
              ),
              onPressed: () => onToggle?.call(!isCollapsed),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderWeb() {
    Future<Map<String, String>> _fetchProfile() async {
      final first = await SessionManager.getValue('first_name') ?? '';
      final last = await SessionManager.getValue('last_name') ?? '';
      final email = await SessionManager.getValue('email') ?? '';
      final image = await SessionManager.getValue('profile_image') ?? '';
      final fullName = (first + ' ' + last).trim();
      return {
        'name': fullName.isNotEmpty ? fullName : '',
        'email': email,
        'image': image,
      };
    }

    return FutureBuilder<Map<String, String>>(
      future: _fetchProfile(),
      builder: (context, snapshot) {
        final name = (snapshot.data?['name'] ?? '').isNotEmpty
            ? snapshot.data!['name']!
            : 'No data';
        final email = (snapshot.data?['email'] ?? '').isNotEmpty
            ? snapshot.data!['email']!
            : 'No data';
        final image = snapshot.data?['image'] ?? '';

        ImageProvider avatarImage;
        if (image.isNotEmpty &&
            (image.startsWith('http') || image.startsWith('https'))) {
          avatarImage = NetworkImage(image);
        } else {
          avatarImage = const AssetImage('assets/job_bgr.png');
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.95),
                AppColors.primary.withOpacity(0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipRect(
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: avatarImage,
                  backgroundColor: Colors.white,
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isCollapsed ? 0 : 16,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black87, size: 22),
            if (!isCollapsed) ...[
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _expansionGroup(
    BuildContext context,
    IconData icon,
    String title,
    List<Widget> children,
  ) {
    if (isCollapsed) {
      return Tooltip(
        message: title,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Icon(icon, color: Colors.black87),
        ),
      );
    }
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.black87, size: 22),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
        ),
        childrenPadding: const EdgeInsets.only(left: 20, bottom: 6),
        iconColor: AppColors.primary,
        collapsedIconColor: Colors.black54,
        children: children,
      ),
    );
  }

  Widget _expTileChild(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(title, style: const TextStyle(fontSize: 13.5)),
      onTap: onTap,
    );
  }

  Widget _sectionTitleWeb(String title) {
    if (isCollapsed) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 0, 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _dividerWeb() =>
      isCollapsed ? const SizedBox.shrink() : const Divider(height: 20);
}

class AppDrawerWrapper extends StatefulWidget {
  final Widget child;

  const AppDrawerWrapper({super.key, required this.child});

  @override
  State<AppDrawerWrapper> createState() => _AppDrawerWrapperState();
}

class _AppDrawerWrapperState extends State<AppDrawerWrapper> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb && MediaQuery.of(context).size.width > 800;

    if (isWeb) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Row(
          children: [
            AppDrawer(
              isWeb: true,
              isCollapsed: _isCollapsed,
              onToggle: (value) => setState(() => _isCollapsed = value),
            ),
            Expanded(child: widget.child),
          ],
        ),
      );
    } else {
      return Scaffold(
        drawer: const AppDrawer(),
        backgroundColor: Colors.grey.shade100,
        body: widget.child,
      );
    }
  }
}
