import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/mobile_number_screen_widgets/mobile_bottom_section.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/mobile_number_screen_widgets/mobile_scrollable_content.dart';

import 'package:flutter/material.dart';

/// Main body widget for the Mobile Number Screen
/// Contains a stack with scrollable content and fixed bottom section
class MobileScreenBody extends StatelessWidget {
  const MobileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Stack(
          children: [
            SizedBox(height: 800),
            // Scrollable content area
            MobileScrollableContent(
              bottomPadding: screenHeightPercentage(context, 0.30),
            ),

            // Fixed button section at bottom
            const MobileBottomSection(),
          ],
        ),
      ),
    );
  }
}
