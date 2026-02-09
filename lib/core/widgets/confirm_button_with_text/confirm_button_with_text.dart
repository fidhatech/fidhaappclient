import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/features/onboarding/widgets/onboarding_content/onboarding_action_button.dart';
import 'package:flutter/material.dart';

/// Reusable widget that displays a confirm button with optional text below it
/// Commonly used in onboarding and authentication screens
class ConfirmButtonWithText extends StatelessWidget {
  /// The text to display on the button
  final String buttonText;

  /// Callback function when the button is pressed
  final VoidCallback onTap;

  /// Optional text to display below the button
  /// If null, no text will be shown
  final String? bottomText;

  /// Optional callback when the bottom text is tapped
  /// If null, the text will not be tappable
  final VoidCallback? onBottomTextTap;

  /// Whether the button is enabled or disabled
  final bool isEnabled;

  /// Optional background color for the button
  /// Defaults to AppColor.primaryButton
  final Color? buttonBackgroundColor;

  const ConfirmButtonWithText({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.bottomText,
    this.onBottomTextTap,
    this.isEnabled = true,
    this.buttonBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: controlWidth(context, 17)),
          child: OnboardingActionButton(
            isEnabled: isEnabled,
            text: buttonText,
            onPressed: onTap,
            backgroundColor: buttonBackgroundColor ?? AppColor.primaryButton,
          ),
        ),

        // Spacing between button and text
        if (bottomText != null) SizedBox(height: controlHeight(context, 40)),

        // Bottom text (optional)
        if (bottomText != null)
          GestureDetector(
            onTap: onBottomTextTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                bottomText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: MediaQuery.of(context).size.width * 0.0325,
                  decoration: onBottomTextTap != null
                      ? TextDecoration.underline
                      : null,
                  decorationColor: Colors.white70,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
