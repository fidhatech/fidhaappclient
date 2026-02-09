import 'package:dating_app/core/routes/app_routes.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';

import 'package:dating_app/core/widgets/loading_dialog/otp_loading_dialog.dart';
import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:dating_app/features/user/features/user_profile/cubit/profile_cubit.dart';
import 'package:dating_app/features/user/features/user_profile/presentation/screens/edit_profile_screen.dart';

import 'package:dating_app/features/user/features/user_profile/services/profile_service.dart';

import 'package:dating_app/features/user/features/user_profile/presentation/widget/profile_screen_body/profile_screen_body.dart';
import 'package:dating_app/features/user/features/user_profile/presentation/widget/profile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreenTab extends StatelessWidget {
  const ProfileScreenTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(profileService: ProfileService()),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            showLoadingDialog(context);
          } else if (state is LogoutSuccess) {
            Navigator.pop(context);
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.mobileNumber, (route) => false);
            showAppSnackbar(
              context,
              message: 'Logged out successfully',
              icon: Icons.check_circle,
              backgroundColor: Colors.green,
            );
          } else if (state is DeleteAccountSuccess) {
            Navigator.pop(context);
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.mobileNumber, (route) => false);
            showAppSnackbar(
              context,
              message: 'Account deleted successfully',
              icon: Icons.check_circle,
              backgroundColor: Colors.green,
            );
          } else if (state is LogoutFailure) {
            Navigator.pop(context);
            showAppSnackbar(context, message: state.error, icon: Icons.error);
          } else if (state is DeleteAccountFailure) {
            Navigator.pop(context);
            showAppSnackbar(context, message: state.error, icon: Icons.error);
          }
        },
        child: GradientScaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      final userCubit = context.read<UserCubit>();
                      final profileCubit = context.read<ProfileCubit>();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: userCubit),
                              BlocProvider.value(value: profileCubit),
                            ],
                            child: const EditProfileScreen(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
            title: const Text(
              "My Profile",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoading || state is UserInitial) {
                return const ProfileShimmer();
              } else if (state is ErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => context.read<UserCubit>().fetchUser(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const SafeArea(child: ProfileScreenBody());
            },
          ),
        ),
      ),
    );
  }
}
