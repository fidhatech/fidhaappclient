import 'package:flutter/material.dart';
import 'package:dating_app/core/widgets/custom_elevated_button/custom_elevated_button.dart';

class OnboardingActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final IconData? icon;
  final double? textSize;
  final bool? isEnabled;

  const OnboardingActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.icon,
    this.textSize,
    this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      isEnabled: isEnabled ?? true,
      text: text,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      icon: icon,
      heightMultiplier: 15,
      textSize: textSize,
    );
  }
}
