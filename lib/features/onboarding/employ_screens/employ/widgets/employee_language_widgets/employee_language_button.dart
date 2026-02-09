import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/utils/url_helper.dart';
import 'package:dating_app/core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import 'package:dating_app/core/widgets/loading_dialog/otp_loading_dialog.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_language_cubit/employee_language_cubit.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_language_cubit/employee_language_state.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/screens/employee_voice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeLanguageButton extends StatelessWidget {
  const EmployeeLanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeLanguageCubit, EmployeeLanguageState>(
      listener: (context, state) {
        if (state is EmployeeLanguageSubmitting) {
          showLoadingDialog(context);
        }
        if (state is EmployeeLanguageSuccess) {
          Navigator.pop(context);
          // Navigate to voice screen after successful API
          final cubit = context.read<EmployeeLanguageCubit>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeVoiceScreen(
                selectedLanguage: state.language,
                textToRead: state.textToRead,
              ),
            ),
          ).then((_) => cubit.reset());
        } else if (state is EmployeeLanguageError) {
          // Show SnackBar if error occurs
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<EmployeeLanguageCubit, EmployeeLanguageState>(
        builder: (context, state) {
          return ConfirmButtonWithText(
            buttonText: 'Done',
            bottomText: 'By continuing, you agree to our Terms & Conditions',
            onBottomTextTap: () =>
                UrlHelper.launchURL(AppUrls.termsAndConditions),
            isEnabled: state is EmployeeLanguageSelected,
            onTap: () => context.read<EmployeeLanguageCubit>().submit(),
          );
        },
      ),
    );
  }
}
