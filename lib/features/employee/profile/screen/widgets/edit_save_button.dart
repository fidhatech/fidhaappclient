import 'package:dating_app/core/validators/app_validator.dart';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/features/onboarding/widgets/onboarding_content/onboarding_action_button.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/features/employee/profile/cubit/employee_edit_profile_state.dart';

class EditSaveButton extends StatelessWidget {
  final EmployeeEditProfileEditing state;
  final VoidCallback onSave;

  const EditSaveButton({super.key, required this.state, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final String? nameError = AppValidators.name(state.name);
    final bool isNameValid = nameError == null;
    final bool isFormValid = isNameValid && state.languages.isNotEmpty;

    return OnboardingActionButton(
      text: "Save Changes",
      onPressed: isFormValid
          ? onSave
          : () {
              // Show specific error message
              String errorMessage;
              if (!isNameValid) {
                errorMessage = nameError;
              } else if (state.languages.isEmpty) {
                errorMessage = "Please select at least one language";
              } else {
                errorMessage = "Please fix all errors before saving";
              }

              showAppSnackbar(
                context,
                message: errorMessage,
                icon: Icons.error,
              );
            },
      isEnabled: isFormValid,
      backgroundColor: isFormValid ? AppColor.primaryButton : Colors.grey,
    );
  }
}
