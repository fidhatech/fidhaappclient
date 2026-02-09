import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/utils/url_helper.dart';
import 'package:dating_app/core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/screens/employee_face_reveal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListenerVerificationScreen extends StatelessWidget {
  const ListenerVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            if (state.status == OnboardingStatus.success) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeFaceRevealScreen(),
                ),
                (route) => false,
              );
            } else if (state.status == OnboardingStatus.failure) {
              // showAppSnackbar(
              //   context,
              //   message: "Account not yet approved. Please try again later.",
              //   icon: Icons.error,
              // );
            }
          },
        ),
      ],
      child: GradientScaffold(
        body: RepaintBoundary(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: MediaQuery.paddingOf(context).top + 20,
              bottom: MediaQuery.paddingOf(context).bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Listener verification in\nprogress...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "To confirm your identity, please record yourself saying the following sentence.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ConfirmButtonWithText(
                    buttonText: 'Check Verification',
                    bottomText:
                        'By continuing, you agree to our Terms & Conditions',
                    onBottomTextTap: () =>
                        UrlHelper.launchURL(AppUrls.termsAndConditions),
                    onTap: () {
                      context.read<OnboardingBloc>().add(VerificationChecked());
                    },
                  ),
                ),
                const Spacer(),
                Center(
                  child: Image.asset(
                    "assets/images/employ_images/listener_verification_image.png",
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
