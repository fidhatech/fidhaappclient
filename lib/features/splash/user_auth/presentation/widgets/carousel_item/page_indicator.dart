import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';

/// Custom animated page indicator widget for carousel navigation
class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentPage ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: index == currentPage
                ? AppColor.primaryText
                : AppColor.primaryText.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
