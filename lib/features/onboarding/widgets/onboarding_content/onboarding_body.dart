import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/features/onboarding/widgets/onboarding_content/gradient_overlay.dart';
import 'package:dating_app/features/onboarding/widgets/onboarding_content/onboarding_content.dart';

import 'package:dating_app/features/splash/user_auth/presentation/cubit/carousel_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: screenHeightPercentage(context, 0.30),
      left: 0,
      right: 0,
      child: GradientOverlay(
        child: BlocBuilder<CarouselCubit, CarouselState>(
          builder: (context, state) {
            return OnboardingContent(
              title: 'Join Our\nCommunity',
              subtitle: 'To get started, tell us who you are.',
              buttonText: 'Continue',
              termsText: 'Terms and Conditions Terms and\nConditions',
              currentPage: state.currentPage,
              totalPages: state.totalPages,
            );
          },
        ),
      ),
    );
  }
}
