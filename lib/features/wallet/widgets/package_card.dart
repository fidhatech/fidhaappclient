import 'package:dating_app/features/wallet/wallet.dart';
import 'package:flutter/material.dart';

import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

class PackageCard extends StatelessWidget {
  final CoinPackage package;
  final VoidCallback onTap;

  const PackageCard({super.key, required this.package, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/coin-stack.svg',
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${package.coins} Coins for ₹${package.offerPrice}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (package.offerPrice < package.actualPrice)
                      Text(
                        'Save ${(100 - (package.offerPrice / package.actualPrice * 100)).toStringAsFixed(0)}% • was ₹${package.actualPrice}',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: onTap,
                  child: const Text(
                    'Buy',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
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
