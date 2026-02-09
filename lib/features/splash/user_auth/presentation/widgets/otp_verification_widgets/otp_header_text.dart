import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

/// OTP header with title and subtitle
class OtpHeaderText extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const OtpHeaderText({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title ?? 'Enter OTP',
          style: TextStyle(
            fontSize: screenWidth * 0.09,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: controlHeight(context, 100)),

        // Subtitle
        Text(
          subtitle ?? 'Enter the OTP sent to your mobile number',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w300,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
