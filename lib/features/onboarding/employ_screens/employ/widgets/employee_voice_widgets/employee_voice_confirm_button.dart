import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/utils/url_helper.dart';
import 'package:dating_app/core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import 'package:dating_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_voice_cubit/employee_voice_cubit.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_voice_cubit/employee_voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeVoiceConfirmButton extends StatelessWidget {
  const EmployeeVoiceConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeVoiceCubit, EmployeeVoiceState>(
      builder: (context, state) {
        final isEnabled = state is EmployeeVoiceRecorded;
        return ConfirmButtonWithText(
          buttonText: 'Confirm',
          bottomText: 'By continuing, you agree to our Terms & Conditions',
          onBottomTextTap: () =>
              UrlHelper.launchURL(AppUrls.termsAndConditions),
          isEnabled: isEnabled,
          onTap: () {
            if (isEnabled) {
              final audioPath = (state).audioPath;
              final language = context
                  .read<EmployeeVoiceCubit>()
                  .selectedLanguage;

              // Trigger the final Bloc submission
              context.read<OnboardingBloc>().add(
                FemaleSubmit(audioPath: audioPath, language: language),
              );
            }
          },
        );
      },
    );
  }
}
