import 'package:auto_route/auto_route.dart';

import '../../../../../config/theme/app_color.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/utils/mediaquery.dart';
import '../../../../../core/utils/network_checker.dart';
import '../../../../../core/widgets/app_snackBar/show_snackbar.dart';
import '../../../../../di/injection.dart';
import 'onboarding_action_button.dart';
import 'onboarding_terms_text.dart';

import 'package:flutter/material.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: screenHeightPercentage(context, 0.30),
        decoration: const BoxDecoration(
          color: AppColor.disabledButton,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const .symmetric(
            horizontal: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OnboardingActionButton(
                text: 'Continue',
                onPressed: () async {
                  final checker = sl<NetworkChecker>();

                  final hasNetwork = await checker.isConnected;

                  if (!context.mounted) return;

                  if (!hasNetwork) {
                    showAppSnackbar(
                      context,
                      message: 'Check your internet connection',
                      icon: Icons.signal_wifi_connected_no_internet_4_outlined,
                    );
                    return;
                  }

                  context.router.replace(const MobileNumberRoute());
                },
                backgroundColor: AppColor.primaryButton,
              ),
              SizedBox(height: controlHeight(context, 40)),
              OnboardingTermsText(
                text: '''Terms and Conditions Terms and\nConditions''',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
