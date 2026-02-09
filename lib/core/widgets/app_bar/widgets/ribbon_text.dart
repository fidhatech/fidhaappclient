import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class RibbonLogoText extends StatelessWidget {
  final double fontSize;
  const RibbonLogoText({super.key, this.fontSize = 34});

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Color(0xffd946ef),
      Color(0xfff472b6),
      Color(0xffc084fc),
    ];

    final colorizeTextStyle = TextStyle(
      fontSize: fontSize,
      fontFamily: 'GreatVibes',
      fontWeight: FontWeight.w400,
      letterSpacing: 1.2,
      shadows: [
        Shadow(blurRadius: 10, color: Color(0x88f472b6), offset: Offset(0, 2)),
      ],
    );

    return SizedBox(
      width: 200,
      child: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Fidha',
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
              speed: const Duration(milliseconds: 500),
              textAlign: TextAlign.center,
            ),
          ],
          isRepeatingAnimation: true,
          repeatForever: true,
        ),
      ),
    );
  }
}
