import 'dart:async';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final Duration autoScrollDuration;
  final double height;
  final BoxFit fit;

  const ImageCarousel({
    super.key,
    required this.imagePaths,
    this.autoScrollDuration = const Duration(seconds: 5),
    this.height = 200,
    this.fit = BoxFit.cover,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(widget.autoScrollDuration, (timer) {
      if (_pageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % widget.imagePaths.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Image Carousel
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.imagePaths.length,
              itemBuilder: (context, index) {
                return _buildImageWithOverlay(widget.imagePaths[index], index);
              },
            ),

            // Page Indicators
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imagePaths.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithOverlay(String imagePath, int index) {
    return Image.asset(
      imagePath,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to gradient background if image fails to load
        return Container(
          decoration: BoxDecoration(
            gradient: _getGradientForIndex(index),
          ),
          child: Center(
            child: Icon(
              _getIconForIndex(index),
              size: 80,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  LinearGradient _getGradientForIndex(int index) {
    switch (index) {
      case 0:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade400,
            Colors.green.shade600,
            Colors.green.shade800
          ],
        );
      case 1:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade600,
            Colors.blue.shade800
          ],
        );
      case 2:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade400,
            Colors.orange.shade600,
            Colors.orange.shade800
          ],
        );
      case 3:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade400,
            Colors.purple.shade600,
            Colors.purple.shade800
          ],
        );
      case 4:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.teal.shade400,
            Colors.teal.shade600,
            Colors.teal.shade800
          ],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade400,
            Colors.green.shade600,
            Colors.green.shade800
          ],
        );
    }
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.agriculture;
      case 1:
        return Icons.analytics;
      case 2:
        return Icons.account_balance;
      case 3:
        return Icons.attach_money;
      case 4:
        return Icons.forum;
      default:
        return Icons.agriculture;
    }
  }
}
