import 'package:dating_app/features/splash/user_auth/presentation/cubit/otp_cubit.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/otp_verification_widgets/otp_body_widgets/otp_button_section.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/otp_verification_widgets/otp_body_widgets/otp_content_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpBody extends StatefulWidget {
  final String phone;
  final String? buttonText;

  const OtpBody({super.key, required this.phone, this.buttonText});

  @override
  State<OtpBody> createState() => _OtpBodyState();
}

class _OtpBodyState extends State<OtpBody> {
  String otp = "";
  bool isEnabled = false;
  int _resendRowIndex = 0;

  void _onOtpChanged(String value) {
    setState(() {
      otp = value;
      isEnabled = otp.length == 6;
    });
  }

  void _onResend() {
    context.read<OtpCubit>().resendOtp(widget.phone);
    setState(() {
      _resendRowIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Stack(
          children: [
            // Scrollable content section
            OtpContentSection(
              onOtpChanged: _onOtpChanged,
              onOtpCompleted: (value) {
                _onOtpChanged(value);
                if (value.length == 6) {
                  context.read<OtpCubit>().verifyOtp(widget.phone, value);
                }
              },
              onResend: _onResend,
              resendRowKey: ValueKey(_resendRowIndex),
            ),

            // Button section
            OtpButtonSection(
              isEnabled: isEnabled,
              buttonText: widget.buttonText ?? 'Verify OTP',
              onPressed: isEnabled
                  ? () {
                      context.read<OtpCubit>().verifyOtp(widget.phone, otp);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
