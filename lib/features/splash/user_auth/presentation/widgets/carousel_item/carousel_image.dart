import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/carousel_cubit.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/carousel_item/carousel_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    final double carouselHeight = screenHeightPercentage(context, 0.65);

    return SizedBox(
      height: carouselHeight,
      child: CarouselSlider(
        items: [
          CarouselItem(
            image: 'assets/images/onboarding_images/carousel_im1.png',
          ),
          CarouselItem(
            image: 'assets/images/onboarding_images/carousel_im2.png',
          ),
          CarouselItem(
            image: 'assets/images/onboarding_images/carousel_im3.png',
          ),
        ],
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
            context.read<CarouselCubit>().onPageChanged(index);
          },
        ),
      ),
    );
  }
}
