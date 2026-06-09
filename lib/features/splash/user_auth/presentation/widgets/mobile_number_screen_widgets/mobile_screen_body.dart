import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/mobile_number_screen_widgets/mobile_bottom_section.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/mobile_number_screen_widgets/mobile_scrollable_content.dart';

import 'package:flutter/material.dart';

import '../../../../../../config/theme/app_color.dart';
import '../../../../../../core/utils/network_checker.dart';
import '../../../../../../core/widgets/app_snackBar/show_snackbar.dart';
import '../../../../../../core/widgets/custom_elevated_button/custom_elevated_button.dart';
import '../../../../../../di/injection.dart';
import '../../../../../onboarding/widgets/onboarding_content/onboarding_action_button.dart';
import '../../../../../authentication/presentation/pages/google_sign_in_screen.dart';

/// Main body widget for the Mobile Number Screen
/// Contains a stack with scrollable content and fixed bottom section
class MobileScreenBody extends StatelessWidget {
  const MobileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: screenHeightPercentage(context, 0.01),
        ),
        child: Stack(
          //alignment: .center,
          children: [
            //SizedBox(height: 800),
            // Scrollable content area
            MobileScrollableContent(
              bottomPadding: screenHeightPercentage(context, 0.075),
            ),

            //SizedBox(height: controlHeight(context, 80)),
              // OnboardingActionButton(
              //   text: "Continue for Users Outside India",
              //   onPressed: () async {
              //     final checker = sl<NetworkChecker>();

              //     final hasNetwork = await checker.isConnected;

              //     if (!context.mounted) return;

              //     if (!hasNetwork) {
              //       showAppSnackbar(
              //         context,
              //         message: "Check your internet connection",
              //         icon: Icons.signal_wifi_connected_no_internet_4_outlined,
              //       );
              //       return;
              //     }

              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const GoogleSignInScreen(),
              //       ),
              //     );
              //   },
              //   backgroundColor: AppColor.primaryButton,
              // ),

            // Fixed button section at bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: const MobileBottomSection()
            ),
          ],
        ),
      ),
    );
  }
}
