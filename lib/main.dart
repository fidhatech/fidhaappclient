import 'package:dating_app/app.dart';

import 'package:dating_app/core/network/cubit/network_status_cubit.dart';
import 'package:dating_app/di/injection.dart';
import 'package:dating_app/core/services/app_lifecycle_service.dart';
import 'package:dating_app/core/services/local_notification_service.dart';
import 'package:dating_app/core/services/firebase_notification_service.dart';
import 'package:dating_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:dating_app/features/splash/user_auth/domain/usecases/resend_otp_usecase.dart';
import 'package:dating_app/features/splash/user_auth/domain/usecases/send_otp_usecase.dart';
import 'package:dating_app/features/splash/user_auth/domain/usecases/verify_otp_usecase.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/mobile_number_cubit.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  init();
  await LocalNotificationService.init();
  await FirebaseNotificationService.init();
  AppLifecycleService().init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MobileNumberCubit()),
        BlocProvider(create: (_) => OnboardingBloc()),
        BlocProvider(
          create: (_) => OtpCubit(
            sendOtpUsecase: sl<SendOtpUsecase>(),
            verifyOtpUsecase: sl<VerifyOtpUsecase>(),
            resendOtpUsecase: sl<ResendOtpUsecase>(),
          ),
        ),
        BlocProvider(create: (_) => sl<NetworkStatusCubit>()),
      ],

      child: const MyApp(),
    ),
  );
}
