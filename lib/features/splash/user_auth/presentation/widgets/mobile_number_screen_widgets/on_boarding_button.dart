import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/features/onboarding/widgets/onboarding_content/onboarding_action_button.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/mobile_number_screen_widgets/terms_text.dart';

import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabledd;

  const OnboardingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabledd = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: controlWidth(context, 17)),
          child: OnboardingActionButton(
            isEnabled: enabledd,
            text: text,
            onPressed: onPressed,
            backgroundColor: AppColor.primaryButton,
          ),
        ),
        SizedBox(height: controlHeight(context, 40)),
        const TermsText(),
      ],
    );
  }
}
