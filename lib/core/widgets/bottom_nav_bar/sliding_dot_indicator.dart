import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

/// Animated dot indicator that slides under the selected tab
class SlidingDotIndicator extends StatelessWidget {
  final int selectedIndex;
  final double tabWidth;

  const SlidingDotIndicator({
    super.key,
    required this.selectedIndex,
    required this.tabWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: (tabWidth * selectedIndex) + (tabWidth / 2) - 3,
      bottom: 5,
      child: Container(
        width: 6.5,
        height: 5,
        decoration: BoxDecoration(
          color: AppColor.highlightColor,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
