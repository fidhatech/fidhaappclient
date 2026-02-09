import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';

class OnboardingSubtitle extends StatelessWidget {
  final String subtitle;
  final double? fontSizeMultiplier;
  final Color? color;

  const OnboardingSubtitle({
    super.key,
    required this.subtitle,
    this.fontSizeMultiplier = 0.04,
    this.color = AppColor.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveFontSize = screenWidth * fontSizeMultiplier!;

    return Text(
      subtitle,
      style: TextStyle(fontSize: responsiveFontSize, color: color),
    );
  }
}
