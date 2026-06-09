import 'dart:developer';

import 'package:auto_route/auto_route.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/app_snackBar/show_snackbar.dart';
import '../../../../core/widgets/gradient_scaffold/gradient_scaffold.dart';
import '../../../../core/widgets/loading_dialog/otp_loading_dialog.dart';
import '../cubit/mobile_number_cubit/mobile_number_cubit.dart';
import '../cubit/mobile_number_cubit/mobile_number_state.dart';
import '../../../splash/user_auth/presentation/cubit/otp_cubit.dart';
import '../../../splash/user_auth/presentation/cubit/otp_state.dart';
import '../widgets/mobile_number_screen_widgets/mobile_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {

  final MobileNumberCubit _mobileNumberCubit = MobileNumberCubit();

  @override
  void dispose() {
    _mobileNumberCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mobileNumberCubit,
      child: BlocListener<OtpCubit, OtpState>(
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
      
            final phone = (_mobileNumberCubit.state as MobileNumberInitial).mobileNumber;

            context.router.replace(
              OtpVerificationRoute(
                phone: phone,
              ),
            );
          }
      
          if (state is OtpError) {
            Navigator.pop(context);
            log(state.message);
            showAppSnackbar(context, message: state.message, icon: Icons.error);
          }
        },
        child: const GradientScaffold(
          resizeToAvoidBottomInset: false,
          body: MobileScreenBody(),
        ),
      ),
    );
  }
}
