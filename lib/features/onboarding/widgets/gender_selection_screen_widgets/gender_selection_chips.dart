import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class GenderSelectionChips extends StatelessWidget {
  final String? selectedGender;
  final Function(String) onGenderSelected;

  const GenderSelectionChips({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildGenderChip(
            context: context,
            label: 'Male',
            isSelected: selectedGender == 'Male',
            onTap: () => onGenderSelected('Male'),
          ),
        ),
        SizedBox(width: controlWidth(context, 20)),
        Expanded(
          child: _buildGenderChip(
            context: context,
            label: 'Female',
            isSelected: selectedGender == 'Female',
            onTap: () => onGenderSelected('Female'),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: controlHeight(context, 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColor.highlightColor : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: controlWidth(context, 25),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
