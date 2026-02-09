import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserNameDisplay extends StatelessWidget {
  const UserNameDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return Text(
            state.userModel.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
