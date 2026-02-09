import 'package:dating_app/features/onboarding/widgets/onboarding_content/onboarding_body.dart';
import 'package:dating_app/features/onboarding/widgets/onboarding_content/onboarding_footer.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/carousel_item/carousel_image.dart';

import 'package:flutter/material.dart';

/// Join Community Screen Body
class JoinCommunityScreenBody extends StatelessWidget {
  final Color? backgroundColor;

  const JoinCommunityScreenBody({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.black,
      body: Stack(
        children: const [CarouselImage(), OnboardingBody(), OnboardingFooter()],
      ),
    );
  }
}
