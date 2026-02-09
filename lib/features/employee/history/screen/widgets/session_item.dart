import 'package:flutter/material.dart';

class SessionItem extends StatelessWidget {
  final String name;
  final String subtitle;
  final String imageUrl;

  const SessionItem({
    super.key,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Profile Avatar
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey[800],
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                child: imageUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white70)
                    : null,
              ),
              const SizedBox(width: 16),

              // Name and Age Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white24, height: 1),
      ],
    );
  }
}
