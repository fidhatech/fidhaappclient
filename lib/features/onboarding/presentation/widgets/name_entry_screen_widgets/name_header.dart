import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class NameHeader extends StatelessWidget {
  const NameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: EdgeInsets.all(controlWidth(context, 40)),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        SizedBox(height: controlHeight(context, 25)),

        Text(
          'Name',
          style: TextStyle(
            fontSize: getResponsiveFontSize(context, mobile: 32),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: controlHeight(context, 100)),

        Text(
          'To get started, tell us who you are.',
          style: TextStyle(
            fontSize: getResponsiveFontSize(context, mobile: 16),
            fontWeight: FontWeight.w300,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
