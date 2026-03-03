import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class KycSubmitButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;
  final String text;

  const KycSubmitButton({
    super.key,
    required this.isEnabled,
    this.isLoading = false,
    required this.onPressed,
    this.text = 'Submit',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Security message
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user, color: AppColor.enabledButton, size: 18),
            const SizedBox(width: 8),
            Text(
              'We keep your information 100% secure',
              style: TextStyle(
                color: AppColor.enabledButton,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Submit button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled && !isLoading ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled
                  ? AppColor.primaryButton
                  : AppColor.disabledButton,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isEnabled
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
