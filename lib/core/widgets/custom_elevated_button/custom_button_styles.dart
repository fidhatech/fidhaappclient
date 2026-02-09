import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';

class CustomButtonStyles {
  //  Button Shape (MUST return OutlinedBorder)
  OutlinedBorder buttonShape(double radius) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
  }

  //  Button Padding
  EdgeInsets buttonPadding() {
    return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
  }

  //  Button Background Color
  Color backgroundColor({Color? customColor}) {
    return customColor ?? AppColor.primary;
  }

  //  Foreground (text + icon) color
  Color foregroundColor() {
    return AppColor.primaryText;
  }

  //  Text Style
  TextStyle textStyle({double? fontSize}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: AppColor.primaryText,
    );
  }

  //  Icon Widget
  Widget? iconWidget(IconData? icon) {
    if (icon == null) return null;
    return Icon(icon, size: 20, color: AppColor.primaryText);
  }

  //  Icon Spacing
  Widget iconSpacing(IconData? icon) {
    return icon != null ? const SizedBox(width: 10) : const SizedBox.shrink();
  }
}
