import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/core/utils/url_helper.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import 'package:flutter/material.dart';

/// Fixed button section at the bottom of OTP verification screen
class OtpButtonSection extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const OtpButtonSection({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        height: screenHeightPercentage(context, 0.30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConfirmButtonWithText(
              isEnabled: isEnabled,
              buttonText: buttonText,
              bottomText: 'By continuing, you agree to our Terms & Conditions',
              onBottomTextTap: () =>
                  UrlHelper.launchURL(AppUrls.termsAndConditions),
              onTap:
                  onPressed ??
                  () {
                    showAppSnackbar(
                      context,
                      message: 'Enter your OTP',
                      icon: Icons.error,
                    );
                  },
            ),
          ],
        ),
      ),
    );
  }
}
