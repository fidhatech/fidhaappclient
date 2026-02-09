import 'package:dating_app/di/injection.dart';
import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/widgets/profile_dialogs/profile_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/features/user/features/user_profile/cubit/profile_cubit.dart';
import 'package:dating_app/features/user/features/user_profile/presentation/widget/profile_options/profile_option_tile.dart';
import 'package:dating_app/features/wallet/cubit/wallet_cubit.dart';
import 'package:dating_app/features/wallet/screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileOptionsList extends StatelessWidget {
  const ProfileOptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OptionTile(
          icon: Icons.account_balance_wallet_outlined,
          label: "Wallet",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => sl<WalletCubit>()..loadWalletData(),
                  child: const WalletScreen(),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        OptionTile(
          icon: Icons.description_outlined,
          label: "Terms and Conditions",
          onTap: () async {
            final Uri url = Uri.parse(AppUrls.termsAndConditions);
            if (!await launchUrl(url)) {}
          },
        ),
        const SizedBox(height: 8),
        OptionTile(
          icon: Icons.logout,
          label: "Log Out",
          onTap: () async {
            final confirmed = await showLogoutConfirmationDialog(context);
            if (confirmed && context.mounted) {
              context.read<ProfileCubit>().logout();
            }
          },
        ),
        const SizedBox(height: 8),
        OptionTile(
          icon: Icons.delete_outline,
          label: "Delete Account",
          textColor: AppColor.primaryPink,
          iconColor: AppColor.primaryPink,
          onTap: () async {
            final confirmed = await showDeleteAccountConfirmationDialog(
              context,
            );
            if (confirmed && context.mounted) {
              context.read<ProfileCubit>().deleteAccount();
            }
          },
        ),
      ],
    );
  }
}
