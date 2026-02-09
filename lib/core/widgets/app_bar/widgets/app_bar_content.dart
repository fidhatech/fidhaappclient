import 'package:dating_app/core/widgets/app_bar/widgets/app_bar_body.dart';
import 'package:dating_app/core/widgets/app_bar/widgets/ribbon_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarContent extends StatelessWidget {
  final String image;
  final String name;
  final String coins;
  final VoidCallback? onProfileTap;
  final VoidCallback? onCoinTap;

  const AppBarContent({
    super.key,
    required this.image,
    required this.name,
    required this.coins,
    this.onProfileTap,
    this.onCoinTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarBody(
      left: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.40,
        ),
        child: GestureDetector(
          onTap: onProfileTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade800,
                backgroundImage:
                    (image.isNotEmpty && !image.startsWith('file:///'))
                    ? NetworkImage(
                        "$image?t=${DateTime.now().millisecondsSinceEpoch}",
                      )
                    : null,
                child: image.isEmpty || image.startsWith('file:///')
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Hello',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      center: const RibbonLogoText(),
      right: GestureDetector(
        onTap: onCoinTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                coins,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              SvgPicture.asset(
                'assets/icons/coin-stack.svg',
                height: 18,
                width: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
