import 'package:dating_app/config/theme/app_theme.dart';

import 'package:dating_app/features/splash/screens/splash_screen.dart';
import 'package:dating_app/core/services/firebase_analytics_service.dart';
import 'package:dating_app/core/services/socket_session_manager.dart';

import 'package:flutter/material.dart';
import 'package:dating_app/core/globals/keys.dart';
import 'package:dating_app/core/network/cubit/network_status_cubit.dart';
import 'package:dating_app/core/routes/app_routes.dart';
import 'package:dating_app/core/widgets/offline_screen/offline_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkStatusCubit, NetworkStatusState>(
      builder: (context, networkState) {
        return MaterialApp(
          navigatorKey: SocketSessionManager.navigatorKey,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          title: 'Fidha',
          theme: AppTheme.main,
          navigatorObservers: [FirebaseAnalyticsService.observer],
          routes: AppRoutes.getRoutes(),
          home: const SplashScreen(),
          builder: (context, child) {
            return Stack(
              children: [
                ?child,
                if (networkState.status == NetworkStatus.offline)
                  const Positioned.fill(child: OfflineScreen()),
              ],
            );
          },
        );
      },
    );
  }
}
