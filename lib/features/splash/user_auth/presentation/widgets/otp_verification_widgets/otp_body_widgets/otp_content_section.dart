import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/otp_verification_widgets/otp_body_widgets/resend_otp_row.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/otp_verification_widgets/otp_header_text.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/otp_verification_widgets/otp_illustration.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/otp_verification_widgets/otp_textfield.dart';
import 'package:flutter/material.dart';

/// Scrollable content section for OTP verification screen
class OtpContentSection extends StatelessWidget {
  final Function(String)? onOtpCompleted;
  final Function(String)? onOtpChanged;
  final VoidCallback? onResend;
  final Key? resendRowKey;

  const OtpContentSection({
    super.key,
    this.onOtpCompleted,
    this.onOtpChanged,
    this.onResend,
    this.resendRowKey,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: controlWidth(context, 22),
        right: controlWidth(context, 22),
        bottom: screenHeightPercentage(context, 0.30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: controlHeight(context, 13)),
          const OtpHeaderText(),
          SizedBox(height: controlHeight(context, 35)),
          OtpTextfield(onCompleted: onOtpCompleted, onChanged: onOtpChanged),

          SizedBox(height: controlHeight(context, 35)),
          ResendOtpRow(key: resendRowKey, onResend: onResend),
          SizedBox(height: controlHeight(context, 35)),
          const OtpIllustration(),
        ],
      ),
    );
  }
}
