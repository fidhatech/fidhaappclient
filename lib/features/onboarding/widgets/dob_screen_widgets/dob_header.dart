import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class DobHeader extends StatelessWidget {
  const DobHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: TextStyle(
            fontSize: controlWidth(context, 12),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: controlHeight(context, 90)),
        Text(
          'To get started, tell us who you are.',
          style: TextStyle(
            fontSize: controlWidth(context, 25),
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
