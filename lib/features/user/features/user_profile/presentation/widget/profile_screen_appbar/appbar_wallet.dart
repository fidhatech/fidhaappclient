import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarWalletIcon extends StatelessWidget {
  const AppBarWalletIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 75,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.primaryText, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Text('100')),
            const SizedBox(width: 4),
            SvgPicture.asset(
              'assets/icons/coin-stack.svg',
              width: 15,
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
