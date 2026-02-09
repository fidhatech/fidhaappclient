import 'package:dating_app/core/widgets/app_bar/custom_app_bar.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/user/features/history/presentation/screens/history_screen.dart';
import 'package:dating_app/features/user/features/home/screens/home_screen.dart';
import 'package:dating_app/features/user/features/navigation/widgets/bottom_nav_bar.dart';

import 'package:dating_app/features/user/features/premium/screens/premium_screen.dart';
import 'package:dating_app/features/user/features/user_profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBarContent extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const BottomNavBarContent({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  static const List<Widget> _screens = [
    HomeScreenTab(),
    PremiumScreenTab(),
    HistoryScreenTab(),
    ProfileScreenTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: (selectedIndex == 3) ? null : CustomAppBar(),
      body: _screens[selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
      ),
    );
  }
}
