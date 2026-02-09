import 'package:flutter/material.dart';
import 'package:dating_app/core/widgets/custom_elevated_button/custom_elevated_button.dart';
import 'package:dating_app/config/theme/app_color.dart';

class EmployeeConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EmployeeConfirmButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: "Confirm",
      onPressed: onPressed,
      backgroundColor: AppColor.primaryPink,
      heightMultiplier: 15,
    );
  }
}
