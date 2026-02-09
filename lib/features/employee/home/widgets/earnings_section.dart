import 'package:flutter/material.dart';
import 'package:dating_app/features/employee/home/widgets/earnings_card.dart';
import 'package:dating_app/features/employee/home/widgets/mini_stat_card.dart';

class EarningsSection extends StatelessWidget {
  final String todayEarnings;
  final String lifetimeEarnings;
  final int totalCalls;

  const EarningsSection({
    super.key,
    required this.todayEarnings,
    required this.lifetimeEarnings,
    required this.totalCalls,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EarningsCard(totalEarnings: todayEarnings),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MiniStatCard(
                icon: Icons.trending_up,
                title: 'Lifetime',
                value: '₹$lifetimeEarnings',

                iconColor: Colors.greenAccent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MiniStatCard(
                icon: Icons.call,
                title: 'Total Calls',
                value: '$totalCalls',
                // isLoading: isLoading,
                iconColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
