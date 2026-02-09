import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/core/validators/app_validator.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:dating_app/features/onboarding/screens/dob_screen.dart';
import 'package:dating_app/features/onboarding/widgets/name_entry_screen_widgets/name_bottom_section.dart';
import 'package:dating_app/features/onboarding/widgets/name_entry_screen_widgets/name_scrollable_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameBody extends StatefulWidget {
  const NameBody({super.key});

  @override
  State<NameBody> createState() => _NameBodyState();
}

class _NameBodyState extends State<NameBody> {
  late final TextEditingController _controller;
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _isEnabled = AppValidators.name(value) == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Stack(
          children: [
            NameScrollableContent(
              bottomPadding: screenHeightPercentage(context, 0.30),
              controller: _controller,
              onChanged: _onChanged,
            ),

            NameBottomSection(
              isEnabled: _isEnabled,
              onPressed: () {
                if (AppValidators.name(_controller.text) == null) {
                  context.read<OnboardingBloc>().add(
                    NameSubmitted(_controller.text),
                  );
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const DobScreen()));
                } else {
                  showAppSnackbar(
                    context,
                    message: 'Dont fake your name',
                    icon: Icons.error,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
