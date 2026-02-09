import 'package:flutter/material.dart';
import 'package:dating_app/core/widgets/custom_textfield/custom_textfield.dart';
import 'package:dating_app/config/theme/app_color.dart';

class EmployeeAgeInput extends StatelessWidget {
  final TextEditingController controller;

  const EmployeeAgeInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: "Enter your Age",
      inputLabel: "Age in years",
      hint: "Age in years",
      controller: controller,
      keyboardType: TextInputType.number,
      textColor: AppColor.primaryText,
      fillColor: Colors.transparent,
      borderColor: AppColor.textFieldBorder,
      borderRadius: 12,
      labelSize: 14,
      inputLabelColor: AppColor.secondaryText,
      hintColor: AppColor.secondaryText,
    );
  }
}
