import 'package:dating_app/features/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PackageCard extends StatelessWidget {
  final CoinPackage package;
  final VoidCallback onTap;
  final bool isBestValue;

  const PackageCard({
    super.key,
    required this.package,
    required this.onTap,
    this.isBestValue = false,
  });

  String _formatPrice(double price) {
    return price % 1 == 0 ? price.toInt().toString() : price.toString();
  }

  @override
  Widget build(BuildContext context) {
    final hasDiscount = package.offerPrice < package.actualPrice;
    final discountPercent = (hasDiscount && package.actualPrice > 0)
        ? ((package.actualPrice - package.offerPrice) / package.actualPrice * 100).round()
        : 0;

    // Always show % OFF badge for discounted packages
    final Widget? discountBadge = (hasDiscount && discountPercent > 0)
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFCC00), Color(0xFFFF8A00)],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Text(
              '$discountPercent% OFF',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          )
        : null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0635),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF8B2FC9),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B2FC9).withValues(alpha: 0.3),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Space for top badge
              const SizedBox(height: 2),
              // Best value chip (inside card)
              if (isBestValue)
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFCC00), Color(0xFFFF8A00)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, color: Colors.white, size: 9),
                      SizedBox(width: 2),
                      Text(
                        'BEST VALUE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              // Coin icon
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.4),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/icons/coin-stack.svg',
                  height: 42,
                  width: 42,
                ),
              ),
              const SizedBox(height: 6),
              // Coins label
              Text(
                '${package.coins} Coins',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              // Offer price
              Text(
                '₹${_formatPrice(package.offerPrice)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (hasDiscount) ...[
                const SizedBox(height: 2),
                Text(
                  'was ₹${_formatPrice(package.actualPrice)}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                  ),
                ),
              ],
              const Spacer(),
              // BUY NOW button
              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFD61F45), Color(0xFFFF4D6D)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                    ),
                    onPressed: onTap,
                    child: const Text(
                      'BUY NOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (discountBadge != null)
          Positioned(
            top: 0,
            right: 0,
            child: discountBadge,
          ),
      ],
    );
  }
}
