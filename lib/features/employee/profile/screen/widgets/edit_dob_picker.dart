import 'package:flutter/material.dart';
import 'package:dating_app/features/employee/profile/cubit/employee_edit_profile_state.dart';
import 'package:dating_app/features/user/features/user_profile/presentation/widget/edit_profile_text_field.dart';

class EditDobPicker extends StatelessWidget {
  final EmployeeEditProfileEditing state;
  final Function(String) onDateSelected;

  const EditDobPicker({
    super.key,
    required this.state,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          onDateSelected("${picked.day}/${picked.month}/${picked.year}");
        }
      },
      child: AbsorbPointer(
        child: EditProfileTextField(
          label: "Date of Birth",
          initialValue: state.dob ?? '',
          onChanged: (_) {},
          icon: Icons.calendar_today,
          key: ValueKey("dob_${state.isLoading}"),
        ),
      ),
    );
  }
}
