import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showDobPicker(BuildContext context) {
  final now = DateTime.now();
  final maxDate = DateTime(now.year - 18, now.month, now.day);

  return showDatePicker(
    context: context,
    initialDate: maxDate,
    firstDate: DateTime(1950),
    lastDate: maxDate,
    helpText: "Select Date of Birth",
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColor.highlightColor,
            surface: AppColor.secondary,
          ),
        ),
        child: child!,
      );
    },
  );
}
