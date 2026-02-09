import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/features/employee/profile/cubit/employee_edit_profile_state.dart';

class EditInterestSelector extends StatelessWidget {
  final EmployeeEditProfileEditing state;
  final Function(String) onInterestToggled;

  const EditInterestSelector({
    super.key,
    required this.state,
    required this.onInterestToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Interests",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              [
                "Love",
                "Movies and cinema",
                "Romantic",
                "Emotional or supportive talk",
                "Career",
                "Childhood memories",
              ].map((interest) {
                final isSelected = state.interests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (_) => onInterestToggled(interest),
                  backgroundColor: Colors.white10,
                  selectedColor: AppColor.primaryButton,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                  checkmarkColor: Colors.white,
                );
              }).toList(),
        ),
      ],
    );
  }
}
