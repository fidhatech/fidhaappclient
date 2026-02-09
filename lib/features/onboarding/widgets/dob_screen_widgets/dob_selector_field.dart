import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DobSelectorField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DobSelectorField({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: controlWidth(context, 20),
          vertical: controlHeight(context, 45), // approx 16-20px
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: selectedDate != null
                ? AppColor.highlightColor
                : Colors.white24,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(controlWidth(context, 25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                  : 'Date of Birth',
              style: TextStyle(
                color: selectedDate != null ? Colors.white : Colors.white54,
                fontSize: controlWidth(context, 25), // approx 16px
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: selectedDate != null ? Colors.white : Colors.white54,
              size: controlWidth(context, 15),
            ),
          ],
        ),
      ),
    );
  }
}
