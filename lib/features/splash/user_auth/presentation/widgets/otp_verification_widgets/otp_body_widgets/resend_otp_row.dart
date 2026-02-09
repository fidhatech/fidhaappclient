import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

/// A stateless row containing a timer and a resend button.
///
/// The timer starts automatically when built.
/// To restart the timer (e.g., after clicking Resend), the parent widget
/// must rebuild this widget with a new [Key].
class ResendOtpRow extends StatelessWidget {
  final VoidCallback? onResend;

  const ResendOtpRow({super.key, this.onResend});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 60, end: 0),
      duration: const Duration(minutes: 1),
      builder: (context, value, child) {
        final minutes = value ~/ 60;
        final seconds = value % 60;
        final isFinished = value == 0;

        return SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Don't receive code? ",
                style: TextStyle(fontSize: 14, color: AppColor.secondaryText),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: isFinished ? onResend : null,
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isFinished
                            ? AppColor.highlightColor
                            : AppColor.secondaryText,
                        decoration: TextDecoration.underline,
                        decorationColor: isFinished
                            ? AppColor.highlightColor
                            : AppColor.secondaryText,
                      ),
                    ),
                  ),
                  if (!isFinished) ...[
                    const SizedBox(width: 5),
                    Text(
                      "(${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')})",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColor.highlightColor,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
