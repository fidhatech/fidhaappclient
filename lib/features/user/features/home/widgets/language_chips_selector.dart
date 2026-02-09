import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class LanguageChipsSelector extends StatelessWidget {
  final List<String> selectedLanguages;
  final List<String> availableLanguages;
  final Function(String) onLanguageTap;

  const LanguageChipsSelector({
    super.key,
    required this.selectedLanguages,
    required this.availableLanguages,
    required this.onLanguageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: availableLanguages.map((language) {
        final isSelected = selectedLanguages.contains(language);
        return GestureDetector(
          onTap: () => onLanguageTap(language),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.primary : Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              '$language +',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
