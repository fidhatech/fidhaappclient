import 'package:flutter/material.dart';
import 'avatar_circle.dart';

import 'user_name_display.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AvatarCircle()],
        ),
        const SizedBox(height: 16),
        const UserNameDisplay(),
      ],
    );
  }
}
