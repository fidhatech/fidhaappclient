import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/mobile_number_screen_widgets/mobile_header.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/mobile_number_screen_widgets/mobile_illustration.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/mobile_number_screen_widgets/mobile_input.dart';
import 'package:flutter/material.dart';

/// Scrollable content section containing header, input field, and illustration
class MobileScrollableContent extends StatelessWidget {
  final double bottomPadding;

  const MobileScrollableContent({super.key, required this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: controlWidth(context, 22),
        right: controlWidth(context, 22),
        bottom: bottomPadding, // Space for fixed button section
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: controlHeight(context, 13)),
          const MobileHeader(),
          SizedBox(height: controlHeight(context, 35)),
          MobileInput(),
          SizedBox(height: controlHeight(context, 35)),
          const MobileIllustration(),
        ],
      ),
    );
  }
}
