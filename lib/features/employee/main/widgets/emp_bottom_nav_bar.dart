import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dating_app/core/widgets/bottom_nav_bar/nav_item_with_icon.dart';
import 'package:dating_app/core/widgets/bottom_nav_bar/nav_item_with_svg.dart';
import 'package:dating_app/core/widgets/bottom_nav_bar/nav_item_with_rounded_icon.dart';
import 'package:dating_app/core/widgets/bottom_nav_bar/sliding_dot_indicator.dart';

/// A reusable custom bottom navigation bar widget with a floating design and sliding dot indicator
/// Responsive for mobile, tablet, iPad, and foldable screens
class EmployeeCustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const EmployeeCustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine if we're on a larger screen (tablet/iPad)
    final isLargeScreen = screenWidth > 600;

    // Responsive values
    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenWidth * 0.03;
    final borderRadius = screenWidth * 0.08;
    final innerHorizontalPadding = screenWidth * 0.04;
    final innerVerticalPadding = screenWidth * 0.012;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      alignment: isLargeScreen ? Alignment.center : null,
      child: Container(
        color: Colors.transparent,
        width: isLargeScreen ? 600 : null,
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          verticalPadding / 3, // Minimal top padding
          horizontalPadding,
          verticalPadding * 0.5, // Reduced bottom padding
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.9,
                ), // Semi-transparent white for glass effect
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: innerHorizontalPadding,
                  vertical: innerVerticalPadding,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tabWidth = constraints.maxWidth / 3;

                    return Stack(
                      children: [
                        SlidingDotIndicator(
                          selectedIndex: selectedIndex,
                          tabWidth: tabWidth,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            NavItemWithIcon(
                              icon: FontAwesomeIcons.house,
                              index: 0,
                              selectedIndex: selectedIndex,
                              onTap: onTabChange,
                            ),

                            NavItemWithSvg(
                              assetPath: 'assets/icons/history.svg',
                              index: 1,
                              selectedIndex: selectedIndex,
                              onTap: onTabChange,
                            ),
                            NavItemWithRoundedIcon(
                              icon: FontAwesomeIcons.user,
                              index: 2,
                              selectedIndex: selectedIndex,
                              onTap: onTabChange,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
