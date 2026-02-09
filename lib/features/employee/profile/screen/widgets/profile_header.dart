import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;

  const ProfileHeader({super.key, required this.name, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.blue.shade300,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null
              ? const Icon(Icons.person, size: 60, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
