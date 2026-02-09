import 'dart:developer';

import 'package:dating_app/core/widgets/app_bar/widgets/app_bar_content.dart';
import 'package:dating_app/core/widgets/app_bar/widgets/app_bar_skeleton.dart';
import 'package:dating_app/di/injection.dart';
import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:dating_app/features/user/features/navigation/cubit/navigator_cubit.dart';
import 'package:dating_app/features/wallet/cubit/wallet_cubit.dart';
import 'package:dating_app/features/wallet/screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserInitial || state is UserLoading) {
          log("userloading");
          return const AppBarSkeleton();
        } else if (state is ErrorState) {
          log("error");
          return Center(child: Text(state.message));
        }
        if (state is UserLoaded) {
          log("userloaded");
          return AppBarContent(
            image: state.userModel.avatar,
            name: state.userModel.name,
            coins: state.userModel.coins.toString(),
            onProfileTap: () => context.read<NavigatorCubit>().changePage(3),
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
        log("error");
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
