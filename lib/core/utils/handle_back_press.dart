import 'package:flutter/material.dart';
import 'package:dating_app/core/widgets/app_confirmation dialog.dart/app_confirmation.dart';

/// A reusable back handler that asks a confirmation
/// and then navigates to ANY screen you pass.
///
/// [target] = the screen/widget you want to go to.
Future<void> handleBackNavigation(
  BuildContext context, {
  required Widget target,
  String title = "Are you sure?",
  String message = "Do you want to go back?",
  String confirmText = "Yes",
  String cancelText = "No",
}) async {
  final shouldLeave = await showAppConfirmationDialog(
    context: context,
    title: title,
    message: message,
    confirmText: confirmText,
    cancelText: cancelText,
  );

  if (shouldLeave == true) {
    if (!context.mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => target));
  }
}

/// A reusable back handler that asks a confirmation
/// and then runs a callback if confirmed.
///
/// [onAction] = the callback to run if confirmed.
Future<void> handleBackAction(
  BuildContext context, {
  required VoidCallback onAction,
  String title = "Are you sure?",
  String message = "Do you want to proceed?",
  String confirmText = "Yes",
  String cancelText = "No",
  Color? confirmColor,
}) async {
  final shouldProceed = await showAppConfirmationDialog(
    context: context,
    title: title,
    message: message,
    confirmText: confirmText,
    cancelText: cancelText,
    confirmColor: confirmColor,
  );

  if (shouldProceed == true) {
    if (!context.mounted) return;
    onAction();
  }
}
