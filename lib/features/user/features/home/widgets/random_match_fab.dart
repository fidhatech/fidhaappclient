import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class RandomMatchFab extends StatelessWidget {
  final VoidCallback? onTap;

  const RandomMatchFab({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    double scale = controlWidth(context, 420);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24 * scale,
          vertical: 12 * scale,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF9C27B0),
          borderRadius: BorderRadius.circular(30 * scale),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8 * scale,
              offset: Offset(0, 4 * scale),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Random',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18 * scale,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5 * scale,
              ),
            ),
            SizedBox(width: 12 * scale),
            Icon(Icons.shuffle_rounded, color: Colors.white, size: 24 * scale),
          ],
        ),
      ),
    );
  }
}
