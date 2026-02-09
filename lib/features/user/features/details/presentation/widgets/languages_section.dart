import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';

class LanguagesSection extends StatelessWidget {
  final List<String> languages;

  const LanguagesSection({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    if (languages.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        const Icon(Icons.language, color: AppColor.secondaryText, size: 18),
        const SizedBox(width: 4),
        Text(
          languages.join(", "),
          style: const TextStyle(color: AppColor.secondaryText, fontSize: 12),
        ),
      ],
    );
  }
}
