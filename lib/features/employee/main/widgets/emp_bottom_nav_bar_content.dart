import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/employee/main/widgets/emp_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

/// Stateless widget that displays the home screen content
class EmployeeBottomNavBarContent extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const EmployeeBottomNavBarContent({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  // Define the different screens for each tab
  static const List<Widget> _screens = [];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: EmployeeCustomBottomNavBar(
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
      ),
    );
  }
}
