import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

/// OTP illustration widget with image and animated chat bubble
class OtpIllustration extends StatelessWidget {
  final String? imagePath;
  final String? bubbleText;
  final Color? bubbleBackgroundColor;
  final Color? bubbleTextColor;

  const OtpIllustration({
    super.key,
    this.imagePath,
    this.bubbleText,
    this.bubbleBackgroundColor,
    this.bubbleTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topLeft,
      clipBehavior: Clip.none,
      children: [
        // Main illustration image
        Padding(
          padding: EdgeInsets.only(left: controlWidth(context, 4.4)),
          child: SizedBox(
            height: screenHeightPercentage(context, 0.35),
            child: Image.asset(
              imagePath ?? 'assets/images/onboarding_images/girl_sketch2.png',
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Animated chat bubble
        Positioned(
          left: controlWidth(context, 6.5),
          top: controlHeight(context, 40),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: controlWidth(context, 28),
              vertical: controlHeight(context, 80),
            ),
            decoration: BoxDecoration(
              color: bubbleBackgroundColor ?? const Color(0xFF9B26B6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(controlWidth(context, 28)),
                topRight: Radius.circular(controlWidth(context, 28)),
                bottomLeft: Radius.circular(controlWidth(context, 28)),
              ),
            ),
            child: Text(
              bubbleText ?? 'Enter the OTP',
              style: TextStyle(
                color: bubbleTextColor ?? Colors.white,
                fontSize: screenWidth * 0.039,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
