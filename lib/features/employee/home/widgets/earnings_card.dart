import 'package:dating_app/features/employee/profile/earning/screen/earning_screen.dart';
import 'package:flutter/material.dart';

class EarningsCard extends StatelessWidget {
  final String totalEarnings;
  // final bool isLoading;

  const EarningsCard({
    super.key,
    required this.totalEarnings,
    // required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EarningScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Earnings',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // if (isLoading)
            //   Shimmer.fromColors(
            //     baseColor: Colors.white.withValues(alpha: 0.4),
            //     highlightColor: Colors.white.withValues(alpha: 0.8),
            //     child: Container(
            //       width: 120,
            //       height: 32,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //   )
            // else
            Text(
              '₹$totalEarnings',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
