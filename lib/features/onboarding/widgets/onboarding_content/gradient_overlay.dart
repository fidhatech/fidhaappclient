import 'package:flutter/material.dart';

class GradientOverlay extends StatelessWidget {
  final Widget child;
  final Color baseColor;

  const GradientOverlay({
    super.key,
    required this.child,
    this.baseColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        gradient: LinearGradient(
          colors: [baseColor.withValues(alpha: 0.1), baseColor, baseColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: child,
    );
  }
}
