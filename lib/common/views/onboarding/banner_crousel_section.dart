import 'dart:async';
import 'package:flutter/material.dart';

class AutoBannerSlider extends StatefulWidget {
  final List<String> images;
  final double desktopHeight;
  final double mobileHeight;
  final Duration autoPlayInterval;
  final double borderRadius;
  final double maxContentWidth;

  const AutoBannerSlider({
    Key? key,
    required this.images,
    this.desktopHeight = 360,          // ⬅️ bigger by default
    this.mobileHeight = 220,           // ⬅️ a bit bigger on mobile too
    this.autoPlayInterval = const Duration(seconds: 4),
    this.borderRadius = 16.0,
    this.maxContentWidth = 1180,       // ⬅️ wider content area
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
    if (widget.images.isEmpty) return;

    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted || _userInteracting) return;
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

  void _onUserPointerDown(dynamic _) {
    _userInteracting = true;
    _stopAutoPlay();
  }

  void _onUserPointerUp(dynamic _) {
    Future.delayed(const Duration(milliseconds: 700), () {
      _userInteracting = false;
      if (mounted) _startAutoPlay();
    });
  }

  void _prev() {
    if (widget.images.isEmpty) return;
    final prev =
        (_currentIndex - 1 + widget.images.length) % widget.images.length;
    _controller.animateToPage(
      prev,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    if (widget.images.isEmpty) return;
    final next = (_currentIndex + 1) % widget.images.length;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final height = isDesktop ? widget.desktopHeight : widget.mobileHeight;
    final maxWidth = width < widget.maxContentWidth
        ? width - 32 // small side padding on very small screens
        : widget.maxContentWidth;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: _bannerCard(
                            img,
                            height,
                            widget.borderRadius,
                          ),
                        );
                      },
                    ),

                    // left arrow
                    Positioned(
                      left: 8,
                      child: _arrowButton(
                        icon: Icons.chevron_left,
                        onTap: _prev,
                      ),
                    ),

                    // right arrow
                    Positioned(
                      right: 8,
                      child: _arrowButton(
                        icon: Icons.chevron_right,
                        onTap: _next,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

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
  ) {
    return Material(
      elevation: 6,
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
    );
  }

  Widget _buildImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.broken_image, size: 36, color: Colors.black26),
      ),
    );
  }

  Widget _arrowButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          onTap();
          _onUserPointerDown(null);
          _onUserPointerUp(null);
        },
        child: SizedBox(
          height: 42,
          width: 42,
          child: Icon(icon, color: Colors.black87), // 👈 uses passed icon now
        ),
      ),
    );
  }
}
