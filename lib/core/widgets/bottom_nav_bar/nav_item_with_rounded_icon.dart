import 'package:flutter/material.dart';

/// Navigation item with a rounded profile icon
class NavItemWithRoundedIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const NavItemWithRoundedIcon({
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
    final containerSize = screenWidth * 0.07;
    final iconSize = screenWidth * 0.04;
    final borderWidth = screenWidth * 0.004;
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
              Container(
                width: containerSize,
                height: containerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.black87,
                    width: borderWidth,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: isSelected ? Colors.black : Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: spacing),
            ],
          ),
        ),
      ),
    );
  }
}
