import 'package:dating_app/features/splash/user_auth/presentation/screens/mobile_number_screen.dart';
import 'package:flutter/material.dart';

import 'package:dating_app/features/user/features/details/presentation/screens/user_details_screen.dart';

class AppRoutes {
  static const String mobileNumber = '/mobile_number';
  static const String userDetailsScreen = '/user_details_screen';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      mobileNumber: (context) => const MobileNumberScreen(),
      userDetailsScreen: (context) => const UserDetailsScreen(),
    };
  }
}
