import 'package:flutter/material.dart';

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  final Color? textColor;
  final Color? iconColor;

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? Colors.grey.shade400, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 32,
    );
  }
}
