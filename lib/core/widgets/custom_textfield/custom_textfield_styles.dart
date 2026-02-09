import 'package:flutter/material.dart';
import '../../../config/theme/app_color.dart';

class CustomTextFieldStyles {
  // INPUT TEXT STYLE
  TextStyle inputStyle(
    TextTheme textTheme, {
    double? textSize,
    Color? textColor,
  }) {
    return textTheme.bodyMedium!.copyWith(
      fontSize: textSize ?? 20,
      color: textColor ?? AppColor.primaryText,
    );
  }

  // LABEL STYLE
  TextStyle labelStyle(
    TextTheme textTheme, {
    double? labelSize,
    Color? textColor,
  }) {
    return textTheme.bodyMedium!.copyWith(
      fontSize: labelSize ?? 14,
      fontWeight: FontWeight.w600,
      color: textColor ?? AppColor.primaryText,
    );
  }

  // HINT STYLE
  TextStyle hintStyle({double? hintSize, Color? hintColor}) {
    return TextStyle(
      fontSize: hintSize ?? 15,
      color: hintColor ?? AppColor.secondaryText,
    );
  }

  // PREFIX ICON
  Widget? prefixIconWidget({
    IconData? prefixIcon,
    double? textSize,
    Color? hintColor,
  }) {
    if (prefixIcon == null) return null;

    return Icon(
      prefixIcon,
      color: hintColor ?? AppColor.secondaryText,
      size: (textSize ?? 18) + 6,
    );
  }

  // RADIUS
  BorderRadius radius(double? borderRadius) {
    return BorderRadius.circular(borderRadius ?? 12);
  }

  // ENABLED BORDER
  OutlineInputBorder enabledBorder({
    required BorderRadius radius,
    Color? borderColor,
    double? borderWidth,
  }) {
    return OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: borderColor ?? AppColor.textFieldBorder,
        width: borderWidth ?? 2.0,
      ),
    );
  }

  // FOCUSED BORDER
  OutlineInputBorder focusedBorder({
    required BorderRadius radius,
    Color? focusedBorderColor,
    double? focusedBorderWidth,
  }) {
    return OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: focusedBorderColor ?? AppColor.primaryButton,
        width: focusedBorderWidth ?? 2.5,
      ),
    );
  }

  // ERROR BORDER
  OutlineInputBorder errorBorder(BorderRadius radius, {Color? errorColor}) {
    return OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: errorColor ?? Colors.red),
    );
  }

  // FOCUSED ERROR BORDER
  OutlineInputBorder focusedErrorBorder(
    BorderRadius radius, {
    Color? errorColor,
  }) {
    return OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: errorColor ?? Colors.red, width: 2),
    );
  }
}
