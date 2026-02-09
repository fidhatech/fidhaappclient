import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:intl/intl.dart';

class DobField extends StatelessWidget {
  final DateTime? dob;
  final VoidCallback onTap;
  final String label;
  final String? errorText;

  const DobField({
    super.key,
    required this.dob,
    required this.onTap,
    this.label = "Date of Birth",
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final text = dob == null
        ? label
        : DateFormat("dd / MM / yyyy").format(dob!);

    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: label,
            labelText: label,
            errorText: errorText,
            suffixIcon: const Icon(Icons.calendar_month),
            filled: true,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColor.textFieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColor.highlightColor),
            ),
          ),
          controller: TextEditingController(text: text),
        ),
      ),
    );
  }
}
