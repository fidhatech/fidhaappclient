import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/features/employee/profile/cubit/employee_edit_profile_state.dart';

class EditLanguageSelector extends StatelessWidget {
  final EmployeeEditProfileEditing state;
  final Function(List<String>) onLanguageChanged;

  const EditLanguageSelector({
    super.key,
    required this.state,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Languages",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              [
                "English",
                "Hindi",
                "Malayalam",
                "Tamil",
                "Telugu",
                "Kannada",
              ].map((language) {
                final isSelected = state.languages.contains(language);
                return FilterChip(
                  label: Text(language),
                  selected: isSelected,
                  onSelected: (selected) {
                    List<String> newLanguages = List.from(state.languages);
                    if (selected) {
                      newLanguages.add(language);
                    } else {
                      newLanguages.remove(language);
                    }
                    onLanguageChanged(newLanguages);
                  },
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
