import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/widgets/app_confirmation%20dialog.dart/app_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showTermsConditionDialog(BuildContext context) async {
  final confirmed = await showAppConfirmationDialog(
    context: context,
    title: 'Terms and Conditions',
    message:
        'You are about to be redirected to our Terms and Conditions page. Do you want to continue?',
    confirmText: 'Continue',
    confirmColor: AppColor.primaryButton,
  );

  if (confirmed) {
    const url =
        'https://vibily-app-documentation.gitbook.io/vibily_documentation';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch Terms and Conditions'),
          ),
        );
      }
    }
  }
}
