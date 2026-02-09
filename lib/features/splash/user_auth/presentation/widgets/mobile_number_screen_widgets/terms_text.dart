import 'package:flutter/material.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveFontSize = screenWidth * 0.0325;

    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          "By continuing, you agree to our Terms & Conditions",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: responsiveFontSize),
        ),
      ),
    );
  }
}
