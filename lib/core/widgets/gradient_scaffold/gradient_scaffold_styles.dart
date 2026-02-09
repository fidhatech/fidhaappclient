import 'package:flutter/material.dart';

class GradientScaffoldStyles {
  BoxDecoration gradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
       stops: [0.0, 0.35, 0.7, 1.0],
colors: [
  Color(0xFF07000D), // True black-purple
  Color(0xFF1A0026), // Ink purple
  Color(0xFF3C004D), // Wine purple
  Color(0xFF6B007A), // Muted magenta
],

        // stops: [0.0, 0.45, 0.75, 1.0],
        // colors: [
        //   Color(0xFF0D001A), // Deep dark purple base
        //   Color(0xFF2A003E), // Smooth transition
        //   Color(0xFF6A007F), // Rich purple-magenta
        //   Color(0xFFCF2BAD), // Bright magenta highlight (soft)
        // ],
      ),
    );
  }

  Color scaffoldBackground() => Colors.transparent;
}
