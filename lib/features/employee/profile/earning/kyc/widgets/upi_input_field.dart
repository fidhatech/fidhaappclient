import 'package:dating_app/core/validators/app_validator.dart';
import 'package:dating_app/core/widgets/custom_textfield/custom_textfield.dart';
import 'package:flutter/material.dart';

class UpiInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const UpiInputField({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'UPI ID',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: controller,
          hint: 'ex: 1234567890@abcbank',
          keyboardType: TextInputType.emailAddress,
          validator: AppValidators.upiId,
          onChanged: onChanged,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          borderRadius: 12,
          contentPadding: 16,
          verticalPadding: 16,
        ),
        const SizedBox(height: 8),
        Text(
          'Use UPI linked to the same person as PAN.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
