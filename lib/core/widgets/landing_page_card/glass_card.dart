import 'dart:ui';
import 'package:flutter/material.dart';

class GlassInfoCard extends StatelessWidget {
  final double width;
  final double height;

  final String title;
  final double titleSize;
  final Color titleColor;

  final String subtitle;
  final double subtitleSize;
  final Color subtitleColor;

  final double blurX;
  final double blurY;

  final double borderRadius;
  final double borderWidth;
  final Color borderColor;

  final Color backgroundColor;

  const GlassInfoCard({
    super.key,

    // sizing
    required this.width,
    required this.height,

    // text
    required this.title,
    required this.subtitle,
    this.titleSize = 18,
    this.subtitleSize = 14,
    this.titleColor = Colors.white,
    this.subtitleColor = const Color.fromARGB(220, 255, 255, 255),

    // blur
    this.blurX = 12,
    this.blurY = 12,

    // border + shape
    this.borderRadius = 16,
    this.borderWidth = 1.2,
    this.borderColor = const Color.fromARGB(120, 255, 255, 255),

    // background
    this.backgroundColor = const Color.fromARGB(40, 255, 255, 255),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: backgroundColor,
            border: Border.all(width: borderWidth, color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: subtitleColor, fontSize: subtitleSize),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
