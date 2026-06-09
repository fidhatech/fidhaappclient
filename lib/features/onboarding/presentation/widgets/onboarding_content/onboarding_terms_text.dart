import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/utils/url_helper.dart';

class OnboardingTermsText extends StatelessWidget {
  final String text;
  final double? fontSizeMultiplier;
  final double? opacity;
  final VoidCallback? onTap;

  const OnboardingTermsText({
    super.key,
    required this.text,
    this.fontSizeMultiplier = 0.0325,
    this.opacity = 0.4,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveFontSize = screenWidth * fontSizeMultiplier!;

    return Center(
      child: GestureDetector(
        onTap: onTap ?? () => UrlHelper.launchURL(AppUrls.termsAndConditions),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: responsiveFontSize,
            color: AppColor.primaryText.withValues(alpha: opacity!),
            decoration: TextDecoration.underline,
            decorationColor: AppColor.primaryText.withValues(alpha: opacity!),
          ),
        ),
      ),
    );
  }
}
