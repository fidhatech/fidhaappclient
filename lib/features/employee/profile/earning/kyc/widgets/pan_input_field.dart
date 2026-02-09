import 'package:dating_app/core/validators/app_validator.dart';
import 'package:dating_app/core/widgets/custom_textfield/custom_textfield.dart';
import 'package:flutter/material.dart';

class PanInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool isVerified;
  final String? holderName;
  final bool isEnabled;

  const PanInputField({
    super.key,
    required this.controller,
    this.onChanged,
    this.isVerified = false,
    this.holderName,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'PAN Card Number',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            if (!isVerified)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Optional',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (isVerified) ...[
              const SizedBox(width: 4),
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 4),
              const Text(
                'Verified',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: controller,
          hint: isVerified ? holderName ?? 'Verified' : 'ex: ABCDE1234A',
          keyboardType: TextInputType.text,
          validator: isEnabled ? AppValidators.pan : null,
          onChanged: isEnabled
              ? (value) {
                  // Auto-convert to uppercase
                  final upperValue = value.toUpperCase();
                  if (value != upperValue) {
                    controller.value = controller.value.copyWith(
                      text: upperValue,
                      selection: TextSelection.collapsed(
                        offset: upperValue.length,
                      ),
                    );
                  }
                  onChanged?.call(upperValue);
                }
              : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          borderRadius: 12,
          contentPadding: 16,
          verticalPadding: 16,
        ),
        const SizedBox(height: 8),
        if (!isVerified)
          Text(
            'PAN of the person receiving the money.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        if (isVerified && holderName != null)
          Text(
            'Verified for: $holderName',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
