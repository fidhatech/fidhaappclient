import 'package:dating_app/core/constants/app_urls.dart';

import 'package:dating_app/core/utils/url_helper.dart';
import 'package:dating_app/core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/core/widgets/loading_dialog/otp_loading_dialog.dart';
import 'package:dating_app/features/employee/main/employee_scope.dart';
import 'package:dating_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_face_reveal_cubit/employee_face_reveal_cubit.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/widgets/employee_face_reveal_widgets/employee_face_reveal_grid.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/widgets/employee_face_reveal_widgets/employee_face_reveal_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A screen that allows employees to reveal their face by uploading photos.
///
/// This screen uses [EmployeeFaceRevealCubit] to manage state.
/// It displays a grid of 4 slots where users can pick images from the gallery.
/// Users can also skip this step or confirm their selection.
class EmployeeFaceRevealScreen extends StatelessWidget {
  const EmployeeFaceRevealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EmployeeFaceRevealCubit(context.read<OnboardingBloc>()),
      child: Builder(
        builder: (context) {
          return GradientScaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<EmployeeFaceRevealCubit>().skip();
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: RepaintBoundary(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.paddingOf(context).bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.sizeOf(context).width / 17,
                              right: MediaQuery.sizeOf(context).width / 17,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const EmployeeFaceRevealHeader(),
                                const SizedBox(height: 20),
                                const EmployeeFaceRevealGrid(),
                              ],
                            ),
                          ),
                        ),

                        // Fixed button section at bottom
                        Container(
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
                            children: [
                              BlocListener<OnboardingBloc, OnboardingState>(
                                listener: (context, state) {
                                  if (state.status ==
                                      OnboardingStatus.loading) {
                                    return showLoadingDialog(context);
                                  }
                                  if (state.status ==
                                      OnboardingStatus.success) {
                                    Navigator.of(context);
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => EmployeeScope(),
                                      ),
                                    );
                                  }
                                },
                                child: ConfirmButtonWithText(
                                  buttonText: 'Confirm',
                                  bottomText:
                                      'By continuing, you agree to our Terms & Conditions',
                                  onBottomTextTap: () => UrlHelper.launchURL(
                                    AppUrls.termsAndConditions,
                                  ),
                                  onTap: () {
                                    context
                                        .read<EmployeeFaceRevealCubit>()
                                        .confirm();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
