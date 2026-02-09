import 'package:flutter/material.dart';

class PremiumProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final String name;

  const PremiumProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF9C27B0), width: 3),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey[800],
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                child: imageUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white70, size: 30)
                    : null,
              ),
            ),

            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFFFFE0E0),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Playfair Display',
          ),
        ),
      ],
    );
  }
}
