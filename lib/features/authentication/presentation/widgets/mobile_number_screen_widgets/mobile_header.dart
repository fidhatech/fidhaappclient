import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class MobileHeader extends StatelessWidget {
  const MobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: controlWidth(context, 11.5),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: controlHeight(context, 100)),
        Text(
          'Enter your mobile number to continue',
          style: TextStyle(
            fontSize: controlWidth(context, 24),
            fontWeight: FontWeight.w300,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
