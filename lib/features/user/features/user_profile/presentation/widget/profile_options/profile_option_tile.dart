import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? iconColor;

  const OptionTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColor.secondaryText.withValues(alpha: 0.1),
        highlightColor: AppColor.secondaryText.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              Icon(icon, size: 26, color: iconColor ?? AppColor.secondaryText),
              const SizedBox(width: 12),
              Text(label, style: TextStyle(color: textColor ?? Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
