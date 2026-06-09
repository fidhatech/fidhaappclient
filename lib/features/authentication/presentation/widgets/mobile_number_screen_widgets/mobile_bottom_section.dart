
import 'dart:developer';

import 'package:auto_route/auto_route.dart';

import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/utils/mediaquery.dart';
import '../../../../../core/utils/url_helper.dart';
import '../../../../../core/widgets/app_snackBar/show_snackbar.dart';
import '../../../../../core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import '../../cubit/mobile_number_cubit/mobile_number_cubit.dart';
import '../../cubit/mobile_number_cubit/mobile_number_state.dart';
import '../../../../splash/user_auth/presentation/cubit/otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/network_checker.dart';
import '../../../../../core/widgets/custom_elevated_button/custom_elevated_button.dart';
import '../../../../../di/injection.dart';

/// Fixed bottom section with gradient overlay and OTP button
/// Positioned at the bottom of the screen with a fade-in gradient effect
class MobileBottomSection extends StatelessWidget {
  const MobileBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    log('📌 BottomSection built');

    return SizedBox(
      width: double.infinity,
      height: screenHeightPercentage(context, 0.45),
    
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Login for outside of India',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
          ),
          Padding(
            padding: .only(
              left: controlWidth(context, 16),
              right: controlWidth(context, 16),
              bottom: controlHeight(context, 20),
              top: controlHeight(context, 80),
            ),
            child: CustomButton(
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

                context.router.replace(const GoogleSignInRoute());
              },
              text: 'Sign in with Google',
              svgIcon: 'assets/icons/google.svg',
              heightMultiplier: 16,
              widthMultiplier: 0,
            ),
          ),
          const Spacer(),
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
          
                  log('📨 Calling sendOtp for number: $phone');
          
                  context.read<OtpCubit>().sendOtp(phone);
                },
              );
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
