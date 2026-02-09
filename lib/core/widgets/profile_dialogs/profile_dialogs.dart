import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/widgets/app_confirmation%20dialog.dart/app_confirmation.dart';
import 'package:dating_app/core/widgets/offer_popup_card/offer_popup_card.dart';

Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
  return await showAppConfirmationDialog(
    context: context,
    title: 'Log Out',
    message: 'Are you sure you want to log out?',
    confirmText: 'Log Out',
    confirmColor: AppColor.primaryButton,
  );
}

Future<bool> showDeleteAccountConfirmationDialog(BuildContext context) async {
  return await showAppConfirmationDialog(
    context: context,
    title: 'Delete Account',
    message:
        'Are you sure you want to delete your account? This action cannot be undone.',
    confirmText: 'Delete',
    confirmColor: Colors.red,
  );
}

Future<bool> showInsufficientCoinsConfirmationDialog(
  BuildContext context,
) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.6),
        builder: (context) {
          return OfferPopupCard(
            title: 'You are Out of Coins !',
            coins: 'Instant Refill',
            originalPrice: '',
            discountedPrice: 'Get Back In!',
            buttonText: 'Go to Wallet',
            onBuyNow: () {
              Navigator.pop(context, true);
            },
            onSkip: () {
              Navigator.pop(context, false);
            },
          );
        },
      ) ??
      false;
}
