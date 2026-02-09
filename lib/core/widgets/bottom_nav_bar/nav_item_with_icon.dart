import 'package:flutter/material.dart';

/// Navigation item with a standard icon
class NavItemWithIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const NavItemWithIcon({
    super.key,
    required this.icon,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizing
    final iconSize = screenWidth * 0.06;
    final verticalPadding = screenWidth * 0.02;
    final spacing = screenWidth * 0.02;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: isSelected ? Colors.black : Colors.black87,
              ),
              SizedBox(height: spacing),
            ],
          ),
        ),
      ),
    );
  }
}
