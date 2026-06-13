import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../features/authentication/presentation/pages/google_sign_in_screen.dart';
import '../../features/authentication/presentation/pages/mobile_number_screen.dart';
import '../../features/authentication/presentation/pages/otp_verification_screen.dart';
import '../../features/onboarding/presentation/pages/abroad_user_details_entry_screen.dart';
import '../../features/onboarding/presentation/pages/dob_screen.dart';
import '../../features/onboarding/presentation/pages/gender_selection_screen.dart';
import '../../features/onboarding/presentation/pages/join_community_screen.dart';
import '../../features/onboarding/presentation/pages/name_entry_screen.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/user/presentation/pages/user_details_screen.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),

    AutoRoute(page: GoogleSignInRoute.page),
    AutoRoute(page: MobileNumberRoute.page),
    AutoRoute(page: OtpVerificationRoute.page),

    AutoRoute(page: JoinCommunityRoute.page),
    AutoRoute(page: AbroadUserDetailsEntryRoute.page),
    AutoRoute(page: DobRoute.page),
    AutoRoute(page: GenderSelectionRoute.page),
    AutoRoute(page: NameEntryRoute.page),

    AutoRoute(page: UserDetailsRoute.page),
  ];
}