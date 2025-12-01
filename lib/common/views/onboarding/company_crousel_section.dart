
import 'dart:async';

import 'package:flutter/material.dart';

class CompanyCarousel extends StatefulWidget {
  final List<String> companies;
  final double height; // control image height
  final Duration autoPlayInterval;

  const CompanyCarousel({
    Key? key,
    required this.companies,
    this.height = 56,
    this.autoPlayInterval = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<CompanyCarousel> createState() => _CompanyCarouselState();
}

class _CompanyCarouselState extends State<CompanyCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  bool _userInteracting = false;

  // pick a large multiplier so we can scroll infinitely in both directions
  static const int _kLoopMultiplier = 1000;
  late final int _initialPage;

  @override
  void initState() {
    super.initState();
    // if no companies safe-guard
    final len = widget.companies.isEmpty ? 1 : widget.companies.length;
    _initialPage = len * _kLoopMultiplier;

    _pageController = PageController(
      viewportFraction: 0.22,
      initialPage: _initialPage,
    );

    // start auto-play after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoPlay());
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (widget.companies.isEmpty) return;
    _timer = Timer.periodic(widget.autoPlayInterval, (_) async {
      if (!mounted) return;
      if (_userInteracting) return;

      // get current page (may be fractional while animating)
      final currentPage = _pageController.hasClients
          ? (_pageController.page ?? _pageController.initialPage.toDouble())
          : _pageController.initialPage.toDouble();

      final nextPage = currentPage.toInt() + 1;

      try {
        await _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } catch (_) {
        // controller might be disposed between timer ticks — ignore.
      }
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  Widget _logoTile(String path, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Image.asset(
          path,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => SizedBox(
            height: height,
            child: const Icon(Icons.business, size: 28, color: Colors.black26),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companies = widget.companies;
    final len = companies.length;

    // If there are no logos, show nothing (or you can show a placeholder)
    if (len == 0) {
      return Column(
        children: const [
          SizedBox(height: 56),
          SizedBox(height: 18),
          Text(
            "No company logos",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(height: 25),
        const Text(
          "28L+ top companies trust badhyata for their hiring needs",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: widget.height,
          child: Listener(
            onPointerDown: (_) {
              // user pressed: pause autoplay
              _userInteracting = true;
              _stopAutoPlay();
            },
            onPointerUp: (_) {
              // user released: resume autoplay after small delay
              _userInteracting = false;
              Future.delayed(const Duration(milliseconds: 700), () {
                if (mounted && !_userInteracting) _startAutoPlay();
              });
            },
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                // map large index to actual company index using modulo
                final realIndex = index % len;
                final path = companies[realIndex];
                return _logoTile(path, widget.height);
              },
              // make itemCount null (infinite) by not setting it: builder will be infinite
              // but some Flutter versions require itemCount. We deliberately omit itemCount for infinite.
              onPageChanged: (_) {
                // nothing to do here; the mapping handles index->logo
              },
              padEnds: false,
            ),
          ),
        ),

        const SizedBox(height: 18),

        // caption under carousel
      ],
    );
  }
}