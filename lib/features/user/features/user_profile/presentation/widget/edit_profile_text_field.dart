import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class EditProfileTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final Function(String) onChanged;
  final IconData icon;
  final String? errorText;
  final String? Function(String?)? validator;
  final int maxLines;

  const EditProfileTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    required this.icon,
    this.errorText,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        errorText: errorText,
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.primary),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
