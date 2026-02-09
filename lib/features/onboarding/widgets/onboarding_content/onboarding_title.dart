import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/text_theme.dart';

class OnboardingTitle extends StatelessWidget {
  final String title;
  final double? fontSizeMultiplier;
  final double? lineHeight;

  const OnboardingTitle({
    super.key,
    required this.title,
    this.fontSizeMultiplier = 0.105,
    this.lineHeight = 1.1,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveFontSize = screenWidth * fontSizeMultiplier!;

    return Text(
      title,
      style: AppTextTheme.light.headlineLarge?.copyWith(
        fontSize: responsiveFontSize,
        height: lineHeight,
      ),
    );
  }
}
