import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 20,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.secondary.withValues(alpha: 0.5),
          ),
          child: const Icon(Icons.arrow_back, color: AppColor.primaryText),
        ),
      ),
    );
  }
}
