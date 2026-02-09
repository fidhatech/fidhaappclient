import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class EmployeeVoiceHeader extends StatelessWidget {
  const EmployeeVoiceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const SizedBox(height: 20),
        const Text(
          "Voice Identification",
          style: TextStyle(
            color: AppColor.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "To confirm your identity, please record yourself saying the following sentence",
          style: TextStyle(color: AppColor.secondaryText, fontSize: 14),
        ),
      ],
    );
  }
}
