import 'dart:developer';

import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/core/widgets/loading_dialog/otp_loading_dialog.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/mobile_number_cubit.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/mobile_number_state.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/otp_cubit.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/otp_state.dart';
import 'package:dating_app/features/splash/user_auth/presentation/screens/otp_verification_screen.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/mobile_number_screen_widgets/mobile_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileNumberScreen extends StatelessWidget {
  const MobileNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpLoading) {
          showLoadingDialog(context);
        }

        if (state is OtpMessage) {
          Navigator.pop(context);

          showAppSnackbar(
            context,
            message: state.message,
            icon: Icons.check_circle_outline,
            backgroundColor: Colors.green,
          );

          final phone =
              (context.read<MobileNumberCubit>().state as MobileNumberInitial)
                  .mobileNumber;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OtpVerificationScreen(phone: phone),
            ),
          );
        }

        if (state is OtpError) {
          Navigator.pop(context);
          log(state.message);
          showAppSnackbar(context, message: state.message, icon: Icons.error);
        }
      },
      child: GradientScaffold(
        resizeToAvoidBottomInset: false,
        body: const MobileScreenBody(),
      ),
    );
  }
}
