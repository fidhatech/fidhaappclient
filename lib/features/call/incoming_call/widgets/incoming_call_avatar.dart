import 'package:flutter/material.dart';

class IncomingCallAvatar extends StatelessWidget {
  final String imagePath;
  final double radius;

  const IncomingCallAvatar({
    super.key,
    required this.imagePath,
    this.radius = 80,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(radius: radius, backgroundImage: AssetImage(imagePath));
  }
}
