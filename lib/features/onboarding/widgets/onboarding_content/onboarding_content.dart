import 'package:dating_app/features/onboarding/widgets/onboarding_content/onboarding_subtitle.dart';
import 'package:dating_app/features/onboarding/widgets/onboarding_content/onboarding_title.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/carousel_item/page_indicator.dart';

import 'package:flutter/material.dart';
import 'package:dating_app/core/utils/mediaquery.dart';

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
        OnboardingTitle(title: title),
        SizedBox(height: controlHeight(context, 65)),

        OnboardingSubtitle(subtitle: subtitle),
        SizedBox(height: controlHeight(context, 130)),

        PageIndicator(currentPage: currentPage, totalPages: totalPages),
        SizedBox(height: controlHeight(context, 40)),
      ],
    );
  }
}
