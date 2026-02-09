import 'dart:ui';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

Future<bool> showAppConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = "Confirm",
  String cancelText = "Cancel",
  Color? confirmColor,
  Color? cancelColor,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.4),
        builder: (context) {
          final theme = Theme.of(context);

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColor.secondary.withValues(
                      alpha: 0.9,
                    ), // Less transparent
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColor.textFieldBorder.withValues(alpha: 0.5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColor.primaryText,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColor.secondaryText,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          // Cancel Button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context, false),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(
                                  color: AppColor.secondaryText.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              child: Text(
                                cancelText,
                                style: const TextStyle(
                                  color: AppColor.secondaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Confirm Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                backgroundColor:
                                    confirmColor ?? AppColor.primaryButton,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                confirmText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ) ??
      false;
}
