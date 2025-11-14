
import 'dart:async';

import 'package:flutter/material.dart';

class AutoBannerSlider extends StatefulWidget {
  final List<String> images;
  final double desktopHeight;
  final double mobileHeight;
  final Duration autoPlayInterval;
  final double borderRadius;
  final double maxContentWidth; // 👈 NEW

  const AutoBannerSlider({
    Key? key,
    required this.images,
    this.desktopHeight = 290,
    this.mobileHeight = 200,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.borderRadius = 14.0,
    this.maxContentWidth = 1000, // 👈 controls max width of carousel
  }) : super(key: key);

  @override
  State<AutoBannerSlider> createState() => _AutoBannerSliderState();
}

class _AutoBannerSliderState extends State<AutoBannerSlider> {
  late final PageController _controller;
  Timer? _timer;
  int _currentIndex = 0;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1.0, initialPage: 0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted) return;
      if (_userInteracting) return;
      final next = (_currentIndex + 1) % widget.images.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _controller.dispose();
    super.dispose();
  }

  void _onUserPointerDown(_) {
    _userInteracting = true;
    _stopAutoPlay();
  }

  void _onUserPointerUp(_) {
    Future.delayed(const Duration(milliseconds: 700), () {
      _userInteracting = false;
      if (mounted) _startAutoPlay();
    });
  }

  void _prev() {
    final prev =
        (_currentIndex - 1 + widget.images.length) % widget.images.length;
    _controller.animateToPage(
      prev,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    final next = (_currentIndex + 1) % widget.images.length;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final height = isDesktop ? widget.desktopHeight : widget.mobileHeight;

    return Center(
      // 👈 centers entire slider in screen
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxContentWidth, // 👈 limits carousel width
        ),
        child: Column(
          children: [
            SizedBox(
              height: height,
              child: Listener(
                onPointerDown: _onUserPointerDown,
                onPointerUp: _onUserPointerUp,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                      controller: _controller,
                      itemCount: widget.images.length,
                      onPageChanged: (i) => setState(() => _currentIndex = i),
                      padEnds: false,
                      itemBuilder: (context, index) {
                        final img = widget.images[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _bannerCard(
                            img,
                            height,
                            widget.borderRadius,
                            width,
                          ),
                        );
                      },
                    ),

                    // left arrow
                    Positioned(
                      left: 0,
                      child: _arrowButton(
                        icon: Icons.chevron_left,
                        onTap: _prev,
                      ),
                    ),

                    // right arrow
                    Positioned(
                      right: 0,
                      child: _arrowButton(
                        icon: Icons.chevron_right,
                        onTap: _next,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // indicator dots centered
            SizedBox(
              height: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (i) {
                  final active = i == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: active ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.blue.shade700
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerCard(
    String imagePath,
    double height,
    double radius,
    double width,
  ) {
    return Center(
      child: Material(
        elevation: 5,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(radius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            height: height,
            width: double.infinity,
            color: Colors.grey.shade100,
            child: _buildImage(imagePath),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.broken_image, size: 36, color: Colors.black26),
      ),
    );
  }

  Widget _arrowButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.white,
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          onTap();
          _onUserPointerDown(null);
          _onUserPointerUp(null);
        },
        child: const SizedBox(
          height: 40,
          width: 40,
          child: Icon(Icons.chevron_left, color: Colors.black87),
        ),
      ),
    );
  }
}