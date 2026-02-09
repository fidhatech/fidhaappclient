import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';

class NameHeader extends StatelessWidget {
  final String name;

  const NameHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: AppColor.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
