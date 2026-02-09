import 'package:flutter/material.dart';

/// Header widget displaying the title and subtitle instructions.
class EmployeeFaceRevealHeader extends StatelessWidget {
  const EmployeeFaceRevealHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text(
            'Time for a face reveal!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'To confirm your identity, please record yourself\nsaying the following sentence',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
