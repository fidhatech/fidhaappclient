import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PremiumContactCard extends StatelessWidget {
  final String name;
  final String age;
  final String imageUrl;
  final int? audioCallRate;
  final int? videoCallRate;

  const PremiumContactCard({
    super.key,
    required this.name,
    required this.age,
    required this.imageUrl,
    this.onTap,
    this.onAudioCall,
    this.onVideoCall,
    this.isAudioEnabled = true,
    this.isVideoEnabled = true,
    this.isOnline = true,
    this.isBusy = false,
    this.audioCallRate,
    this.videoCallRate,
  });

  final VoidCallback? onTap;
  final VoidCallback? onAudioCall;
  final VoidCallback? onVideoCall;
  final bool isAudioEnabled;
  final bool isVideoEnabled;
  final bool isOnline;
  final bool isBusy;

  void _showDisabledSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "The user has disabled her video or audio. Try to call when the user comes back.",
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[900],
          border: isOnline
              ? Border.all(color: const Color(0xFF2E7D32), width: 1.5)
              : isBusy
                  ? Border.all(color: Colors.yellow, width: 1.5)
                  : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compactLayout =
                  constraints.maxHeight <= 250 || constraints.maxWidth <= 165;

              return Opacity(
                opacity: isOnline ? 1.0 : isBusy ? 0.85 : 0.6,
                child: Stack(
                  children: [
                Positioned.fill(
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[850],
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white24,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              _buildFallbackIcon(),
                        )
                      : _buildFallbackIcon(),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                          Colors.black.withValues(alpha: 0.9),
                        ],
                        stops: const [0, 0.5, 0.75, 1],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: compactLayout ? 8 : 12,
                  right: compactLayout ? 8 : 12,
                  bottom: compactLayout ? 10 : 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$name, $age',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: compactLayout ? 13 : 16,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isOnline || isBusy)
                            Container(
                              margin: const EdgeInsets.only(left: 3),
                              width: compactLayout ? 7 : 8,
                              height: compactLayout ? 7 : 8,
                              decoration: BoxDecoration(
                                color: isOnline
                                    ? const Color(0xFF4CAF50)
                                    : Colors.yellow,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: compactLayout ? 6 : 10),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildActionButton(
                              context,
                              icon: Icons.videocam_rounded,
                              label: 'Video',
                              isPrimary: true,
                              isCompact: compactLayout,
                              isActive: isVideoEnabled && isOnline,
                              isExplicitlyDisabled: !isVideoEnabled,
                              onTap: onVideoCall,
                              color: const Color(0xFF2E7D32),
                              rate: compactLayout ? null : videoCallRate,
                            ),
                          ),
                          SizedBox(width: compactLayout ? 3 : 6),
                          Expanded(
                            flex: 1,
                            child: _buildActionButton(
                              context,
                              icon: Icons.phone_rounded,
                              label: null,
                              isPrimary: true,
                              isCompact: true,
                              isActive: isAudioEnabled && isOnline,
                              isExplicitlyDisabled: !isAudioEnabled,
                              onTap: onAudioCall,
                              color: const Color(0xFF1565C0),
                              rate: null, // no room for rate chip at 25% width
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (!isOnline)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isBusy
                            ? Colors.yellow.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isBusy ? 'Busy' : 'Offline',
                        style: TextStyle(
                          color: isBusy ? Colors.yellow : Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    String? label,
    bool isPrimary = false,
    bool isCompact = false,
    required bool isActive,
    required bool isExplicitlyDisabled,
    VoidCallback? onTap,
    required Color color,
    int? rate,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isActive
                ? onTap
                : isExplicitlyDisabled
                ? () => _showDisabledSnackbar(context)
                : null,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: isPrimary ? double.infinity : null,
              constraints: isCompact
                ? const BoxConstraints(minHeight: 42)
                : null,
              padding: isCompact
                ? const EdgeInsets.symmetric(horizontal: 6, vertical: 10)
                : isPrimary
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 11)
                : const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isActive
                    ? color.withValues(alpha: 0.9)
                    : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(isCompact ? 18 : 30),
                border: Border.all(
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: isPrimary ? 8 : 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: isPrimary ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isActive ? Colors.white : Colors.white12,
                    size: isCompact ? 16 : isPrimary ? 20 : 16,
                  ),
                  if (label != null) ...[
                    SizedBox(width: isCompact ? 4 : 5),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.white24,
                          fontSize: isCompact ? 12 : isPrimary ? 13 : 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (rate != null && isActive) ...[
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.monetization_on_rounded,
                    size: 8,
                    color: Colors.amberAccent.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '$rate/min',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFallbackIcon() {
    return const Center(
      child: Icon(Icons.person, size: 40, color: Colors.white24),
    );
  }
}
