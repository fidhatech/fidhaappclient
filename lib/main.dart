import 'config/theme/app_theme.dart';
import 'core/globals/keys.dart';
import 'core/network/cubit/network_status_cubit.dart';
import 'core/routes/app_router.dart';
import 'core/widgets/offline_screen/offline_screen.dart';
import 'di/injection.dart';
import 'core/services/local_notification_service.dart';
import 'core/services/firebase_notification_service.dart';
import 'core/services/firebase_analytics_service.dart';
import 'core/services/meta_app_events_service.dart';
import 'features/onboarding/bloc/onboarding_bloc.dart';
import 'features/splash/user_auth/domain/usecases/resend_otp_usecase.dart';
import 'features/splash/user_auth/domain/usecases/send_otp_usecase.dart';
import 'features/splash/user_auth/domain/usecases/verify_otp_usecase.dart';
import 'features/authentication/presentation/cubit/mobile_number_cubit/mobile_number_cubit.dart';
import 'features/splash/user_auth/presentation/cubit/otp_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/di.dart';
import 'features/user/features/call/cubit/client_call_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  await Firebase.initializeApp();

  init();
  await LocalNotificationService.init();
  await LocalNotificationService.restorePendingNotificationAction(
    forceLaunchDetailsCheck: true,
  );
  
  await getIt.get<FirebaseNotificationService>().init();
  await FirebaseAnalyticsService.init();
  await MetaAppEventsService.init();
  await MetaAppEventsService.logAppOpened();

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
        BlocProvider(create:(context) => ClientCallCubit())
      ],

      child: BlocBuilder<NetworkStatusCubit, NetworkStatusState>(
        builder: (context, networkState) => MaterialApp.router(
          //navigatorKey: SocketSessionManager.navigatorKey,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          title: 'Fidha',
          theme: AppTheme.main,
          routerConfig: getIt.get<AppRouter>().config(
            navigatorObservers: () => [
              FirebaseAnalyticsService.observer,
            ],
          ),
          builder: (context, child) {
            return Stack(
              children: [
                ?child,
                if (networkState.status == NetworkStatus.offline)
                  const Positioned.fill(child: OfflineScreen()),
              ],
            );
          },
        ),
      ),
    ),
  );
}
