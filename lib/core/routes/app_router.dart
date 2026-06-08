import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../../features/splash/screens/splash_screen.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
  ];
}