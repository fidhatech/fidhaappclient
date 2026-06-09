import 'dart:developer';

import 'widgets/app_bar_content.dart';
import 'widgets/app_bar_skeleton.dart';
import '../../../di/injection.dart';
import '../../../features/user/cubit/user_cubit.dart';
import '../../../features/user/features/user_profile/cubit/profile_cubit.dart';
import '../../../features/user/features/user_profile/presentation/screens/edit_profile_screen.dart';
import '../../../features/user/features/user_profile/services/profile_service.dart';
import '../../../features/wallet/cubit/wallet_cubit.dart';
import '../../../features/wallet/screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserInitial || state is UserLoading) {
          log('userloading');
          return const AppBarSkeleton();
        } else if (state is ErrorState) {
          log('error');
          return Center(child: Text(state.message));
        }
        if (state is UserLoaded) {
          log('userloaded');
          return AppBarContent(
            image: state.userModel.avatar,
            name: state.userModel.name,
            coins: state.userModel.coins.toString(),
            onProfileTap: () {
              final userCubit = context.read<UserCubit>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: userCubit),
                      BlocProvider(
                        create: (_) =>
                            ProfileCubit(profileService: ProfileService()),
                      ),
                    ],
                    child: const EditProfileScreen(),
                  ),
                ),
              );
            },
            onCoinTap: () {
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
          );
        }
        log('error');
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
