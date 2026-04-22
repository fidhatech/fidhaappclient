import 'package:dating_app/features/employee/profile/earning/widgets/withdraw_amount_view.dart';
import 'package:flutter/material.dart';

class WithdrawMoneyCard extends StatelessWidget {
  final double availableBalance;
  final Future<void> Function(int amount) onWithdraw;
  final bool isSubmitting;

  const WithdrawMoneyCard({
    super.key,
    required this.availableBalance,
    required this.onWithdraw,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), // Glassmorphism-ish base
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Withdraw Money",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Available: ₹${availableBalance.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: WithdrawAmountView(
                      availableBalance: availableBalance,
                      onWithdraw: onWithdraw,
                      isSubmitting: isSubmitting,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black, // Dark text on white button
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Request Withdrawal",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
