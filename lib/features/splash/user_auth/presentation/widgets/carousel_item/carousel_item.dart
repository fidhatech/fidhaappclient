import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {
  final String? title;
  final String image;

  const CarouselItem({super.key, this.title, required this.image});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(
        image,
        fit: BoxFit.cover,
        height: screenHeightPercentage(context, 0.64),
      ),
    );
  }
}
