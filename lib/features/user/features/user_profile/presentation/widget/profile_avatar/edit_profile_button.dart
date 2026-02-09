import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:dating_app/features/user/features/user_profile/cubit/profile_cubit.dart';
import 'package:dating_app/features/user/features/user_profile/presentation/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit, color: Colors.white),
          SizedBox(width: 4),
          Text('Edit', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
