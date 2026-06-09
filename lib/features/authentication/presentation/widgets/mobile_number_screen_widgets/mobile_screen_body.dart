import '../../../../../core/utils/mediaquery.dart';
import 'mobile_bottom_section.dart';
import 'mobile_scrollable_content.dart';

import 'package:flutter/material.dart';

/// Main body widget for the Mobile Number Screen
/// Contains a stack with scrollable content and fixed bottom section
class MobileScreenBody extends StatelessWidget {
  const MobileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: screenHeightPercentage(context, 0.01),
        ),
        child: Stack(
          //alignment: .center,
          children: [
            //SizedBox(height: 800),
            // Scrollable content area
            MobileScrollableContent(
              bottomPadding: screenHeightPercentage(context, 0.075),
            ),

            // Fixed button section at bottom
            const Align(
              alignment: Alignment.bottomCenter,
              child: MobileBottomSection()
            ),
          ],
        ),
      ),
    );
  }
}
