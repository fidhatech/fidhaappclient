import 'package:dating_app/features/user/features/user_profile/presentation/widget/profile_avatar/profile_avatar.dart';
import 'package:dating_app/features/user/features/user_profile/presentation/widget/profile_options/profile_options_list.dart';
import 'package:flutter/material.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          ProfileAvatar(),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ProfileOptionsList(),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
