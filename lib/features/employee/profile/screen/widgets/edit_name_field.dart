import 'package:dating_app/core/validators/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/features/employee/profile/cubit/employee_edit_profile_state.dart';
import 'package:dating_app/features/user/features/user_profile/presentation/widget/edit_profile_text_field.dart';

class EditNameField extends StatelessWidget {
  final EmployeeEditProfileEditing state;
  final Function(String) onChanged;

  const EditNameField({
    super.key,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return EditProfileTextField(
      key: ValueKey("name_${state.isLoading}"),
      label: "Name",
      initialValue: state.name ?? '',
      onChanged: onChanged,
      icon: Icons.person,
      validator: AppValidators.name,
    );
  }
}
