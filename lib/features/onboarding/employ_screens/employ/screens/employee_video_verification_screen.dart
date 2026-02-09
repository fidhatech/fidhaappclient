import 'package:dating_app/core/constants/app_urls.dart';

import 'package:dating_app/core/utils/url_helper.dart';
import 'package:dating_app/core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/screens/listener_verification_screen.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/widgets/employee_video_verification_widgets/intro_video_player.dart';
import 'package:flutter/material.dart';

class GettingStartedScreen extends StatelessWidget {
  const GettingStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
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
                // Scrollable content area
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 20,
                    bottom: MediaQuery.sizeOf(context).height * 0.30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "Getting Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          "Watch this short video to learn how to\nget started as a listener.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Center(child: IntroVideoPlayer()),
                      const SizedBox(height: 20),
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
                      children: [
                        ConfirmButtonWithText(
                          buttonText: 'Confirm',
                          bottomText:
                              'By continuing, you agree to our Terms & Conditions',
                          onBottomTextTap: () =>
                              UrlHelper.launchURL(AppUrls.termsAndConditions),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ListenerVerificationScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
