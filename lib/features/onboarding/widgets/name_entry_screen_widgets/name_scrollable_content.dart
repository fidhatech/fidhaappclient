import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/features/onboarding/widgets/name_entry_screen_widgets/name_header.dart';
import 'package:dating_app/features/onboarding/widgets/name_entry_screen_widgets/name_input_field.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/otp_verification_widgets/otp_illustration.dart';

import 'package:flutter/material.dart';

class NameScrollableContent extends StatelessWidget {
  final double bottomPadding;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const NameScrollableContent({
    super.key,
    required this.bottomPadding,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: controlWidth(context, 20),
        right: controlWidth(context, 20),
        bottom: bottomPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: controlHeight(context, 25)),
          const NameHeader(),
          SizedBox(height: controlHeight(context, 30)),
          NameInputField(controller: controller, onChanged: onChanged),
          SizedBox(height: controlHeight(context, 25)),
          Center(
            child: const OtpIllustration(
              imagePath:
                  'assets/images/onboarding_images/user_name_screen_image.png',
              bubbleText: 'What is your name ?',
            ),
          ),
        ],
      ),
    );
  }
}
