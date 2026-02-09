import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';

class InterestsWrap extends StatelessWidget {
  final List<String> interests;

  const InterestsWrap({super.key, required this.interests});

  @override
  Widget build(BuildContext context) {
    if (interests.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: interests
          .map(
            (e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColor.inputFill,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                e,
                style: const TextStyle(
                  color: AppColor.secondaryText,
                  fontSize: 10,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
