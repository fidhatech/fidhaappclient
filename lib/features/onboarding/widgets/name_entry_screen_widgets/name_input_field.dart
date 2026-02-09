import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/core/widgets/custom_textfield/custom_textfield.dart';
import 'package:flutter/material.dart';

class NameInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const NameInputField({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hint: "What's Your Name",
      onChanged: onChanged,
      textColor: Colors.white,
      hintColor: Colors.white54,
      borderColor: Colors.white.withValues(alpha: 0.1),
      focusedBorderColor: Colors.white.withValues(alpha: 0.3),
      borderRadius: 15,
      verticalPadding: controlHeight(context, 45),
      textSize: getResponsiveFontSize(context, mobile: 16),
      fillColor: Colors.white.withValues(alpha: 0.05),
    );
  }
}
