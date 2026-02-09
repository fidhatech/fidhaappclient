import 'package:flutter/material.dart';
import 'package:dating_app/features/employee/profile/cubit/employee_edit_profile_state.dart';
import 'package:dating_app/features/user/features/user_profile/presentation/widget/edit_profile_text_field.dart';

class EditAboutField extends StatelessWidget {
  final EmployeeEditProfileEditing state;
  final Function(String) onChanged;

  const EditAboutField({
    super.key,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return EditProfileTextField(
      key: ValueKey("about_${state.isLoading}"),
      label: "About Me",
      initialValue: state.about ?? '',
      onChanged: onChanged,
      icon: Icons.info_outline,
      maxLines: 3,
    );
  }
}
