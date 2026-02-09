import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/core/utils/url_helper.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/di/injection.dart';
import 'package:dating_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_info_cubit/employee_info_cubit.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_language_cubit/employee_language_cubit.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/screens/employee_info_screen.dart';
import 'package:dating_app/features/onboarding/widgets/gender_selection_screen_widgets/gender_avatar_selector.dart';
import 'package:dating_app/features/onboarding/widgets/gender_selection_screen_widgets/gender_header.dart';
import 'package:dating_app/features/onboarding/widgets/gender_selection_screen_widgets/gender_selection_chips.dart';

import 'package:dating_app/features/user/features/navigation/user_scope.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? selectedGender = 'Male';
  String? selectedAvatar;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: controlWidth(context, 17),
                  right: controlWidth(context, 17),
                  bottom: screenHeightPercentage(context, 0.30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: controlHeight(context, 40)),

                    const GenderHeader(),

                    SizedBox(height: controlHeight(context, 21)),
                    GenderSelectionChips(
                      selectedGender: selectedGender,
                      onGenderSelected: (gender) {
                        if (selectedGender != gender) {
                          setState(() {
                            selectedGender = gender;
                            selectedAvatar = null;
                          });
                        }
                      },
                    ),

                    SizedBox(height: controlHeight(context, 40)),
                    GenderAvatarSelector(
                      gender: selectedGender,
                      selectedAvatar: selectedAvatar,
                      onAvatarSelected: (avatar) {
                        setState(() {
                          selectedAvatar = avatar;
                        });
                      },
                    ),
                    SizedBox(height: controlHeight(context, 20)),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: screenHeightPercentage(context, 0.30),
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
                    children: [
                      MultiBlocListener(
                        listeners: [
                          BlocListener<OnboardingBloc, OnboardingState>(
                            listenWhen: (previous, current) =>
                                previous.status != current.status,
                            listener: (context, state) {
                              if (state.status ==
                                  OnboardingStatus.moreDetailsRequired) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) =>
                                              EmployeeInfoCubit(),
                                        ),
                                        BlocProvider(
                                          create: (context) =>
                                              sl<EmployeeLanguageCubit>(),
                                        ),
                                      ],
                                      child: EmployeeInfoScreen(),
                                    ),
                                  ),
                                );
                              } else if (state.status ==
                                  OnboardingStatus.success) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserScope(),
                                  ),
                                  (route) => false,
                                );
                              } else if (state.status ==
                                  OnboardingStatus.failure) {
                                showAppSnackbar(
                                  context,
                                  message:
                                      "Submission failed. Please try again.",
                                  icon: Icons.error,
                                );
                              }
                            },
                          ),
                        ],
                        child: ConfirmButtonWithText(
                          buttonText: 'Confirm',
                          bottomText:
                              'By continuing, you agree to our Terms & Conditions',
                          onBottomTextTap: () =>
                              UrlHelper.launchURL(AppUrls.termsAndConditions),
                          isEnabled:
                              selectedGender != null && selectedAvatar != null,
                          onTap: () {
                            if (selectedGender != null &&
                                selectedAvatar != null) {
                              context.read<OnboardingBloc>().add(
                                GenderAvatarSubmitted(
                                  gender: selectedGender!,
                                  avatar: selectedAvatar!,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
