import 'package:dating_app/core/widgets/landing_page_card/glass_card.dart';
import 'package:flutter/material.dart';

class LandingPageCard extends StatelessWidget {
  final VoidCallback? onTap;

  final String imageUrl;
  final String headText;
  final String subText;
  const LandingPageCard({
    super.key,
    required this.imageUrl,
    required this.headText,
    required this.subText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 480,
      width: size.width * 0.9,
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 10,
          shadowColor: Colors.white.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: GlassInfoCard(
                    width: size.width * 0.66,
                    height: 85,
                    title: headText,
                    subtitle: subText,
                    borderColor: Colors.black.withValues(alpha: 0.1),
                    backgroundColor: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
