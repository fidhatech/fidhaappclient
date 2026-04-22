import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BalanceDisplay extends StatelessWidget {
  final int coins;
  final String message;

  const BalanceDisplay({super.key, required this.coins, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0635),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF8B2FC9),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B2FC9).withValues(alpha: 0.35),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.45),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/icons/coin-stack.svg',
              width: 64,
              height: 64,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wallet Balance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$coins Coins',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.isNotEmpty ? message : 'Top up to unlock features',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
