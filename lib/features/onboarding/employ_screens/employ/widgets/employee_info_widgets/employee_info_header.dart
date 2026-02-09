import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';

class EmployeeInfoHeader extends StatelessWidget {
  const EmployeeInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Tell us about yourself",
          style: TextStyle(
            color: AppColor.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "The information you share will be visible to all your matches",
          style: TextStyle(color: AppColor.secondaryText, fontSize: 14),
        ),
      ],
    );
  }
}
