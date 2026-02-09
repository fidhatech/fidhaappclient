import 'package:flutter/material.dart';
import 'package:dating_app/core/widgets/custom_textfield/custom_textfield.dart';
import 'package:dating_app/config/theme/app_color.dart';

class EmployeeAboutInput extends StatelessWidget {
  final TextEditingController controller;

  const EmployeeAboutInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomTextField(
        label: "About Yourself",
        hint: "Tell us about yourself in 100 words...",
        controller: controller,
        borderRadius: 12,
        textColor: AppColor.primaryText,
        fillColor: Colors.transparent,
        borderColor: AppColor.textFieldBorder,
        maxLines: 5,
        minLines: 4,
        hintColor: AppColor.secondaryText,
      ),
    );
  }
}
