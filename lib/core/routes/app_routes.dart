import '../../features/authentication/presentation/pages/mobile_number_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  static const String mobileNumber = '/mobile_number';
  //static const String userDetailsScreen = '/user_details_screen';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      mobileNumber: (context) => const MobileNumberScreen(),
      //userDetailsScreen: (context) => const UserDetailsScreen(),
    };
  }
}
