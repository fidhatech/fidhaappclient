import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/core/widgets/loading_dialog/otp_loading_dialog.dart';
import 'package:dating_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_voice_cubit/employee_voice_cubit.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_voice_cubit/employee_voice_state.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/screens/employee_video_verification_screen.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/widgets/employee_voice_widgets/employee_voice_confirm_button.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/widgets/employee_voice_widgets/employee_voice_header.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/widgets/employee_voice_widgets/employee_voice_recording_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeVoiceScreen extends StatelessWidget {
  final String selectedLanguage;
  final String textToRead;
  const EmployeeVoiceScreen({
    super.key,
    required this.selectedLanguage,
    required this.textToRead,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeVoiceCubit(selectedLanguage: selectedLanguage),
      child: MultiBlocListener(
        listeners: [
          BlocListener<EmployeeVoiceCubit, EmployeeVoiceState>(
            listener: (context, state) {
              if (state is EmployeeVoiceError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<OnboardingBloc, OnboardingState>(
            listener: (context, state) {
              if (state.status == OnboardingStatus.loading) {
                return showLoadingDialog(context);
              } else if (state.status == OnboardingStatus.onDioError) {
                Navigator.of(context, rootNavigator: true).pop();
                showAppSnackbar(
                  context,
                  message: "Check your internet connection and try again.",
                  icon: Icons.error,
                );
              } else if (state.status == OnboardingStatus.moreDetailsRequired) {
                Navigator.of(context, rootNavigator: true).pop();
                // Final Navigation to Success/Home Screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GettingStartedScreen(),
                  ),
                );
              } else if (state.status == OnboardingStatus.failure) {
                showAppSnackbar(
                  context,
                  message: "Failed to upload. Try again.",
                  icon: Icons.error,
                );
              }
            },
          ),
        ],
        child: GradientScaffold(
          body: RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top,
                bottom: MediaQuery.paddingOf(context).bottom,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Stack(
                  children: [
                    // Main content
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.sizeOf(context).width / 17,
                        right: MediaQuery.sizeOf(context).width / 17,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height / 20,
                          ),
                          // Fixed Header
                          const EmployeeVoiceHeader(),
                          const SizedBox(height: 30),
                          // Scrollable Card Area
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.sizeOf(context).height * 0.25,
                              ),
                              child: EmployeeVoiceRecordingCard(
                                textToRead: textToRead,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Fixed button section at bottom
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [const EmployeeVoiceConfirmButton()],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
