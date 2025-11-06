import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/side_bar_dashboard/admin_dashboard.dart';
import 'package:jobshub/common/views/onboarding_screen.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_dashboard.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_dashboard.dart';
import 'package:jobshub/users/views/bottomnav_drawer_dashboard/bottom_nav.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  String _displayedText = "";
  final String _fullText = "Connecting talent with opportunity";

  bool _startedTyping = false;
  late int _typingSpeed;

  @override
  void initState() {
    super.initState();

    // 🎬 Logo scale animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // ⏳ Navigate after animation delay
    Future.delayed(const Duration(seconds: 4), () {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    final adminLogin = await SessionManager.getValue('admin_login');
    final userId = await SessionManager.getValue('user_id');
    final employerId = await SessionManager.getValue('employer_id');
    final hrId = await SessionManager.getValue('hr_id');

    // Widget nextScreen = const LoginScreen();
    Widget nextScreen = const OnboardingPage();

    if (adminLogin == 'true') {
      nextScreen = AdminDashboard();
    } else if (userId != null && userId.isNotEmpty) {
      nextScreen = const DashBoardScreen();
    } else if (employerId != null && employerId.isNotEmpty) {
      nextScreen = EmployerDashboardPage();
    } else if (hrId != null && hrId.isNotEmpty) {
      nextScreen = HrDashboard();
    }

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => nextScreen),
        (route) => false,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isWeb = MediaQuery.of(context).size.width > 800;
    _typingSpeed = isWeb ? 40 : 70;

    if (!_startedTyping) {
      _startedTyping = true;
      _startTypingEffect();
    }
  }

  void _startTypingEffect() {
    int index = 0;
    Timer.periodic(Duration(milliseconds: _typingSpeed), (timer) {
      if (index < _fullText.length) {
        setState(() {
          _displayedText = _fullText.substring(0, index + 1);
        });
        index++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _textColor => Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : const Color(0xff2c3e50);

  Color get _subTextColor => Theme.of(context).brightness == Brightness.dark
      ? Colors.white70
      : Colors.black54;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xff0f2027),
                    const Color(0xff203a43),
                    const Color(0xff2c5364),
                  ]
                : [const Color(0xffe0eafc), const Color(0xfff7f8fc)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 80 : 24),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/job_bgr.png", height: isWeb ? 220 : 160),
                  const SizedBox(height: 24),
                  Text(
                    "Badhyata",
                    style: TextStyle(
                      fontSize: isWeb ? 40 : 30,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 120),
                    child: Text(
                      _displayedText,
                      key: ValueKey(_displayedText),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isWeb ? 18 : 15,
                        color: _subTextColor,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 4,
                    width: isWeb ? 180 : 140,
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff004aad),
                      backgroundColor: isDark
                          ? Colors.white10
                          : Colors.grey.shade300,
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
