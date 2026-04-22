import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class ContactGridCard extends StatelessWidget {
  final String name;
  final String age;
  final String imageUrl;
  final Color primaryButtonColor;
  final double cardWidth;
  final double cardHeight;
  final Function onVideo;
  final Function onCall;
  final bool isAudioEnabled;
  final bool isVideoEnabled;
  final bool isOnline;
  final bool isBusy;

  const ContactGridCard({
    super.key,
    required this.name,
    required this.age,
    required this.imageUrl,
    this.primaryButtonColor = const Color(0xFF333333),
    this.cardWidth = 0.35,
    this.cardHeight = 0.4,
    required this.onVideo,
    required this.onCall,
    this.isAudioEnabled = true,
    this.isVideoEnabled = true,
    this.isOnline = true,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    final computedCardWidth = screenWidthPercentage(context, cardWidth);
    final computedCardHeight = screenWidthPercentage(context, cardHeight);

    // Responsive calculations based on card width
    // Fixed button height to match design consistency similar to premium cards
    final buttonHeight = 30.0;
    final iconSize = 16.0;
    final nameFontSize = computedCardWidth * 0.1;
    final ageFontSize = computedCardWidth * 0.075;
    final borderRadius = computedCardWidth * 0.12;

    return Container(
      width: computedCardWidth,
      height: computedCardHeight,
      decoration: BoxDecoration(
        color: Colors.black, // Default black background
        borderRadius: BorderRadius.circular(borderRadius),
        image: imageUrl.isNotEmpty
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
      ),
      child: Stack(
        children: [
          // Gradient Overlay for text readability
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.5, 0.7, 1.0],
              ),
            ),
          ),

          // Status dot (green = online, yellow = busy)
          if (isOnline || isBusy)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isOnline ? Colors.greenAccent : Colors.yellow,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: (isOnline ? Colors.greenAccent : Colors.yellow)
                          .withValues(alpha: 0.6),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),

          // Content
          Padding(
            padding: EdgeInsets.all(computedCardWidth * 0.075),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Name
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: nameFontSize,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: computedCardHeight * 0.02),
                // Age
                Text(
                  '$age Y',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ageFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: computedCardHeight * 0.05),

                // Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Video Button (Pill shape)
                    Expanded(
                      child: InkWell(
                        onTap: isVideoEnabled && isOnline
                            ? () => onVideo()
                            : null,
                        child: Container(
                          height: buttonHeight,
                          decoration: BoxDecoration(
                            color: isVideoEnabled && isOnline
                                ? const Color(0xFF2E7D32) // Green
                                : const Color(0xFF222222), // Dark grey
                            borderRadius: BorderRadius.circular(
                              buttonHeight / 2,
                            ),
                          ),
                          child: Icon(
                            Icons.videocam,
                            color: isVideoEnabled && isOnline
                                ? Colors.white
                                : Colors.white24,
                            size: iconSize,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: computedCardWidth * 0.06),
                    // Call Button (Circle)
                    InkWell(
                      onTap: isAudioEnabled && isOnline ? () => onCall() : null,
                      child: Container(
                        height: buttonHeight,
                        width: buttonHeight,
                        decoration: BoxDecoration(
                          color: isAudioEnabled && isOnline
                              ? const Color(0xFF2E7D32) // Green
                              : const Color(0xFF222222), // Dark grey
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.phone,
                          color: isAudioEnabled && isOnline
                              ? Colors.white
                              : Colors.white24,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
