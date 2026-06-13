import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../assets_gen/assets.gen.dart';
import '../../../../core/utils/mediaquery.dart';
import '../../../splash/user_auth/presentation/cubit/carousel_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/firebase_notification_service.dart';
import '../widgets/onboarding_content/onboarding_content.dart';
import '../widgets/onboarding_content/onboarding_footer.dart';

@RoutePage()
class JoinCommunityScreen extends StatefulWidget {
  const JoinCommunityScreen({super.key});

  @override
  State<JoinCommunityScreen> createState() => _JoinCommunityScreenState();
}

class _JoinCommunityScreenState extends State<JoinCommunityScreen> {

  final CarouselCubit _carouselCubit = CarouselCubit(totalPages: 3);

  final List<String> _carouselImages = [
    Assets.images.onboardingImages.carouselIm1.path,
    Assets.images.onboardingImages.carouselIm2.path,
    Assets.images.onboardingImages.carouselIm3.path,
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      getIt.get<FirebaseNotificationService>().checkAndRequestPermission(context);
    });
  }

  @override
  void dispose() {
    _carouselCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double carouselHeight = screenHeightPercentage(context, 0.65);
    return BlocProvider.value(
      value: _carouselCubit,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SizedBox(
              height: carouselHeight,
              child: CarouselSlider(
                items: _carouselImages.map(
                  (e) => Image.asset(
                    e,
                    width: .infinity,
                    height: .infinity,
                    fit: BoxFit.cover,
                  ),
                ).toList(),
                options: CarouselOptions(
                  height: carouselHeight,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  scrollDirection: Axis.horizontal,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    _carouselCubit.onPageChanged(index);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: screenHeightPercentage(context, 0.30),
              left: 0,
              right: 0,
              child: Container(
                padding: const .symmetric(
                  horizontal: 20.0, 
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.6), 
                      Colors.black.withValues(alpha: 0.9),
                      Colors.black, 
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
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
            ), 
            const OnboardingFooter(),
          ],
        ),
      ),
    );
  }
}
