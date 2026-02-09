import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class EmployeeLanguageOption extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const EmployeeLanguageOption({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColor.primaryPink, width: 2)
              : Border.all(color: AppColor.textFieldBorder, width: 1),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColor.primaryPink.withValues(alpha: 0.1),
                    Colors.purple.withValues(alpha: 0.1),
                  ],
                )
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          language,
          style: TextStyle(
            color: isSelected ? AppColor.primaryPink : AppColor.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
