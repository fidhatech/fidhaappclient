import 'package:dating_app/core/app/app_start_decider.dart';
import 'package:dating_app/core/widgets/app_confirmation%20dialog.dart/app_confirmation.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/core/widgets/loading_dialog/otp_loading_dialog.dart';

import 'package:dating_app/features/employee/main/employee_scope.dart';
import 'package:dating_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:dating_app/features/onboarding/screens/name_entry_screen.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/otp_cubit.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/otp_state.dart';
import 'package:dating_app/features/splash/user_auth/presentation/screens/mobile_number_screen.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/otp_verification_widgets/otp_body_widgets/otp_body.dart';

import 'package:dating_app/features/user/features/navigation/user_scope.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String phone;
  const OtpVerificationScreen({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldLeave = await showAppConfirmationDialog(
          context: context,
          title: "Leave OTP Verification",
          message: "Are you sure you want to stop verifying your OTP?",
          confirmText: "Yes",
          cancelText: "No",
        );

        if (shouldLeave == true) {
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MobileNumberScreen()),
          );
        }
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<OtpCubit, OtpState>(
            listener: (context, state) async {
              if (state is OtpLoading) {
                showLoadingDialog(context);
              } else if (state is OtpVerified) {
                Navigator.pop(context);
                showAppSnackbar(
                  context,
                  message: "OTP verified successfully",
                  icon: Icons.check_circle_outline,
                  backgroundColor: Colors.green,
                );

                await Future.delayed(const Duration(milliseconds: 500));

                if (!context.mounted) return;

                if (state.isExistingUser &&
                    state.userStage != 'PROFILE_INCOMPLETE') {
                  ScaffoldMessenger.of(context).clearSnackBars();

                  final status = await AppStartDecider.determineStartStatus();

                  if (!context.mounted) return;

                  if (status == AppStartStatus.employee) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const EmployeeScope(),
                      ),
                    );
                  } else if (status == AppStartStatus.client) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => UserScope()),
                      (route) => false,
                    );
                  } else {
                    showAppSnackbar(
                      context,
                      message: "Could not determine user role",
                      icon: Icons.error,
                    );
                  }
                } else {
                  context.read<OnboardingBloc>().add(PhoneSubmitted(phone));
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const NameEntryScreen()),
                    (route) => false,
                  );
                }
              } else if (state is OtpError) {
                Navigator.pop(context);
                showAppSnackbar(
                  context,
                  message: state.message,
                  icon: Icons.error,
                );
              } else if (state is OtpMessage) {
                Navigator.pop(context);
                showAppSnackbar(
                  context,
                  message: state.message,
                  icon: Icons.check_circle_outline,
                  backgroundColor: Colors.green,
                );
              }
            },
          ),
        ],
        child: GradientScaffold(
          resizeToAvoidBottomInset: false,
          body: OtpBody(phone: phone),
        ),
      ),
    );
  }
}
