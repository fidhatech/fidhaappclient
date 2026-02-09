import 'package:dating_app/core/widgets/app_confirmation%20dialog.dart/app_confirmation.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/onboarding/widgets/name_entry_screen_widgets/name_body.dart';
import 'package:dating_app/features/splash/user_auth/presentation/screens/mobile_number_screen.dart';

import 'package:flutter/material.dart';

class NameEntryScreen extends StatelessWidget {
  const NameEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await showAppConfirmationDialog(
          context: context,
          title: "Are you sure?",
          message: "You want to go back to mobile number screen?",
          confirmText: "Yes",
          cancelText: "No",
        );
        if (shouldLeave == true) {
          if (!context.mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return const MobileNumberScreen();
              },
            ),
          );
        }
      },
      child: GradientScaffold(
        resizeToAvoidBottomInset: false,

        body: NameBody(),
      ),
    );
  }
}
