import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class KycStatusCard extends StatelessWidget {
  final String kycStatus;
  final VoidCallback onVerifyTap;

  const KycStatusCard({
    super.key,
    required this.kycStatus,
    required this.onVerifyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'KYC Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getStatusMessage(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (kycStatus != 'verified') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onVerifyTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryButton,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  kycStatus == 'pending' ? 'Check Status' : 'Verify Now',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String badgeText;

    switch (kycStatus) {
      case 'verified':
        badgeColor = AppColor.enabledButton;
        badgeText = 'Verified';
        break;
      case 'pending':
        badgeColor = Colors.orange;
        badgeText = 'Pending';
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = 'Not Started';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getStatusMessage() {
    switch (kycStatus) {
      case 'verified':
        return 'Your KYC verification is complete. You can now withdraw your earnings.';
      case 'pending':
        return 'Your KYC verification is under review. This usually takes 24-48 hours.';
      default:
        return 'Complete KYC verification to withdraw your earnings.';
    }
  }
}
