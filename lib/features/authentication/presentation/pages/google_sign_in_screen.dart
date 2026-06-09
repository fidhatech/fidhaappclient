import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../../core/utils/app_start_decider.dart';
import '../../../../core/utils/mediaquery.dart';
import '../../../../core/widgets/app_snackBar/show_snackbar.dart';
import '../../../../core/widgets/custom_elevated_button/custom_elevated_button.dart';
import '../../../../core/widgets/gradient_scaffold/gradient_scaffold.dart';
import '../../../employee/main/employee_scope.dart';
import '../../../onboarding/presentation/pages/abroad_user_details_entry_screen.dart';
import '../../../user/features/navigation/user_scope.dart';
import '../../../splash/user_auth/presentation/cubit/google_signin_cubit/google_signin_cubit.dart';

@RoutePage()
class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {

  final GoogleSigninCubit _googleSignInCubit = GoogleSigninCubit();

  void _listenGoogleSignInCubit(BuildContext context, GoogleSigninState state) async {
    if (state is GoogleSigninSuccess) {
      //Navigator.pop(context);
      showAppSnackbar(
        context,
        message: 'Logged in successfully',
        icon: Icons.check_circle_outline,
        backgroundColor: Colors.green,
      );

      if (state.userExists) {
        ScaffoldMessenger.of(context).clearSnackBars();

        final status = await getIt.get<AppStartDecider>().determineStartStatus();

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
            MaterialPageRoute(builder: (context) => const UserScope()),
            (route) => false,
          );
        } else {
          showAppSnackbar(
            context,
            message: 'Could not determine user role',
            icon: Icons.error,
          );
        }
      } else {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => AbroadUserDetailsEntryScreen(
            email: state.email,
            name: '',
          ))
        );
      }
    } else if (state is GoogleSigninFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: ${state.error}')),
      );
    }
  }

  @override
  void dispose() {
    _googleSignInCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Text(
                'Continue with Google',
                style: TextStyle(
                  fontSize: controlWidth(context, 11.5),
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: controlHeight(context, 100)),
              Text(
                'Continue with your Google account to quickly set up your profile and start connecting with others.',
                textAlign: .center,
                style: TextStyle(
                  fontSize: controlWidth(context, 24),
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: controlHeight(context, 10)),
              BlocConsumer<GoogleSigninCubit, GoogleSigninState>(
                bloc: _googleSignInCubit,
                listener: _listenGoogleSignInCubit,
                builder: (context, state) => CustomButton(
                  onPressed: () {
                    _googleSignInCubit.signInWithGoogle();
                  },
                  text: 'Sign in with Google',
                  svgIcon: 'assets/icons/google.svg',
                  heightMultiplier: 16,
                  widthMultiplier: 0,
                ),
              ),
              SizedBox(height: controlHeight(context, 10)),
              Text(
                'By continuing, you agree to our Terms & Conditions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: MediaQuery.of(context).size.width * 0.0325,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}