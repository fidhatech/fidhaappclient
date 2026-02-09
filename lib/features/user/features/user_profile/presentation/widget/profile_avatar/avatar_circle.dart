import 'dart:io';
import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AvatarCircle extends StatelessWidget {
  const AvatarCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        String? avatarPath;
        if (state is UserLoaded) {
          avatarPath = state.userModel.avatar;
        }

        ImageProvider? backgroundImage;
        if (avatarPath != null && avatarPath.isNotEmpty) {
          if (avatarPath.startsWith('http')) {
            backgroundImage = NetworkImage(
              "$avatarPath?t=${DateTime.now().millisecondsSinceEpoch}",
            );
          } else {
            backgroundImage = FileImage(File(avatarPath));
          }
        }

        return Container(
          width: 139,
          height: 139,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE0E0E0),
            image: backgroundImage != null
                ? DecorationImage(image: backgroundImage, fit: BoxFit.cover)
                : null,
          ),
          child: backgroundImage == null
              ? const Icon(Icons.person, size: 60, color: Colors.grey)
              : null,
        );
      },
    );
  }
}
