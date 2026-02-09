import 'package:dating_app/core/constants/app_urls.dart';

import 'package:dating_app/core/utils/url_helper.dart';
import 'package:dating_app/core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import 'package:dating_app/core/widgets/loading_dialog/otp_loading_dialog.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_language_cubit/employee_language_cubit.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_language_cubit/employee_language_state.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/screens/employee_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'employee_info_header.dart';
import 'employee_interests.dart';
import 'employee_about_input.dart';

class EmployeeScreenBody extends StatelessWidget {
  final TextEditingController aboutController;
  final VoidCallback onConfirm;

  const EmployeeScreenBody({
    super.key,
    required this.aboutController,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: RepaintBoundary(
        child: Stack(
          children: [
            // Scrollable content area
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).width / 17,
                  right: MediaQuery.sizeOf(context).width / 17,
                  bottom: MediaQuery.sizeOf(context).height * 0.30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height / 40),
                    const EmployeeInfoHeader(),
                    const SizedBox(height: 20),
                    const SizedBox(height: 16),
                    const EmployeeInterests(),
                    const SizedBox(height: 16),
                    EmployeeAboutInput(controller: aboutController),
                  ],
                ),
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
                  children: [
                    BlocListener<EmployeeLanguageCubit, EmployeeLanguageState>(
                      listener: (context, state) {
                        final languageCubit = context
                            .read<EmployeeLanguageCubit>();
                        if (state is EmployeeLanguageLoading) {
                          return showLoadingDialog(context);
                        }
                        if (state is LanguageLoaded) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: languageCubit,
                                child: EmployeeLanguageScreen(
                                  languages: state.languages,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: ConfirmButtonWithText(
                        buttonText: 'Confirm',
                        bottomText:
                            'By continuing, you agree to our Terms & Conditions',
                        onBottomTextTap: () =>
                            UrlHelper.launchURL(AppUrls.termsAndConditions),
                        onTap: onConfirm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
