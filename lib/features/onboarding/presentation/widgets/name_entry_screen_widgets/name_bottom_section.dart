import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/core/utils/url_helper.dart';
import 'package:dating_app/core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import 'package:flutter/material.dart';

class NameBottomSection extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;

  const NameBottomSection({
    super.key,
    required this.onPressed,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: screenHeightPercentage(context, 0.25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConfirmButtonWithText(
              isEnabled: isEnabled,
              buttonText: 'Confirm',
              bottomText: 'By continuing, you agree to our Terms & Conditions',
              onBottomTextTap: () =>
                  UrlHelper.launchURL(AppUrls.termsAndConditions),
              onTap: onPressed ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}
