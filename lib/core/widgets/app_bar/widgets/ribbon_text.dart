import 'package:flutter/material.dart';

class RibbonLogoText extends StatelessWidget {
  final double fontSize;
  const RibbonLogoText({super.key, this.fontSize = 34});

  @override
  Widget build(BuildContext context) {
    final colorizeTextStyle = TextStyle(
      fontSize: fontSize,
      fontFamily: 'GreatVibes',
      fontWeight: FontWeight.w400,
      color: Colors.white,
      letterSpacing: 0.4,
      shadows: const [
        Shadow(blurRadius: 10, color: Color(0x55000000), offset: Offset(0, 2)),
      ],
    );

    return SizedBox(
      width: 200,
      child: Center(
        child: Text(
          'Fidha',
          style: colorizeTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
