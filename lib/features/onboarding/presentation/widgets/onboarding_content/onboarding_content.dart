import '../../../../../config/theme/app_color.dart';
import '../../../../../core/extensions/context_ext.dart';

import 'package:flutter/material.dart';

class OnboardingContent extends StatelessWidget {

  final String title;
  final String subtitle;
  final String buttonText;
  final String termsText;
  final int currentPage;
  final int totalPages;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.termsText,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: context.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        Text(
          subtitle,
          style: context.textTheme.bodyLarge?.copyWith(
            color: AppColor.secondaryText,
          ),
        ),
        const SizedBox(height: 16),

        Row(
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
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
