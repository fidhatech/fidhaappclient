import 'package:flutter/material.dart';

class KycHeader extends StatelessWidget {
  const KycHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        // KYC Icon with glow effect
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFCF2BAD).withValues(alpha: 0.3),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
            child: Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFCF2BAD).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCF2BAD), width: 2),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: Color(0xFFCF2BAD),
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'KYC Verification',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Complete your verification to unlock\nexclusive benefits and rewards',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
