import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/widgets/app_bar/widgets/ribbon_text.dart';
import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  final Animation<double> iconPopAnim;
  final Animation<double> textFadeAnim;
  final Animation<Offset> textSlideAnim;

  const SplashContent({
    super.key,
    required this.iconPopAnim,
    required this.textFadeAnim,
    required this.textSlideAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: iconPopAnim,
          child: SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildBubble(
                  icon: Icons.videocam_rounded,
                  color: AppColor.primaryText,
                  iconColor: AppColor.primary,
                  size: 80,
                  top: 0,
                ),
                _buildBubble(
                  icon: Icons.chat_bubble_rounded,
                  color: AppColor.primaryText.withValues(alpha: 0.2),
                  iconColor: AppColor.primaryText,
                  size: 60,
                  bottom: 10,
                  left: 10,
                ),
                _buildBubble(
                  icon: Icons.mic_rounded,
                  color: AppColor.primaryText.withValues(alpha: 0.2),
                  iconColor: AppColor.primaryText,
                  size: 60,
                  bottom: 10,
                  right: 10,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        SlideTransition(
          position: textSlideAnim,
          child: FadeTransition(
            opacity: textFadeAnim,
            child: Column(
              children: const [
                RibbonLogoText(fontSize: 48),
                SizedBox(height: 8),
                Text(
                  'CONNECT • TALK • SEE',
                  style: TextStyle(
                    color: AppColor.secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBubble({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required double size,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: size * 0.5),
      ),
    );
  }
}
