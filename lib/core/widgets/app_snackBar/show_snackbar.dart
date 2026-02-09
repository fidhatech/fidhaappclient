import 'package:flutter/material.dart';

void showAppSnackbar(
  BuildContext context, {
  required String message,
  required IconData icon,
  VoidCallback? onIconPressed,
  Color? backgroundColor, // ⬅️ NEW
  EdgeInsets? margin, // ⬅️ Added margin for positioning
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(
        seconds: 2,
      ), // Reduced duration for snappier feel
      margin: margin, // Use provided margin
      padding: EdgeInsets.zero,
      content: _SnackbarContent(
        message: message,
        icon: icon,
        onIconPressed: onIconPressed,
        backgroundColor: backgroundColor,
      ),
    ),
  );
}

class _SnackbarContent extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onIconPressed;
  final Color? backgroundColor; // ⬅️ NEW

  const _SnackbarContent({
    required this.message,
    required this.icon,
    this.onIconPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: (backgroundColor ?? Colors.red).withValues(
          alpha: 0.95,
        ), // ⬅️ DEFAULT RED
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 8),

          GestureDetector(
            onTap: onIconPressed,
            child: Icon(icon, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}
