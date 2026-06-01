import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'custom_button_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final String? svgIcon;
  final Color? backgroundColor;

  final double? widthMultiplier;

  final double? heightMultiplier;
  final double? textSize;
  final bool isEnabled;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.svgIcon,
    this.backgroundColor,
    this.widthMultiplier,
    this.heightMultiplier,
    this.textSize,
    this.isEnabled = true,
    this.isLoading = false,
  }) : assert(icon == null || svgIcon == null, 'Cannot provide both icon and svgIcon');

  @override
  Widget build(BuildContext context) {
    final styles = CustomButtonStyles();

    return SizedBox(
      width: widthMultiplier != null
          ? controlWidth(context, widthMultiplier!)
          : double.infinity,
      height: controlHeight(context, heightMultiplier ?? 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? styles.backgroundColor(customColor: backgroundColor)
              : Colors.black.withValues(alpha: 0.3),
          foregroundColor: isEnabled
              ? styles.foregroundColor()
              : Colors.white.withValues(alpha: 0.5), // << dimmed text/icon
          shape: styles.buttonShape(55),
          padding: styles.buttonPadding(),
          elevation: 0,
        ),
        child: isLoading ? CircularProgressIndicator(
          color: styles.foregroundColor(),
        ) : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgIcon != null) ...[
              SvgPicture.asset(svgIcon!, width: 24, height: 24),
              const SizedBox(width: 10), // spacing between text and svg icon
            ],
            Text(text, style: styles.textStyle(fontSize: textSize)),
            if (icon != null) ...[
              styles.iconSpacing(icon),
              styles.iconWidget(icon) ?? const SizedBox.shrink(),
            ],
          ],
        ),
      ),
    );
  }
}
