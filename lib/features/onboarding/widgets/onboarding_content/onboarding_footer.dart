import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/core/utils/network_checker.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/di/injection.dart';
import 'package:dating_app/features/onboarding/widgets/onboarding_content/onboarding_action_button.dart';
import 'package:dating_app/features/onboarding/widgets/onboarding_content/onboarding_terms_text.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/mobile_number_cubit.dart';
import 'package:dating_app/features/splash/user_auth/presentation/screens/mobile_number_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          padding: EdgeInsets.symmetric(horizontal: controlWidth(context, 17)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OnboardingActionButton(
                text: "Continue",
                onPressed: () async {
                  final checker = sl<NetworkChecker>();

                  final hasNetwork = await checker.isConnected;

                  if (!context.mounted) return;

                  if (!hasNetwork) {
                    showAppSnackbar(
                      context,
                      message: "Check your internet connection",
                      icon: Icons.signal_wifi_connected_no_internet_4_outlined,
                    );
                    return;
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => MobileNumberCubit(),
                        child: const MobileNumberScreen(),
                      ),
                    ),
                  );
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
