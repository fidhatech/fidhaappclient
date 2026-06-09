import '../../../../core/widgets/app_confirmation%20dialog.dart/app_confirmation.dart';
import '../../../../core/widgets/gradient_scaffold/gradient_scaffold.dart';
import '../widgets/name_entry_screen_widgets/name_body.dart';
import '../../../authentication/presentation/pages/mobile_number_screen.dart';

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
          title: 'Are you sure?',
          message: 'You want to go back to mobile number screen?',
          confirmText: 'Yes',
          cancelText: 'No',
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
      child: const GradientScaffold(
        resizeToAvoidBottomInset: false,

        body: NameBody(),
      ),
    );
  }
}
