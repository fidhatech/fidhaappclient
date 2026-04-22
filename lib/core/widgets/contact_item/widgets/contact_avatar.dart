import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  final String imageUrl;
  final bool isOnline;
  final bool isBusy;

  const ContactAvatar({
    super.key,
    required this.imageUrl,
    this.isOnline = true,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.person, color: Colors.white24),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.person, color: Colors.white24),
                    ),
                  )
                : Container(
                    color: Colors.grey[900],
                    child: const Icon(Icons.person, color: Colors.white24),
                  ),
          ),
        ),
        if (isOnline || isBusy)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: isOnline ? Colors.greenAccent : Colors.yellow,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: (isOnline ? Colors.greenAccent : Colors.yellow)
                        .withValues(alpha: 0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
