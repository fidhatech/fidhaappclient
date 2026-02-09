import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class MobileIllustration extends StatelessWidget {
  const MobileIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // MAIN IMAGE
        Padding(
          padding: EdgeInsets.only(right: controlWidth(context, 9.5)),
          child: Image.asset(
            'assets/images/onboarding_images/girl_sketch1.png',
            height: screenHeightPercentage(context, 0.35),
            fit: BoxFit.contain,
          ),
        ),

        // POSITIONED CHAT BUBBLE
        Positioned(
          right: -controlWidth(context, 6.5),
          top: controlHeight(context, 40),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: controlWidth(context, 28),
              vertical: controlHeight(context, 80),
            ),
            decoration: BoxDecoration(
              color: AppColor.highlightColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(controlWidth(context, 28)),
                topRight: Radius.circular(controlWidth(context, 28)),
                bottomLeft: Radius.zero,
                bottomRight: Radius.circular(controlWidth(context, 28)),
              ),
            ),
            child: AnimatedTextKit(
              isRepeatingAnimation: true,
              animatedTexts: [
                BounceAnimatedText(
                  "Give Me Your Number",
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: controlWidth(context, 26),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
