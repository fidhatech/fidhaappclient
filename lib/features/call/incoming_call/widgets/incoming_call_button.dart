import 'package:flutter/material.dart';

class IncomingCallButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const IncomingCallButton({
    super.key,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    return GestureDetector(
      onTapDown: (_) => {}, // Visual feedback handled by Opacity/Ink
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isDisabled ? 0.3 : 1.0,
        child: Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 34),
        ),
      ),
    );
  }
}
