import 'package:flutter/material.dart';

/// Shared Layout Wrapper to ensure Skeleton and Content match perfectly.
class AppBarBody extends StatelessWidget {
  final Widget left;
  final Widget center;
  final Widget right;

  const AppBarBody({
    super.key,
    required this.left,
    required this.center,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(alignment: Alignment.centerLeft, child: left),
            Align(alignment: Alignment.center, child: center),
            Align(alignment: Alignment.centerRight, child: right),
          ],
        ),
      ),
    );
  }
}
