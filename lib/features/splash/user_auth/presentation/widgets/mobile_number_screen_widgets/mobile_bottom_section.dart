
import 'dart:developer';

import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/core/utils/url_helper.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/mobile_number_cubit.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/mobile_number_state.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Fixed bottom section with gradient overlay and OTP button
/// Positioned at the bottom of the screen with a fade-in gradient effect
class MobileBottomSection extends StatelessWidget {
  const MobileBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    log("📌 BottomSection built");

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        height: screenHeightPercentage(context, 0.30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocSelector<MobileNumberCubit, MobileNumberState, bool>(
              selector: (state) {
                if (state is MobileNumberInitial) {
                  return state.isValid;
                }
                return false;
              },
              builder: (context, isValid) {
                return ConfirmButtonWithText(
                  buttonText: 'Confirm',
                  bottomText:
                      'By continuing, you agree to our Terms & Conditions',
                  onBottomTextTap: () =>
                      UrlHelper.launchURL(AppUrls.termsAndConditions),
                  onTap: () {
                    log('Get otp button Pressed !!!!!!!!!!!11');

                    if (!isValid) {
                      showAppSnackbar(
                        context,
                        message: 'Please enter a valid mobile number',
                        icon: Icons.error,
                      );
                      return;
                    }

                    final phone =
                        (context.read<MobileNumberCubit>().state
                                as MobileNumberInitial)
                            .mobileNumber;

                    log("📨 Calling sendOtp for number: $phone");

                    context.read<OtpCubit>().sendOtp(phone);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
