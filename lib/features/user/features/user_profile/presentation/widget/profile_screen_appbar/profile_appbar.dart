import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dating_app/features/user/features/user_profile/presentation/widget/profile_screen_appbar/appbar_wallet.dart';

import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData leadingIcon;
  final VoidCallback? onLeadingPressed;
  final double titleSpacing;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final Color? iconColor;

  final String? profileImage;
  final String? coin;
  final String? userName;

  const ProfileAppBar({
    super.key,
    required this.title,
    this.leadingIcon = Icons.arrow_back,
    this.onLeadingPressed,
    this.titleSpacing = 0,
    this.backgroundColor,
    this.titleStyle,
    this.iconColor,
    this.profileImage,
    this.coin,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          children: [
            if (profileImage != null) ...[
              CircleAvatar(
                backgroundImage: NetworkImage(profileImage!),
                radius: 16,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              userName ?? title,
              style:
                  titleStyle ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      titleSpacing: titleSpacing,
      elevation: 0,
      actions: [
        if (coin != null)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryText, width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(coin!),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/icons/coin-stack.svg',
                      width: 15,
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: AppBarWalletIcon(),
          ),
      ],
      actionsPadding: EdgeInsets.zero,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
