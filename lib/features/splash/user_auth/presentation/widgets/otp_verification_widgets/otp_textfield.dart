import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

/// OTP input field widget with responsive design
class OtpTextfield extends StatelessWidget {
  final int length;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;

  const OtpTextfield({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive dimensions
    final pinWidth = screenWidth * 0.14;
    final pinHeight = screenHeight * 0.075;
    final fontSize = screenWidth * 0.058;
    final cursorHeight = pinHeight * 0.3;

    // Default theme
    final defaultTheme = PinTheme(
      width: pinWidth,
      height: pinHeight,
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.30),
          width: 1.5,
        ),
      ),
    );

    return Pinput(
      length: length,
      defaultPinTheme: defaultTheme,
      focusedPinTheme: defaultTheme.copyDecorationWith(
        border: Border.all(color: Colors.white, width: 2),
      ),
      errorPinTheme: defaultTheme.copyDecorationWith(
        border: Border.all(color: Colors.redAccent, width: 2),
      ),
      showCursor: true,
      cursor: Container(width: 2, height: cursorHeight, color: Colors.white),
      keyboardType: TextInputType.number,
      animationCurve: Curves.easeOut,
      animationDuration: const Duration(milliseconds: 180),
      onCompleted: onCompleted,
      onChanged: onChanged,
    );
  }
}
