import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jobshub/users/view/auth/login_screen.dart';

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

    // ⏳ Navigate after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ Safe place to use MediaQuery
    final isWeb = MediaQuery.of(context).size.width > 800;
    _typingSpeed = isWeb ? 40 : 70;

    // Start typing only once
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
                    "Bhadyata",
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
