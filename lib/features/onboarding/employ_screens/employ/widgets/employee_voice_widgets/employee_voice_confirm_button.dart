import '../../../../../../core/constants/app_urls.dart';
import '../../../../../../core/utils/url_helper.dart';
import '../../../../../../core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import '../../../../bloc/onboarding_bloc.dart';
import '../../cubit/employee_voice_cubit/employee_voice_cubit.dart';
import '../../cubit/employee_voice_cubit/employee_voice_state.dart';
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
