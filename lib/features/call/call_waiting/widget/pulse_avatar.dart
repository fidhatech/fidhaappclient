import 'package:flutter/material.dart';

class PulseAvatar extends StatefulWidget {
  final String? avatarUrl;
  final double size;

  const PulseAvatar({super.key, this.avatarUrl, this.size = 140});

  @override
  State<PulseAvatar> createState() => _PulseAvatarState();
}

class _PulseAvatarState extends State<PulseAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 💡 Optimization 1: Move static parts here so they aren't recreated inside the builder
    final staticAvatar = Stack(
      alignment: Alignment.center,
      children: [
        // Inner Glow (static)
        Container(
          width: widget.size * 0.9,
          height: widget.size * 0.9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        // Main Avatar (static image)
        Container(
          width: widget.size * 0.85,
          height: widget.size * 0.85,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.15),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 3,
            ),
            image: widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(widget.avatarUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: widget.avatarUrl == null || widget.avatarUrl!.isEmpty
              ? Icon(
                  Icons.person,
                  size: widget.size * 0.45,
                  color: Colors.white,
                )
              : null,
        ),
      ],
    );

    return AnimatedBuilder(
      animation: _controller,
      child: staticAvatar, // 💡 Optimization 2: Pass static widgets as child
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // 💡 Optimization 3: Use CustomPainter for the animated ripples
            // This is much lighter than creating 3 Opacity/Transform widgets per frame
            CustomPaint(
              size: Size(widget.size * 2, widget.size * 2),
              painter: _RipplePainter(
                progress: _controller.value,
                color: Colors.white.withValues(alpha: 0.4),
                baseSize: widget.size,
              ),
            ),
            child!, // This is the staticAvatar we defined above
          ],
        );
      },
    );
  }
}

/// Helper class to draw ripples efficiently on the canvas
class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double baseSize;

  _RipplePainter({
    required this.progress,
    required this.color,
    required this.baseSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final currentProgress = (progress + (i / 3)) % 1.0;
      final opacity = (1.0 - currentProgress).clamp(0.0, 1.0);
      final radius = (baseSize / 2) * (1.0 + (currentProgress * 0.8));

      paint.color = color.withValues(alpha: opacity * 0.4);
      canvas.drawCircle(size.center(Offset.zero), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
