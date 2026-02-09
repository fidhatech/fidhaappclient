import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Navigation item with an SVG icon
class NavItemWithSvg extends StatelessWidget {
  final String assetPath;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const NavItemWithSvg({
    super.key,
    required this.assetPath,
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
              SvgPicture.asset(
                assetPath,
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.black : Colors.black87,
                  BlendMode.srcIn,
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
