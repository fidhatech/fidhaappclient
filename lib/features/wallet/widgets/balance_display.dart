import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

class BalanceDisplay extends StatelessWidget {
  final int coins;
  final String message;

  const BalanceDisplay({super.key, required this.coins, required this.message});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber.withValues(alpha: 0.2),
                Colors.orange.withValues(alpha: 0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            children: [
              const Text(
                'Current Balance',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/icons/coin-stack.svg',
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$coins',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (message.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
