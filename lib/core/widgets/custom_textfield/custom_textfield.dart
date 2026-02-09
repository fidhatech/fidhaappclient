import 'package:flutter/material.dart';
import '../../../../config/theme/app_color.dart';
import 'custom_textfield_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  final String? label; // External label
  final double? labelSize;
  final AutovalidateMode? autovalidateMode;
  final String? inputLabel; // InputDecoration labelText
  final Color? inputLabelColor;

  final String? hint;
  final double? hintSize;

  final double? textSize;
  final double? contentPadding;
  final double? verticalPadding;

  final bool isPassword;
  final TextInputType keyboardType;

  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final Color? errorColor;

  final double? borderWidth;
  final double? focusedBorderWidth;
  final double? borderRadius;
  final int? maxLines;
  final int? minLines;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label, // External
    this.labelSize,
    this.autovalidateMode,
    this.inputLabel, // Internal floating
    this.inputLabelColor,
    this.hint,
    this.hintSize,
    this.textSize,
    this.contentPadding,
    this.verticalPadding,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.textColor,
    this.hintColor,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.errorColor,
    this.borderWidth,
    this.focusedBorderWidth,
    this.borderRadius,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    final styles = CustomTextFieldStyles();
    final textTheme = Theme.of(context).textTheme;

    final radius = styles.radius(borderRadius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: styles.labelStyle(
              textTheme,
              labelSize: labelSize,
              textColor: textColor,
            ),
          ),
          const SizedBox(height: 6),
        ],

        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          maxLines: maxLines,
          minLines: minLines,

          style: styles.inputStyle(
            textTheme,
            textSize: textSize,
            textColor: textColor,
          ),

          cursorColor: textColor ?? AppColor.primaryText,

          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: verticalPadding ?? 15,
              horizontal: contentPadding ?? 15,
            ),

            hintText: hint,
            hintStyle: styles.hintStyle(
              hintSize: hintSize,
              hintColor: hintColor,
            ),

            labelText: inputLabel,
            labelStyle: styles.hintStyle(
              // Using hint style for label base, can be customized if needed
              hintSize: hintSize,
              hintColor: inputLabelColor ?? hintColor,
            ),

            prefixIcon: styles.prefixIconWidget(
              prefixIcon: prefixIcon,
              textSize: textSize,
              hintColor: hintColor,
            ),

            suffixIcon: suffixIcon,

            filled: true,
            fillColor: fillColor ?? Colors.transparent,

            enabledBorder: styles.enabledBorder(
              radius: radius,
              borderColor: borderColor,
              borderWidth: borderWidth,
            ),

            focusedBorder: styles.focusedBorder(
              radius: radius,
              focusedBorderColor: focusedBorderColor,
              focusedBorderWidth: focusedBorderWidth,
            ),

            errorBorder: styles.errorBorder(radius, errorColor: errorColor),
            focusedErrorBorder: styles.focusedErrorBorder(
              radius,
              errorColor: errorColor,
            ),
          ),
        ),
      ],
    );
  }
}
